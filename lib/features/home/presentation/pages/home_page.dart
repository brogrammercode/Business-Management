import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(),
      bottomNavigationBar: _bottomNavigationBar(context),
      floatingActionButton: _bottomNavItem()[_activeItem]['showFloating']
          ? CommonFloatingActionButton(
              onPressed: _bottomNavItem()[_activeItem]['floatingOnPressed'],
              icon: _bottomNavItem()[_activeItem]['floatingIcon'])
          : null,
      body: Column(
        children: [
          SizedBox(height: 15.h),
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
    return [
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
        "onPressed": () => setState(() => _activeItem = 0)
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
        "onPressed": () => setState(() => _activeItem = 1)
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
        "onPressed": () => setState(() => _activeItem = 2)
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
        "onPressed": () => setState(() => _activeItem = 3)
      },
    ];
  }
}