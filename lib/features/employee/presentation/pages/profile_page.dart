// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/employee/presentation/cubit/employee_cubit.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EmployeeCubit, EmployeeState>(
      listener: (context, state) {},
      builder: (context, state) {
        EmployeeModel? user;
        if (state.user.isNotEmpty) {
          user = state.user.first.employee;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.h),
              _dp(image: user?.avatar ?? ""),
              SizedBox(height: 10.h),
              Text(
                user?.name ?? "",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                () {
                  final businesses =
                      context.watch<BusinessCubit>().state.businesses;
                  final userId = user?.id ?? "";

                  if (businesses.any(
                    (e) => e.owners.any((owner) => owner.employee.id == userId),
                  )) {
                    return "Owner";
                  }
                  if (businesses.any(
                    (e) => e.requests.any(
                      (request) => request.employee.id == userId,
                    ),
                  )) {
                    return "Requested";
                  }
                  if (businesses.any(
                    (e) => e.admins.any((admin) => admin.employee.id == userId),
                  )) {
                    return "Admin";
                  }
                  if (businesses.any(
                    (e) => e.employees.any(
                      (employee) => employee.employee.id == userId,
                    ),
                  )) {
                    return "Employee";
                  }
                  return "";
                }(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.frame_1),
                        SizedBox(width: 20.w),
                        const Text(
                          "Your Profile",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Iconsax.arrow_right_3),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Iconsax.dollar_circle),
                        SizedBox(width: 20.w),
                        const Text(
                          "Salary & Earnings",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Icon(Iconsax.arrow_right_3),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  final success = await context.read<EmployeeCubit>().signOut();
                  if (success) {
                    Navigator.pushReplacementNamed(context, AppRoutes.auth);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.unlock),
                          SizedBox(width: 20.w),
                          const Text(
                            "Log out",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      state.signOutStatus == StateStatus.loading
                          ? SizedBox(
                            height: 20.h,
                            width: 20.h,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Iconsax.arrow_right_3),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Center _dp({required String image}) {
    return Center(
      child: SizedBox(
        height: 135.h,
        width: 135.h,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            height: 125.h,
            width: 125.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(.15), blurRadius: 10),
              ],
              border: Border.all(color: Colors.white, width: 7.w),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                height: 125.h,
                width: 125.h,
                fit: BoxFit.cover,
                imageUrl: image,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
