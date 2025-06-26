import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class DeliveryPage extends StatelessWidget {
  const DeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listener: (context, state) {
        if (state.streamDeliveriesStatus == StateStatus.failure) {
          showSnack(text: "Something went wrong");
        }
      },
      builder: (context, state) {
        final deliveries = state.deliveries.toList();
        final consumers = state.consumers.toList();
        final pendingDeliveries = deliveries
            .where((element) => element.status == "initiated")
            .toList();

        bool isToday(DateTime date) {
          final now = DateTime.now();
          return now.difference(date).inHours < 24 && now.isAfter(date);
        }

        final successDeliveries = deliveries
            .where(
              (element) =>
                  element.status == "completed" &&
                  isToday(element.deliveryTD.toDate()),
            )
            .toList();
        final cancelledDeliveries = deliveries
            .where(
              (element) =>
                  element.status == "cancelled" &&
                  isToday(element.deliveryTD.toDate()),
            )
            .toList();

        final totalConsumers = consumers.length;
        final recentConsumer = consumers.toList().reversed.toList();
        final recentDeliveries = deliveries.toList().reversed.toList();

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                context: context,
                onBackTap: () => Navigator.pop(context),
                onMenuTap: () => _onMenuTap(
                  context: context,
                  recentDelivery: recentDeliveries.isEmpty
                      ? null
                      : recentDeliveries.first,
                  recentConsumer: recentConsumer.isEmpty
                      ? null
                      : recentConsumer.first,
                  totalConsumers: totalConsumers.toString(),
                ),
                title: "Deliveries",
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: List.generate(pendingDeliveries.length, (i) {
                      final delivery = pendingDeliveries.elementAt(i);
                      final consumer = consumers.firstWhere(
                        (element) => element.id == delivery.consumerID,
                      );
                      return _deliveryTile(
                        context: context,
                        image: consumer.image,
                        title: consumer.name,
                        subtitle:
                            "${consumer.address.city}, ${consumer.address.area}, ${consumer.address.pincode}",
                        rightTitle: DateFormat(
                          "HH:mm",
                        ).format(delivery.deliveryTD.toDate()),
                        rightSubtitle: DateFormat(
                          "EEEE",
                        ).format(delivery.deliveryTD.toDate()),
                        onTap: () => _onPendingDeliveryTap(
                          context: context,
                          consumer: consumer,
                          delivery: delivery,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              if ((successDeliveries.length + cancelledDeliveries.length) >
                  0) ...[
                _heading(
                  context: context,
                  title: "Today",
                  subtitle: "Sucessfully Delivered",
                  numbers: successDeliveries.length,
                  onTap: () {},
                ),
              ],
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: List.generate(successDeliveries.length, (i) {
                      final delivery = successDeliveries.elementAt(i);
                      final consumer = consumers.firstWhere(
                        (element) => element.id == delivery.consumerID,
                      );
                      return _deliveryTile(
                        context: context,
                        image: consumer.image,
                        title: consumer.name,
                        subtitle:
                            "${consumer.address.city}, ${consumer.address.area}, ${consumer.address.pincode}",
                        rightTitle: DateFormat(
                          "HH:mm",
                        ).format(delivery.deliveryTD.toDate()),
                        rightSubtitle: DateFormat(
                          "EEEE",
                        ).format(delivery.deliveryTD.toDate()),
                        onTap: () => _onCompletedDeliveryTap(
                          context: context,
                          consumer: consumer,
                          delivery: delivery,
                        ),
                        status: "success",
                      );
                    }),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: List.generate(cancelledDeliveries.length, (i) {
                      final delivery = cancelledDeliveries.elementAt(i);
                      final consumer = consumers.firstWhere(
                        (element) => element.id == delivery.consumerID,
                      );
                      return _deliveryTile(
                        context: context,
                        image: consumer.image,
                        title: consumer.name,
                        subtitle:
                            "${consumer.address.city}, ${consumer.address.area}, ${consumer.address.pincode}",
                        rightTitle: DateFormat(
                          "HH:mm",
                        ).format(delivery.deliveryTD.toDate()),
                        rightSubtitle: DateFormat(
                          "EEEE",
                        ).format(delivery.deliveryTD.toDate()),
                        onTap: () => _onCompletedDeliveryTap(
                          context: context,
                          consumer: consumer,
                          delivery: delivery,
                        ),
                        status: "cancel",
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onPendingDeliveryTap({
    required BuildContext context,
    required ConsumerModel consumer,
    required DeliveryModel delivery,
  }) {
    final deliveryAgo = timeAgo(delivery.deliveryTD.toDate());
    openBottomSheet(
      minChildSize: 0.28,
      initialChildSize: 0.28,
      maxChildSize: .5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck_tick,
            actionIcon: Iconsax.arrow_right_1,
            title: "Finish Delivery",
            subtitle: "Delivery initiated $deliveryAgo ago",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.finishDelivery,
                arguments: {"delivery": delivery},
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.security_user,
            actionIcon: Iconsax.arrow_right_1,
            title: "View Profile",
            subtitle:
                "Created on ${DateFormat("dd MMMM").format(consumer.creationTD.toDate())}",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.consumerDetail,
                arguments: {"consumer": consumer},
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck_remove,
            actionIcon: Iconsax.trash,
            title: "Cancel Delivery",
            subtitle: "Permanently delete this delivery",
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

  void _onCompletedDeliveryTap({
    required BuildContext context,
    required ConsumerModel consumer,
    required DeliveryModel delivery,
  }) {
    final deliveryAgo = timeAgo(delivery.deliveryTD.toDate());
    openBottomSheet(
      minChildSize: 0.28,
      initialChildSize: 0.28,
      maxChildSize: .5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck_tick,
            actionIcon: Iconsax.arrow_right_1,
            title: "View Delivery Details",
            subtitle: "Delivery completed $deliveryAgo ago",
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
            icon: Iconsax.security_user,
            actionIcon: Iconsax.arrow_right_1,
            title: "View Profile",
            subtitle:
                "Created on ${DateFormat("dd MMMM").format(consumer.creationTD.toDate())}",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.consumerDetail,
                arguments: {"consumer": consumer},
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck_remove,
            actionIcon: Iconsax.trash,
            title: "Delete Delivery",
            subtitle: "Permanently delete this delivery",
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

  void _onMenuTap({
    required BuildContext context,
    required DeliveryModel? recentDelivery,
    required ConsumerModel? recentConsumer,
    required String totalConsumers,
  }) {
    String deliveryAgo = "";
    if (recentDelivery != null) {
      deliveryAgo = timeAgo(recentDelivery.deliveryTD.toDate());
    }
    String consumerAgo = "";
    if (recentConsumer != null) {
      consumerAgo = timeAgo(recentConsumer.creationTD.toDate());
    }
    openBottomSheet(
      minChildSize: 0.28,
      initialChildSize: 0.28,
      maxChildSize: .5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck,
            actionIcon: Iconsax.arrow_right_1,
            title: "Add Deliveries",
            subtitle: recentDelivery == null
                ? "No Deliveries yet"
                : "Last added $deliveryAgo ago",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.allConsumer);
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.user_add,
            actionIcon: Iconsax.arrow_right_1,
            title: "Add Consumers",
            subtitle: recentConsumer == null
                ? "No Consumers yet"
                : "Last added $consumerAgo ago",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.addConsumer);
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.user_tag,
            title: "All Consumers",
            subtitle: "Total users: $totalConsumers",
            onTap: () {},
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  InkWell _deliveryTile({
    required BuildContext context,
    required String image,
    required String title,
    required String subtitle,
    required String rightTitle,
    required String rightSubtitle,
    required void Function() onTap,
    String status = "pending",
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          children: [
            badge.Badge(
              showBadge: status != "pending",
              position: badge.BadgePosition.bottomEnd(bottom: 1.h, end: -5.w),
              badgeStyle: badge.BadgeStyle(
                badgeColor: status == "cancel"
                    ? AppColors.red600
                    : AppColors.green500,
              ),
              badgeContent: Icon(
                status == "cancel"
                    ? CupertinoIcons.multiply
                    : CupertinoIcons.check_mark,
                size: 12.r,
                color: Colors.white,
              ),
              child: ClipOval(
                child: Image.network(
                  height: 50.r,
                  width: 50.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  image,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
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
                  rightTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  rightSubtitle,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SliverToBoxAdapter _heading({
    required BuildContext context,
    required String title,
    required String subtitle,
    required num numbers,
    required void Function() onTap,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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

  Widget _buildSliverAppBar({
    required BuildContext context,
    required void Function() onBackTap,
    required void Function() onMenuTap,
    required String title,
  }) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: onBackTap,
        icon: const Icon(Iconsax.arrow_left),
      ),
      pinned: true,
      actions: [
        IconButton(onPressed: onMenuTap, icon: const Icon(Iconsax.menu_1)),
        SizedBox(width: 10.w),
      ],
      title: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }
}
