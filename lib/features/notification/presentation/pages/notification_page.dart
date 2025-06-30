// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:badges/badges.dart' as badge;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/notification/data/models/notification_model.dart';
import 'package:gas/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationCubit, NotificationState>(
      listener: (context, state) {},
      builder: (context, state) {
        final notifications = state.notifications;
        log(notifications.length.toString());
        final unseenNotifications = notifications
            .where(
              (notification) => !notification.seen.any(
                (e) => e.uid == FirebaseAuth.instance.currentUser?.uid,
              ),
            )
            .toList();
        final businessID = context.watch<BusinessCubit>().state.businessID;
        if (unseenNotifications.isNotEmpty) {
          context.read<NotificationCubit>().readAllNotification(
            businessID: businessID,
          );
        }
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildSliverAppBar(
                context: context,
                onBackTap: () => Navigator.pop(context),
                onMenuTap: () => _onMenuTap(
                  totalUnreadNotification: unseenNotifications.length,
                  totalNotification: notifications.length,
                ),
                title: "Notification",
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: _groupedNotifications(notifications),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _groupedNotifications(List<NotificationModel> notifications) {
    final Map<String, List<NotificationModel>> grouped = {};

    for (final notification in notifications) {
      final date = notification.creationTD.toDate();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final creationDate = DateTime(date.year, date.month, date.day);

      String label;
      if (creationDate == today) {
        label = "Today";
      } else if (creationDate == yesterday) {
        label = "Yesterday";
      } else {
        label = DateFormat("dd MMM yyyy").format(date);
      }

      grouped.putIfAbsent(label, () => []).add(notification);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        final title = entry.key;
        final list = entry.value;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            ...list.map((notification) {
              final seen = notification.seen.any(
                (e) => e.uid == FirebaseAuth.instance.currentUser?.uid,
              );

              return _deliveryTile(
                context: context,
                bigAvatar: notification.bigAvatar,
                smallAvatar: notification.smallAvatar,
                description: notification.description,
                boldTexts: notification.boldTexts,
                tdText: DateFormat(
                  "dd MMM, hh:mm a",
                ).format(notification.creationTD.toDate()),
                seen: seen,
                onTap: () {
                  if (notification.module == "DELIVERY") {
                    Navigator.pushNamed(context, AppRoutes.delivery);
                  }
                },
              );
            }),
          ],
        );
      }).toList(),
    );
  }

  InkWell _deliveryTile({
    required BuildContext context,
    required String bigAvatar,
    required String smallAvatar,
    required String description,
    required List<String> boldTexts,
    required String tdText,
    required bool seen,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.h),
        child: Row(
          children: [
            badge.Badge(
              showBadge: smallAvatar.isNotEmpty,
              position: badge.BadgePosition.bottomEnd(bottom: 1.h, end: -5.w),
              badgeStyle: badge.BadgeStyle(
                badgeColor: Colors.white,
                padding: EdgeInsets.all(2.w),
              ),
              badgeContent: ClipOval(
                child: Image.network(
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  height: 20.r,
                  width: 20.r,
                  fit: BoxFit.cover,
                  smallAvatar,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                  height: 50.r,
                  width: 50.r,
                  fit: BoxFit.cover,
                  bigAvatar,
                ),
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black.withOpacity(.6),
                      ),
                      children: _buildHighlightedText(
                        description,
                        boldTexts,
                        context,
                      ),
                    ),
                  ),
                  Text(
                    tdText,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (!seen) ...[
              SizedBox(width: 15.w),
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 4.h,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(
    String description,
    List<String> boldTexts,
    BuildContext context,
  ) {
    final List<TextSpan> spans = [];
    String remainingText = description;

    while (remainingText.isNotEmpty) {
      int matchIndex = remainingText.length;
      String? matchedWord;

      for (final bold in boldTexts) {
        final index = remainingText.indexOf(bold);
        if (index != -1 && index < matchIndex) {
          matchIndex = index;
          matchedWord = bold;
        }
      }

      if (matchedWord == null) {
        spans.add(TextSpan(text: remainingText));
        break;
      }

      if (matchIndex > 0) {
        spans.add(TextSpan(text: remainingText.substring(0, matchIndex)));
      }

      spans.add(
        TextSpan(
          text: matchedWord,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );

      remainingText = remainingText.substring(matchIndex + matchedWord.length);
    }

    return spans;
  }

  void _onMenuTap({
    required num totalUnreadNotification,
    required num totalNotification,
  }) {
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
            title: "Mark all as read",
            subtitle: "Total notification: $totalUnreadNotification",
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
            icon: Iconsax.trash,
            title: "Clear Notification",
            subtitle: "This will delete $totalNotification notifications",
            onTap: () {
              Navigator.pop(context);
              showSnack(
                text: "Will be available in next update",
                backgroundColor: AppColors.red500,
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
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
