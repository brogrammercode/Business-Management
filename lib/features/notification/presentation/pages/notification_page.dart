// ignore_for_file: deprecated_member_use

import 'package:badges/badges.dart' as badge;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
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
    List notifications = [
      {
        "id": "0",
        "bigAvatar":
            "https://images.unsplash.com/photo-1529946179074-87642f6204d7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFkeXxlbnwwfHwwfHx8MA%3D%3D",
        "smallAvatar":
            "https://images.unsplash.com/photo-1508341591423-4347099e1f19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bWFufGVufDB8fDB8fHww",
        "description": "Nirma Devi got the Delivery from Saroj Kumar",
        "boldTexts": ["Nirma Devi", "Saroj Kumar"],
        "module": "DELIVERY",
        'refID': "",
        "seen": [
          {"uid": FirebaseAuth.instance.currentUser?.uid, "td": DateTime.now()},
        ],
        "businessID": "",
        "notificationTD": DateTime.now(),
      },
      {
        "id": "1",
        "bigAvatar":
            "https://images.unsplash.com/photo-1529946179074-87642f6204d7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFkeXxlbnwwfHwwfHx8MA%3D%3D",
        "smallAvatar": "",
        "description": "Nirma Devi joined Gas Agency",
        "boldTexts": ["Nirma Devi", "Gas Agency"],
        "module": "BUSINESS",
        'refID': "",
        "seen": [],
        "businessID": "",
        "notificationTD": DateTime.now(),
      },
      {
        "id": "1",
        "bigAvatar":
            "https://images.unsplash.com/photo-1529946179074-87642f6204d7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGFkeXxlbnwwfHwwfHx8MA%3D%3D",
        "smallAvatar": "",
        "description": "Delivery initiated for Nirma Devi",
        "boldTexts": ["Nirma Devi"],
        "module": "DELIVERY",
        'refID': "",
        "seen": [
          {"uid": FirebaseAuth.instance.currentUser?.uid, "td": DateTime.now()},
        ],
        "businessID": "",
        "notificationTD": DateTime.now(),
      },
      {
        "id": "1",
        "bigAvatar":
            "https://images.unsplash.com/photo-1508341591423-4347099e1f19?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bWFufGVufDB8fDB8fHww",
        "smallAvatar": "",
        "description": "Delivery initiated for Saroj Kumar",
        "boldTexts": ["Saroj Kumar"],
        "module": "DELIVERY",
        'refID': "",
        "seen": [],
        "businessID": "",
        "notificationTD": DateTime.now(),
      },
    ];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(
            context: context,
            onBackTap: () => Navigator.pop(context),
            onMenuTap: () =>
                _onMenuTap(totalUnreadNotification: 0, totalNotification: 10),
            title: "Notification",
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: List.generate(notifications.length, (i) {
                  final notification = notifications[i];
                  return _deliveryTile(
                    context: context,
                    bigAvatar: notification['bigAvatar'],
                    smallAvatar: notification['smallAvatar'],
                    description: notification['description'],
                    boldTexts: notification['boldTexts'],
                    tdText: DateFormat(
                      "dd MMM, hh:mm a",
                    ).format(notification['notificationTD']),
                    seen:
                        List<Map<String, dynamic>>.from(
                          notification['seen'] ?? [],
                        ).any(
                          (e) =>
                              e['uid'] ==
                              FirebaseAuth.instance.currentUser?.uid,
                        ),
                    onTap: () {
                      if (notification['module'] == "DELIVERY") {
                        Navigator.pushNamed(context, AppRoutes.delivery);
                      }
                    },
                  );
                }),
              ),
            ),
          ),
        ],
      ),
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
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
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
