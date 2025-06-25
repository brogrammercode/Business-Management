// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class ConsumerDetailPage extends StatefulWidget {
  final ConsumerModel consumer;
  const ConsumerDetailPage({super.key, required this.consumer});

  @override
  State<ConsumerDetailPage> createState() => _ConsumerDetailPageState();
}

class _ConsumerDetailPageState extends State<ConsumerDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryCubit, DeliveryState>(
      listener: (context, state) {},
      builder: (context, state) {
        final deliveries = state.deliveries
            .where(
              (e) =>
                  e.consumerID == widget.consumer.id && e.status == "completed",
            )
            .toList();
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(context: context),
              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
              _heading(
                context: context,
                title: "Account Details",
                subtitle: "Total Info",
                numbers: 9,
                onTap: () {},
              ),
              SliverToBoxAdapter(child: SizedBox(height: 30.h)),
              _accountDetails(consumer: widget.consumer),
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
              _heading(
                context: context,
                title: "Delivery Details",
                subtitle: "Total Deliveries",
                numbers: deliveries.length,
                onTap: () {},
              ),
              SliverToBoxAdapter(child: SizedBox(height: 20.h)),
              SliverToBoxAdapter(
                child: Column(
                  children: List.generate(deliveries.length, (index) {
                    return _deliverTile(delivery: deliveries[index]);
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Container _deliverTile({required DeliveryModel delivery}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide.none)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat("dd").format(delivery.deliveryTD.toDate()),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat("MMM").format(delivery.deliveryTD.toDate()),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "₹ ${delivery.paid} paid, ${DateFormat("hh:mm a").format(delivery.deliveryTD.toDate())}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 3.h),
                Text(
                  "Arvind Kumar",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountDetails({required ConsumerModel consumer}) {
    double tileWidth =
        (MediaQuery.of(context).size.width - 20.w * 2 - 15.w) / 2;

    final items = [
      {
        "title": "Aadhar Number",
        "subtitle": consumer.consumerAadharNo,
        "icon": Iconsax.profile_tick,
      },
      {
        "title": "SV Number",
        "subtitle": consumer.svNo,
        "icon": Iconsax.shield_tick,
      },
      {
        "title": "Ration Card No.",
        "subtitle": consumer.rationNo,
        "icon": Iconsax.card,
      },
      {
        "title": "Bank Acc. Number",
        "subtitle": consumer.bankAccountNo,
        "icon": Iconsax.bank,
      },
      {
        "title": "Money Paid",
        "subtitle": "₹ ${consumer.paid}",
        "icon": Iconsax.money_send,
      },
      {
        "title": "Money Due",
        "subtitle": "₹ ${consumer.due}",
        "icon": Iconsax.money_remove,
      },
      if (consumer.husbandspouseName.isNotEmpty) ...[
        {
          "title": "Guardian's Name",
          "subtitle": consumer.husbandspouseName,
          "icon": Iconsax.user,
        },
      ],
      if (consumer.husbandspouseAadharNo.isNotEmpty) ...[
        {
          "title": "Guardian's Aadhar",
          "subtitle": consumer.husbandspouseAadharNo,
          "icon": Iconsax.profile_tick,
        },
      ],
    ];

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Wrap(
          spacing: 20.w,
          runSpacing: 20.h,
          children: items
              .map(
                (item) => SizedBox(
                  width: tileWidth,
                  child: _detailTile(
                    title: item['title'] as String? ?? "",
                    subtitle: item['subtitle'] as String? ?? "",
                    icon: item['icon'] as IconData? ?? Iconsax.profile_tick,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Row _detailTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 140.w,
              child: Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ],
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

  Widget _buildSliverAppBar({required BuildContext context}) {
    return SliverAppBar(
      expandedHeight: 300.h,
      backgroundColor: const Color(0xff202424),
      stretch: true,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Iconsax.arrow_left, color: Colors.white),
      ),
      pinned: true,
      actions: [
        IconButton(
          onPressed: () =>
              _onMenuTap(context: context, consumer: widget.consumer),
          icon: const Icon(Iconsax.menu_1, color: Colors.white),
        ),
        SizedBox(width: 10.w),
      ],
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
              widget.consumer.image,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 60.r,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 55.r,
                    backgroundImage: NetworkImage(widget.consumer.image),
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Text(
                    "${widget.consumer.address.city}, ${widget.consumer.address.area}, ${widget.consumer.address.pincode}",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        border: Border.all(color: Colors.grey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "# ${widget.consumer.consumerNo}",
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      margin: EdgeInsets.only(top: 20.h),
                      padding: EdgeInsets.symmetric(
                        vertical: 5.h,
                        horizontal: 10.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        border: Border.all(color: Colors.grey.withOpacity(.3)),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Iconsax.call, color: Colors.black, size: 15.r),
                          SizedBox(width: 10.w),
                          Text(
                            widget.consumer.phoneNo,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ],
        ),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.consumer.name,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            widget.consumer.gender == "Male" ? Iconsax.man : Iconsax.woman,
            color: Colors.white,
            size: 15.r,
          ),
        ],
      ),
      centerTitle: true,
    );
  }
}

void _onMenuTap({
  required BuildContext context,
  required ConsumerModel consumer,
}) {
  final state = context.read<DeliveryCubit>().state;
  final recentDelivery =
      state.deliveries
          .where((delivery) => delivery.consumerID == consumer.id)
          .toList()
          .isNotEmpty
      ? state.deliveries
            .where((delivery) => delivery.consumerID == consumer.id)
            .toList()
            .last
      : null;
  String deliveryAgo = "";
  if (recentDelivery != null) {
    deliveryAgo = timeAgo(recentDelivery.deliveryTD.toDate());
  }
  String consumerAgo = timeAgo(consumer.creationTD.toDate());
  openBottomSheet(
    minChildSize: 0.44,
    initialChildSize: 0.44,
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
          icon: Iconsax.location,
          title: "Track User",
          subtitle:
              "${consumer.address.city}, ${consumer.address.area}, ${consumer.address.state}",
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
          icon: Iconsax.call,
          title: "Call User",
          subtitle: "Call on ${consumer.phoneNo}",
          onTap: () {
            Navigator.pop(context);
            call(context: context, phoneNumber: consumer.phoneNo);
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
