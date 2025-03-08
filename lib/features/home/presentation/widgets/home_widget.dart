import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class HomePageHeader extends StatelessWidget {
  final String topText;
  final String bottomText;
  final IconData? actionIcon;
  final void Function()? actionOnPressed;
  final void Function() onNotificationPressed;
  const HomePageHeader({
    super.key,
    required this.topText,
    required this.bottomText,
    required this.onNotificationPressed,
    this.actionIcon,
    this.actionOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(topText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Iconsax.calendar, color: Colors.grey, size: 17.h),
                    SizedBox(width: 6.w),
                    Text(bottomText,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
          if (actionIcon != null) ...[
            IconButton(
                onPressed: actionOnPressed,
                icon:
                    Icon(actionIcon, color: Theme.of(context).iconTheme.color)),
          ],
          IconButton(
              onPressed: onNotificationPressed,
              icon: const Icon(Iconsax.notification))
        ],
      ),
    );
  }
}
