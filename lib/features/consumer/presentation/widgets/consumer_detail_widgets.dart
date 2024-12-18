import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badge;
import 'package:iconsax/iconsax.dart';

class ConsumerInfoTile extends StatelessWidget {
  final IconData leadingIcon;
  final IconData? actionIcon;
  final void Function()? actionFunction;
  final String title;
  final String subtitle;
  final bool? showAlertBadge;
  const ConsumerInfoTile({
    super.key,
    required this.leadingIcon,
    this.actionIcon,
    required this.actionFunction,
    required this.title,
    required this.subtitle,
    this.showAlertBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        badge.Badge(
            showBadge: showAlertBadge != null && showAlertBadge == true,
            position: badge.BadgePosition.bottomEnd(bottom: -3.h, end: -3.h),
            badgeContent: Icon(
              Icons.info_rounded,
              color: Colors.white,
              size: 5.sp,
            ),
            child: Icon(leadingIcon)),
        SizedBox(width: 25.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        if (actionIcon != null) ...[
          SizedBox(width: 25.w),
          IconButton(
              onPressed: actionFunction,
              icon: Icon(
                actionIcon ?? Iconsax.edit_2,
                color: Theme.of(context).primaryColor,
              )),
        ],
      ],
    );
  }
}
