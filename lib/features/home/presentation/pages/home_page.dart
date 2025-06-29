// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/local_notification.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/employee/presentation/cubit/employee_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    LocalNotification.initialize();
    context.read<HomeCubit>().initializeIsLocationEnabledListener();
    context.read<BusinessCubit>().initBusinessSubscription();
    context.read<EmployeeCubit>().initEmployeeSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        final businesses = state.businesses;

        final alreadyBusiness = businesses.any(
          (e) =>
              e.owners.any((e) => e.employee.id == uid) ||
              e.admins.any((e) => e.employee.id == uid) ||
              e.employees.any((e) => e.employee.id == uid),
        );
        BusinessParams? myBusiness;
        String myRole = "Employee";
        if (alreadyBusiness) {
          myBusiness = businesses.firstWhere(
            (e) =>
                e.owners.any((e) => e.employee.id == uid) ||
                e.admins.any((e) => e.employee.id == uid) ||
                e.requests.any((e) => e.employee.id == uid) ||
                e.employees.any((e) => e.employee.id == uid),
          );

          context.read<BusinessCubit>().updateBusinessID(
            businessID: myBusiness.business.id,
          );
          myRole = myBusiness.business.owners.contains(uid)
              ? "Owner"
              : myBusiness.business.admins.contains(uid)
              ? "Admin"
              : myBusiness.business.requests.contains(uid)
              ? "Requested"
              : myBusiness.business.employees.contains(uid)
              ? "Employee"
              : "";

          log(myRole);
        }

        if (!alreadyBusiness ||
            state.getBusinessStatus == StateStatus.loading) {
          return _empty(
            businesses: businesses.map((e) => e.business).toList(),
            myBusiness: myBusiness?.business,
            alreadyBusiness: alreadyBusiness,
          );
        }
        final deliveries = context.read<DeliveryCubit>().state.deliveries;
        final DeliveryModel? recentDelivery = deliveries.isEmpty
            ? null
            : deliveries.reduce(
                (a, b) => a.deliveryTD.toDate().isAfter(b.deliveryTD.toDate())
                    ? a
                    : b,
              );
        return _mainBody(
          context,
          businesses,
          myBusiness,
          alreadyBusiness,
          recentDelivery,
        );
      },
    );
  }

  Scaffold _mainBody(
    BuildContext context,
    List<BusinessParams> businesses,
    BusinessParams? myBusiness,
    bool alreadyBusiness,
    DeliveryModel? recentDelivery,
  ) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(
            context: context,
            onMenuTap: () => _onMenuTap(
              alreadyBusiness: alreadyBusiness,
              business: myBusiness?.business,
              recentDelivery: recentDelivery,
            ),
            onBusinessTap: () => _onBusinessTap(
              businesses: businesses.map((e) => e.business).toList(),
              myBusiness: myBusiness?.business,
            ),
            onNotificationTap: () {
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
              // Navigator.pushNamed(context, AppRoutes.notificationPage);
              LocalNotification().defaultNotify(
                id: 0,
                title: "title",
                body: "body",
                payload: "",
              );
            },
            heading0: !alreadyBusiness ? "" : "Last Delivery",
            heading1: !alreadyBusiness
                ? ""
                : recentDelivery == null
                ? "No Deliveries yet"
                : "${recentDelivery.deliveryLocation.area}, ${recentDelivery.deliveryLocation.city}, ${recentDelivery.deliveryLocation.state}",
            heading2: !alreadyBusiness
                ? "Add the business to record deliveries, track consumers and manage employees"
                : recentDelivery == null
                ? DateFormat("EEEE, MMMM d, y").format(DateTime.now())
                : DateFormat(
                    "EEEE, MMMM d, y",
                  ).format(recentDelivery.deliveryTD.toDate()),
            title: !alreadyBusiness
                ? "Add Business"
                : "${myBusiness?.business.name}",
            menuNumber: 0,
            notificationNumber: 0,
          ),

          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          _delivery(
            title: "Deliveries",
            subtitle: "Pending Deliveries",
            deliveries: context
                .watch<DeliveryCubit>()
                .state
                .deliveries
                .toList()
                .where((e) => e.status == "initiated")
                .toList(),
            numbers: context
                .watch<DeliveryCubit>()
                .state
                .deliveries
                .toList()
                .where((e) => e.status == "initiated")
                .toList()
                .length,
            onTap: () => Navigator.pushNamed(context, AppRoutes.delivery),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          _heading(
            context: context,
            title: "Employees",
            subtitle: "Active Employees",
            numbers:
                (myBusiness?.business.employees.length ?? 0) +
                (myBusiness?.business.admins.length ?? 0) +
                (myBusiness?.business.owners.length ?? 0),
            onTap: () {},
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          if (myBusiness!.employees.isNotEmpty) ...[
            _employee(myBusinessParams: myBusiness),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
          if (myBusiness.admins.isNotEmpty) ...[
            _admins(myBusinessParams: myBusiness),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
          if (myBusiness.requests.isNotEmpty) ...[
            _requests(myBusinessParams: myBusiness),
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
          _owners(myBusinessParams: myBusiness),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          _heading(
            context: context,
            title: "Delivery Stats",
            subtitle: "Total Deliveries",
            numbers: context
                .watch<DeliveryCubit>()
                .state
                .deliveries
                .toList()
                .length,
            onTap: () {},
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20.h)),
          _calender(),
          SliverToBoxAdapter(child: SizedBox(height: 70.h)),
        ],
      ),
    );
  }

  Scaffold _empty({
    required List<BusinessModel> businesses,
    required BusinessModel? myBusiness,
    required bool alreadyBusiness,
  }) => Scaffold(
    body: CustomScrollView(
      slivers: [
        SliverAppBar(
          title: GestureDetector(
            onTap: () =>
                _onBusinessTap(businesses: businesses, myBusiness: null),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add Business",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10.w),
                const Icon(Iconsax.arrow_down_1),
              ],
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => _onMenuTap(alreadyBusiness: alreadyBusiness),
            icon: const Icon(Iconsax.menu_1),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 50.h),
              ...commonEmpty,
            ],
          ),
        ),
      ],
    ),
  );

  SliverToBoxAdapter _heading({
    required BuildContext context,
    required String title,
    required String subtitle,
    required num numbers,
    required void Function() onTap,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.blue600,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      "$numbers",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _delivery({
    required String title,
    required String subtitle,
    required List<DeliveryModel> deliveries,
    required num numbers,
    required void Function() onTap,
  }) => SliverToBoxAdapter(
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.5)),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 7.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.blue600,
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        "$numbers",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Column(
              children: deliveries.isEmpty
                  ? [
                      SizedBox(height: 40.h),
                      ...commonEmptySmall,
                      SizedBox(height: 20.h),
                    ]
                  : List.generate(deliveries.length > 3 ? 3 : deliveries.length, (
                      i,
                    ) {
                      final delivery = deliveries[i];
                      final consumer = context
                          .watch<DeliveryCubit>()
                          .state
                          .consumers
                          .firstWhere((e) => e.id == delivery.consumerID);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                height: 50.r,
                                width: 50.r,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.error);
                                },
                                consumer.image,
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    consumer.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${consumer.address.area}, ${consumer.address.city}, ${consumer.address.state}",
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 15.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat(
                                    "HH:mm",
                                  ).format(delivery.deliveryTD.toDate()),
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat(
                                    "EEEE",
                                  ).format(delivery.deliveryTD.toDate()),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.blue600,
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _buildSliverAppBar({
    required BuildContext context,
    required void Function() onMenuTap,
    required void Function() onBusinessTap,
    required void Function() onNotificationTap,
    required String heading0,
    required String heading1,
    required String heading2,
    required String title,
    required num menuNumber,
    required num notificationNumber,
  }) {
    return SliverAppBar(
      expandedHeight: 280.h,
      floating: true,
      backgroundColor: const Color(0xff202424),
      leading: IconButton(
        onPressed: onMenuTap,
        icon: badge.Badge(
          showBadge: menuNumber != 0,
          badgeStyle: const badge.BadgeStyle(badgeColor: AppColors.blue600),
          badgeContent: Text(
            "$menuNumber",
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          child: const Icon(Iconsax.menu_1, color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          onPressed: onNotificationTap,
          icon: badge.Badge(
            showBadge: notificationNumber != 0,
            badgeStyle: const badge.BadgeStyle(badgeColor: AppColors.blue600),
            badgeContent: Text(
              "$notificationNumber",
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            child: const Icon(Iconsax.notification, color: Colors.white),
          ),
        ),
      ],
      stretch: true,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xff202424),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                heading0,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                heading1,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                heading2,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(.5),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
      title: GestureDetector(
        onTap: onBusinessTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.w),
            const Icon(Iconsax.arrow_down_1, color: Colors.white),
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  SliverToBoxAdapter _employee({required BusinessParams myBusinessParams}) {
    final employees = myBusinessParams.employees;
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(employees.length, (i) {
            final employee = employees[i].employee;
            return Container(
              width: 350.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.blue500,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      height: 50.r,
                      width: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      employee.avatar,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          employee.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          "${employee.address.area}, ${employee.address.city}, ${employee.address.state}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  IconButton(
                    onPressed: () => _onEmployeeTap(employee: employee),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: const Icon(Iconsax.menu_1, color: Colors.white),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  SliverToBoxAdapter _admins({required BusinessParams myBusinessParams}) {
    final admins = myBusinessParams.admins;
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(admins.length, (i) {
            final admin = admins[i].employee;
            return Container(
              width: 350.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.black700,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      height: 50.r,
                      width: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      admin.avatar,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          admin.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          "${admin.address.area}, ${admin.address.city}, ${admin.address.state}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  IconButton(
                    onPressed: () => _onEmployeeTap(employee: admin),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black500,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: const Icon(Iconsax.menu_1, color: Colors.white),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  SliverToBoxAdapter _requests({required BusinessParams myBusinessParams}) {
    final requests = myBusinessParams.requests;
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(requests.length, (i) {
            final request = requests[i].employee;
            return Container(
              width: 350.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.black500,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      height: 50.r,
                      width: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      request.avatar,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          "Accept the request to add\nas employee",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  IconButton(
                    onPressed: () => _onRequestTap(
                      employee: request,
                      business: myBusinessParams.business,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: const Icon(Iconsax.menu_1, color: Colors.white),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  SliverToBoxAdapter _owners({required BusinessParams myBusinessParams}) {
    final owners = myBusinessParams.owners;
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(owners.length, (i) {
            final owner = owners[i].employee;
            return Container(
              width: 350.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.blue500,
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      height: 50.r,
                      width: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error);
                      },
                      owner.avatar,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          owner.name,
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        Text(
                          "${owner.address.area}, ${owner.address.city}, ${owner.address.state}",
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white.withOpacity(.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.w),
                  IconButton(
                    onPressed: () => _onEmployeeTap(employee: owner),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue400,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    icon: const Icon(Iconsax.menu_1, color: Colors.white),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  SliverToBoxAdapter _calender() {
    final deliveries = context.read<DeliveryCubit>().state.deliveries;
    final now = DateTime.now();
    final Map<String, int> deliveryCountPerDay = {};

    for (var delivery in deliveries) {
      final date = DateTime(
        delivery.deliveryTD.toDate().year,
        delivery.deliveryTD.toDate().month,
        delivery.deliveryTD.toDate().day,
      );
      final key = date.toIso8601String();
      deliveryCountPerDay[key] = (deliveryCountPerDay[key] ?? 0) + 1;
    }

    return SliverToBoxAdapter(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(right: 10.w),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(30, (i) {
            final date = now.subtract(Duration(days: i));
            final day = date.day.toString();
            final weekday = DateFormat('EEEE').format(date);
            final isToday =
                DateTime.now().day == date.day &&
                DateTime.now().month == date.month &&
                DateTime.now().year == date.year;
            final key = DateTime(
              date.year,
              date.month,
              date.day,
            ).toIso8601String();
            final deliveryCount = deliveryCountPerDay[key] ?? 0;

            return Container(
              width: 140.w,
              margin: EdgeInsets.only(left: 10.w),
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: isToday ? AppColors.blue500 : Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                border: isToday
                    ? null
                    : Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        day,
                        style: Theme.of(context).textTheme.headlineSmall!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: isToday ? Colors.white : Colors.black,
                            ),
                      ),
                      Text(
                        isToday ? "Today" : DateFormat('MMM d').format(date),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isToday
                              ? Colors.white.withOpacity(.6)
                              : Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 7.h),
                  Text(
                    weekday,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "$deliveryCount Delivery${deliveryCount == 1 ? '' : 'ies'}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isToday
                          ? Colors.white.withOpacity(.7)
                          : Colors.black.withOpacity(.7),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  void _onMenuTap({
    required bool alreadyBusiness,
    BusinessModel? business,
    DeliveryModel? recentDelivery,
  }) {
    final totalEmployees =
        (business?.employees.length ?? 0) +
        (business?.admins.length ?? 0) +
        (business?.owners.length ?? 0);

    String deliveryAgo = "";
    if (recentDelivery != null) {
      deliveryAgo = timeAgo(recentDelivery.deliveryTD.toDate());
    }

    final totalConsumers = context.read<DeliveryCubit>().state.consumers.length;
    openBottomSheet(
      minChildSize: alreadyBusiness ? 0.53 : 0.22,
      initialChildSize: alreadyBusiness ? 0.53 : 0.22,
      maxChildSize: .9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          if (alreadyBusiness) ...[
            bottomSheetTile(
              context: context,
              icon: Iconsax.buildings_2,
              title: "${business?.name} Business",
              subtitle: "Total Employees: $totalEmployees",
              onTap: () {
                Navigator.pop(context);
                showSnack(
                  text: "Will be available in next update",
                  backgroundColor: AppColors.red500,
                );
              },
            ),
            bottomSheetTile(
              context: context,
              icon: Iconsax.truck,
              actionIcon: Iconsax.arrow_right_1,
              title: "Deliveries",
              subtitle: recentDelivery == null
                  ? "No Deliveries yet"
                  : "Last added $deliveryAgo ago",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.delivery);
              },
            ),
            bottomSheetTile(
              context: context,
              icon: Iconsax.profile_2user,
              actionIcon: Iconsax.arrow_right_1,
              title: "Consumers",
              subtitle: "Total consumers: $totalConsumers",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.allConsumer);
              },
            ),
            bottomSheetTile(
              context: context,
              icon: Iconsax.bus,
              title: "Vehicles",
              subtitle: "Total vehicles: 0",
              onTap: () {
                Navigator.pop(context);
                showSnack(
                  text: "Will be available in next update",
                  backgroundColor: AppColors.red500,
                );
              },
            ),
          ],
          bottomSheetTile(
            context: context,
            icon: Iconsax.personalcard,
            title: "My Profile",
            subtitle: "Last updated 5 mins ago",
            onTap: () {
              Navigator.pop(context);
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.lock,
            actionIcon: Iconsax.logout_1,
            title: "Log out",
            subtitle: "Sign out from the this account",
            onTap: () async {
              Navigator.pop(context);
              final success = await context.read<EmployeeCubit>().signOut();
              if (success) {
                Navigator.pushReplacementNamed(context, AppRoutes.auth);
              }
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  void _onBusinessTap({
    required List<BusinessModel> businesses,
    required BusinessModel? myBusiness,
  }) {
    openBottomSheet(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Businesses",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.addBusiness);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Add Business",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.blue600,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Icon(
                          Iconsax.add,
                          color: Colors.white,
                          size: 15.r,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
          ...List.generate(businesses.length, (index) {
            final business = businesses[index];
            final alreadyBusiness = myBusiness?.id == business.id;
            return _businessTile(
              avatar: business.avatar,
              title: "${business.name} Business",
              subtitle: alreadyBusiness
                  ? "Active Business Joined"
                  : "Total Employees: 5",
              status:
                  business.requests.contains(
                    FirebaseAuth.instance.currentUser?.uid ?? "No User Found",
                  )
                  ? "requested"
                  : alreadyBusiness
                  ? "already joined"
                  : "not requested",
              onTap: () async {
                Navigator.pop(context);
                if (alreadyBusiness) {
                  showSnack(
                    text: "Already joined ${business.name} Business",
                    backgroundColor: AppColors.red500,
                  );
                  return;
                } else {
                  showSnack(
                    text: "Requesting to join ${business.name} Business",
                    backgroundColor: AppColors.blue500,
                  );

                  final success = await context
                      .read<BusinessCubit>()
                      .updateBusiness(
                        business: business.copyWith(
                          requests: [
                            ...business.requests,
                            FirebaseAuth.instance.currentUser?.uid,
                          ],
                        ),
                        avatar: null,
                      );

                  if (success && mounted) {
                    showSnack(
                      text: "Request sent to ${business.name} Business",
                    );
                  }
                }
              },
            );
          }),
        ],
      ),
    );
  }

  Padding _businessTile({
    required String avatar,
    required String title,
    required String subtitle,
    required String status,
    required void Function() onTap,
  }) => Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      children: [
        ClipOval(
          child: Image.network(
            height: 50.r,
            width: 50.r,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error);
            },
            avatar,
          ),
        ),
        SizedBox(width: 15.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: status == "already joined"
                      ? AppColors.green600
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
        if (status != "already joined") ...[
          SizedBox(width: 15.w),
          IconButton(
            onPressed: onTap,
            icon: status == "requested"
                ? const Icon(
                    CupertinoIcons.check_mark,
                    color: AppColors.green600,
                  )
                : const Icon(Iconsax.add),
          ),
        ],
      ],
    ),
  );

  void _onEmployeeTap({required EmployeeModel employee}) {
    final updatedAgo = timeAgo(employee.address.updateTD.toDate());
    openBottomSheet(
      minChildSize: 0.28,
      initialChildSize: 0.28,
      child: Column(
        children: [
          bottomSheetTile(
            context: context,
            icon: Iconsax.tag_user,
            title: "View Profile",
            subtitle: "View employee profile",
            onTap: () {
              Navigator.pop(context);
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.gps,
            title: "Track Employee",
            subtitle: "Updated $updatedAgo ago",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.employeeTrack,
                arguments: {"employeeID": employee.id},
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.user_minus,
            title: "Remove Employee",
            subtitle: "Remove employee from business",
            onTap: () {
              Navigator.pop(context);
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
            },
          ),
        ],
      ),
    );
  }

  void _onRequestTap({
    required EmployeeModel employee,
    required BusinessModel business,
  }) {
    openBottomSheet(
      minChildSize: 0.28,
      initialChildSize: 0.28,
      child: Column(
        children: [
          bottomSheetTile(
            context: context,
            icon: CupertinoIcons.check_mark,
            title: "Accept Request",
            subtitle: "Total requests: ${business.requests.length}",
            actionIcon: Iconsax.arrow_right_1,
            onTap: () async {
              Navigator.pop(context);

              showSnack(
                text: "Accepting request from ${employee.name}",
                backgroundColor: AppColors.blue500,
              );

              final updatedRequests = business.requests
                  .where((id) => id != employee.id)
                  .toList();

              final updatedEmployees = [...business.employees, employee.id];

              final success = await context
                  .read<BusinessCubit>()
                  .updateBusiness(
                    business: business.copyWith(
                      requests: updatedRequests,
                      employees: updatedEmployees,
                    ),
                    avatar: null,
                  );

              if (success && mounted) {
                showSnack(text: "Request accepted from ${employee.name}");
              }
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.tag_user,
            title: "View Profile",
            subtitle: "View employee profile",
            onTap: () {
              Navigator.pop(context);
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.user_minus,
            title: "Reject Request",
            subtitle: "Rejecting the request of this employee",
            onTap: () async {
              Navigator.pop(context);
              showSnack(
                text: "Rejecting request from ${employee.name}",
                backgroundColor: AppColors.blue500,
              );

              final updatedRequests = business.requests
                  .where((id) => id != employee.id)
                  .toList();

              final success = await context
                  .read<BusinessCubit>()
                  .updateBusiness(
                    business: business.copyWith(requests: updatedRequests),
                    avatar: null,
                  );

              if (success && mounted) {
                showSnack(text: "Request rejected from ${employee.name}");
              }
            },
          ),
        ],
      ),
    );
  }
}
