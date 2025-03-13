import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/business/presentation/pages/employee_track_page.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:badges/badges.dart' as badge;
import 'package:iconsax/iconsax.dart';

class BusinessStatPage extends StatefulWidget {
  const BusinessStatPage({super.key});

  @override
  State<BusinessStatPage> createState() => _BusinessStatPageState();
}

class _BusinessStatPageState extends State<BusinessStatPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final businesses = state.businesses;

        final alreadyBusiness = businesses.any((e) =>
            e.owners.any((e) => e.employee.id == uid) ||
            e.admins.any((e) => e.employee.id == uid) ||
            e.requests.any((e) => e.employee.id == uid) ||
            e.employees.any((e) => e.employee.id == uid));
        BusinessParams? myBusiness;
        String myRole = "Employee";
        if (alreadyBusiness) {
          myBusiness = businesses.firstWhere((e) =>
              e.owners.any((e) => e.employee.id == uid) ||
              e.admins.any((e) => e.employee.id == uid) ||
              e.requests.any((e) => e.employee.id == uid) ||
              e.employees.any((e) => e.employee.id == uid));
          myRole = myBusiness.business.owners.contains(uid)
              ? "Owner"
              : myBusiness.business.admins.contains(uid)
                  ? "Admin"
                  : myBusiness.business.requests.contains(uid)
                      ? "Requested"
                      : myBusiness.business.employees.contains(uid)
                          ? "Employee"
                          : "";
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: myRole == "Requested"
                  ? _requestedUI
                  : [
                      if ((myBusiness?.admins ?? []).isNotEmpty)
                        _employeeGrid(
                            title: 'Admins',
                            children: List.generate(
                                myBusiness?.admins.length ?? 0,
                                (i) => _employeeTile(
                                    employee:
                                        (myBusiness?.admins ?? [])[i].employee,
                                    role: 'Admin'))),
                      if ((myBusiness?.employees ?? []).isNotEmpty)
                        _employeeGrid(
                            title: 'Employees',
                            children: List.generate(
                                myBusiness?.employees.length ?? 0,
                                (i) => _employeeTile(
                                    employee: (myBusiness?.employees ?? [])[i]
                                        .employee,
                                    role: 'Employee'))),
                      if ((myBusiness?.requests ?? []).isNotEmpty)
                        _employeeGrid(
                            title: 'Requests',
                            children: List.generate(
                                myBusiness?.requests.length ?? 0,
                                (i) => _employeeTile(
                                    employee: (myBusiness?.requests ?? [])[i]
                                        .employee,
                                    role: 'Requested'))),
                    ],
            ),
          ),
        );
      },
    );
  }

  Container _employeeGrid(
      {required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runAlignment: WrapAlignment.center,
            spacing: 20.w,
            runSpacing: 20.w,
            children: children,
          ),
        ],
      ),
    );
  }

  List<Widget> get _requestedUI {
    return [
      SizedBox(height: 200.h),
      CachedNetworkImage(
        height: 50.h,
        width: 50.h,
        fit: BoxFit.cover,
        imageUrl: "https://cdn-icons-png.flaticon.com/128/5956/5956828.png",
      ),
      SizedBox(height: 30.h),
      const Text("Request Pending...",
          style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 10.h),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 70.w),
        child: const Text(
          "Your request is pending approval. Please wait while we process your submission.",
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  _employeeTile({required EmployeeModel employee, required String role}) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => EmployeeTrackPage(employeeID: employee.id))),
      child: SizedBox(
        width: 70.h,
        child: Column(
          children: [
            badge.Badge(
              badgeContent: Icon(
                role == "Admin"
                    ? Iconsax.shield_tick5
                    : role == "Requested"
                        ? Iconsax.clock5
                        : Iconsax.flash_15,
                color: Colors.white,
                size: 10.r,
              ),
              position: badge.BadgePosition.bottomEnd(end: 1.w, bottom: 1.h),
              badgeStyle: badge.BadgeStyle(
                  badgeColor: role == "Admin"
                      ? AppColors.green500
                      : role == "Requested"
                          ? Colors.orange
                          : AppColors.blue500),
              child: ClipOval(
                  child: CachedNetworkImage(
                imageUrl: employee.avatar,
                height: 60.h,
                width: 60.h,
                fit: BoxFit.cover,
              )),
            ),
            SizedBox(height: 8.h),
            Text(
              employee.name.split(" ").first,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
