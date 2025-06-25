// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:badges/badges.dart' as badge;
import 'package:intl/intl.dart';

class AllConsumerPage extends StatefulWidget {
  const AllConsumerPage({super.key});

  @override
  State<AllConsumerPage> createState() => _AllConsumerPageState();
}

class _AllConsumerPageState extends State<AllConsumerPage> {
  bool aTOz = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listener: (context, state) {
        if (state.streamConsumersStatus == StateStatus.failure) {
          showSnack(text: "Something went wrong");
        }
      },
      builder: (context, state) {
        final consumers = state.consumers.toList();
        if (aTOz) {
          consumers.sort((a, b) => a.name.compareTo(b.name));
        } else {
          consumers.sort((a, b) => b.name.compareTo(a.name));
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                context: context,
                onBackTap: () => Navigator.pop(context),
                onMenuTap: () =>
                    _onMenuTap(totalConsumers: "${consumers.length}"),
                title: "Add Deliveries",
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: List.generate(consumers.length, (i) {
                      final consumer = consumers[i];
                      return _deliveryTile(
                        context: context,
                        image: consumer.image,
                        title: consumer.name,
                        subtitle:
                            "${consumer.address.city}, ${consumer.address.area}, ${consumer.address.pincode}",
                        rightTitle: DateFormat(
                          "HH:mm",
                        ).format(consumer.creationTD.toDate()),
                        rightSubtitle: DateFormat(
                          "EEEE",
                        ).format(consumer.creationTD.toDate()),
                        onTap: () => _onConsumerTap(
                          context: context,
                          consumer: consumer,
                          recentDelivery:
                              state.deliveries
                                  .where(
                                    (delivery) =>
                                        delivery.consumerID == consumer.id,
                                  )
                                  .toList()
                                  .isNotEmpty
                              ? state.deliveries
                                    .where(
                                      (delivery) =>
                                          delivery.consumerID == consumer.id,
                                    )
                                    .toList()
                                    .last
                              : null,
                        ),
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

  void _onConsumerTap({
    required BuildContext context,
    required ConsumerModel consumer,
    required DeliveryModel? recentDelivery,
  }) {
    String deliveryAgo = "";
    if (recentDelivery != null) {
      deliveryAgo = timeAgo(recentDelivery.deliveryTD.toDate());
    }
    String consumerAgo = timeAgo(consumer.creationTD.toDate());
    openBottomSheet(
      minChildSize: 0.36,
      initialChildSize: 0.36,
      maxChildSize: .5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          bottomSheetTile(
            context: context,
            icon: Iconsax.truck,
            actionIcon: Iconsax.arrow_right_1,
            title: "Initiate Delivery",
            subtitle: "Last delivered $deliveryAgo ago",
            onTap: () async {
              Navigator.pop(context);
              showSnack(
                text: "Initiating delivery...",
                backgroundColor: AppColors.blue500,
                sticky: true,
              );

              final td = Timestamp.now();
              final businessID = context.read<BusinessCubit>().state.businessID;
              final UserLocationModel location =
                  context.read<HomeCubit>().state.lastLocation.isEmpty
                  ? UserLocationModel()
                  : context.read<HomeCubit>().state.lastLocation.first;
              final result = await context.read<DeliveryCubit>().addDelivery(
                delivery: DeliveryModel(
                  id: td.millisecondsSinceEpoch.toString(),
                  consumerID: consumer.id,
                  employeeID: "",
                  vehicleID: "",
                  deliveryImage: "",
                  deliveryLocation: location,
                  fees: 0,
                  paid: 0,
                  paymentMethod: "",
                  deliveryTD: td,
                  status: "initiated",
                  businessID: businessID,
                  creationTD: td,
                  createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
                  deactivate: false,
                ),
              );

              if (result) {
                showSnack(text: "Delivery initiated successfully");
              } else {
                showSnack(
                  text: "Failed to initiate delivery",
                  backgroundColor: AppColors.red500,
                );
              }
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
            icon: Iconsax.user_edit,
            actionIcon: Iconsax.arrow_right_1,
            title: "Edit Profile",
            subtitle: "Last Edited $consumerAgo ago",
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
            icon: Iconsax.profile_delete,
            actionIcon: Iconsax.trash,
            title: "Delete Consumer",
            subtitle: "Permanently delete this consumer",
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
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  height: 50.r,
                  width: 50.r,
                  fit: BoxFit.cover,
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

  void _onMenuTap({required String totalConsumers}) {
    openBottomSheet(
      minChildSize: 0.21,
      initialChildSize: 0.21,
      maxChildSize: .9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          bottomSheetTile(
            context: context,
            icon: Iconsax.user_add,
            actionIcon: Iconsax.arrow_right_1,
            title: "Add Consumer",
            subtitle: "Total consumers: $totalConsumers",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.addConsumer);
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.toggle_off,
            title: "Reverse List",
            subtitle: "Toggle: A to Z",
            onTap: () {
              setState(() {
                aTOz = !aTOz;
              });
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
