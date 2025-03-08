import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/business/presentation/pages/business_main.dart';
import 'package:gas/features/business/presentation/pages/business_stat_page.dart';
import 'package:gas/features/consumer/presentation/bloc/consumer_bloc.dart';
import 'package:gas/features/employee/presentation/cubit/employee_cubit.dart';
import 'package:gas/features/vehicle/presentation/pages/vehicle_main_page.dart';
import 'package:gas/features/delivery/presentation/pages/delivery_page.dart';
import 'package:gas/features/home/presentation/widgets/home_widget.dart';
import 'package:gas/features/employee/presentation/pages/profile_page.dart';
import 'package:gas/features/consumer/presentation/pages/consumer_main_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _activeItem = 0;

  @override
  void initState() {
    super.initState();
    context.read<BusinessCubit>().initBusinessSubscription();
    context.read<ConsumerBloc>().add(GetAllConsumersEvent());
    context.read<EmployeeCubit>().initEmployeeSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      bottomNavigationBar: _bottomNavigationBar(context),
      floatingActionButton: _bottomNavItem()[_activeItem]['showFloating']
          ? CommonFloatingActionButton(
              onPressed: _bottomNavItem()[_activeItem]['floatingOnPressed'],
              icon: _bottomNavItem()[_activeItem]['floatingIcon'])
          : null,
      body: Column(
        children: [
          SizedBox(height: 5.h),
          HomePageHeader(
            topText: _bottomNavItem()[_activeItem]['label'],
            bottomText: DateFormat('dd MMM, yyyy').format(DateTime.now()),
            onNotificationPressed: () {},
            actionIcon: _bottomNavItem()[_activeItem]['actionIcon'],
          ),
          SizedBox(height: 10.h),
          Expanded(child: _bottomNavItem()[_activeItem]['page'])
        ],
      ),
    );
  }

  Container _bottomNavigationBar(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:
          BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_bottomNavItem().length, (i) {
          final item = _bottomNavItem()[i];
          return IconButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: _activeItem == i
                    ? Theme.of(context).primaryColor.withOpacity(1)
                    : Colors.transparent,
                padding:
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)),
            icon: Icon(_activeItem == i ? item['activeIcon'] : item['icon'],
                color: _activeItem == i ? Colors.white : Colors.black),
            onPressed: item['onPressed'],
          );
        }),
      ),
    );
  }

  List _bottomNavItem() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final businesses = context.watch<BusinessCubit>().state.businesses;

    final alreadyBusiness = businesses.any((e) =>
        e.owners.any((e) => e.id == uid) ||
        e.admins.any((e) => e.id == uid) ||
        e.requests.any((e) => e.id == uid) ||
        e.employees.any((e) => e.id == uid));
    BusinessParams? myBusiness;
    if (alreadyBusiness) {
      myBusiness = businesses.firstWhere((e) =>
          e.owners.any((e) => e.id == uid) ||
          e.admins.any((e) => e.id == uid) ||
          e.requests.any((e) => e.id == uid) ||
          e.employees.any((e) => e.id == uid));
      context.read<BusinessCubit>().updateMyBusinessParams(myBusiness: [
        MyBusinessParams(
          business: myBusiness.business,
          myRole: myBusiness.owners.any((e) => e.id == uid)
              ? "Owner"
              : myBusiness.admins.any((e) => e.id == uid)
                  ? "Admin"
                  : myBusiness.employees.any((e) => e.id == uid)
                      ? "Employee"
                      : myBusiness.requests.any((e) => e.id == uid)
                          ? "Requested"
                          : "",
        )
      ]);
    }
    return [
      {
        "icon": Iconsax.shop,
        "activeIcon": Iconsax.shop,
        "label":
            alreadyBusiness ? myBusiness?.business.name ?? "" : "My Business",
        "page":
            alreadyBusiness ? const BusinessStatPage() : const BusinessMain(),
        "floatingIcon": Iconsax.shop_add,
        "floatingOnPressed": () =>
            Navigator.pushNamed(context, AppRoutes.addOrg),
        "showFloating": !alreadyBusiness,
        "actionIcon": Iconsax.search_normal_1,
        "actionOnPressed": () {},
        "onPressed": () => setState(() => _activeItem = 0)
      },
      {
        "icon": Iconsax.user_add,
        "activeIcon": Iconsax.user_add,
        "label": "Consumer Panel",
        "page": const ConsumerMainPage(),
        "floatingIcon": Iconsax.add,
        "floatingOnPressed": () =>
            Navigator.pushNamed(context, AppRoutes.addUser),
        "showFloating": true,
        "actionIcon": Iconsax.search_normal_1,
        "actionOnPressed": () {},
        "onPressed": () => setState(() => _activeItem = 1)
      },
      {
        "icon": Iconsax.truck,
        "activeIcon": Iconsax.truck,
        "label": "Track Vehicle",
        "page": const VehicleMainPage(),
        "floatingIcon": Iconsax.add,
        "floatingOnPressed": () {},
        "showFloating": true,
        "actionIcon": null,
        "actionOnPressed": () {},
        "onPressed": () => setState(() => _activeItem = 2)
      },
      {
        "icon": Iconsax.box,
        "activeIcon": Iconsax.box,
        "label": "Delivery Panel",
        "page": const DeliveryPage(),
        "floatingIcon": Iconsax.add,
        "floatingOnPressed": () {},
        "showFloating": true,
        "actionIcon": Iconsax.search_normal_1,
        "actionOnPressed": () {},
        "onPressed": () => setState(() => _activeItem = 3)
      },
      {
        "icon": Iconsax.user_octagon,
        "activeIcon": Iconsax.user_octagon,
        "label": "Profile Settings",
        "page": const ProfilePage(),
        "floatingIcon": Iconsax.add,
        "floatingOnPressed": () {},
        "showFloating": false,
        "actionIcon": null,
        "actionOnPressed": () {},
        "onPressed": () => setState(() => _activeItem = 4)
      },
    ];
  }
}
