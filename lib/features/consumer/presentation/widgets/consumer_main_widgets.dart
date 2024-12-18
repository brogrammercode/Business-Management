import 'package:badges/badges.dart' as badges;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/assets.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:shimmer_container/shimmer_container.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class ConsumerGettingAllConsumersShimmer extends StatelessWidget {
  const ConsumerGettingAllConsumersShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
      child: Row(
        children: [
          ShimmerContainer(
            width: 50.h,
            height: 50.h,
            radius: 100.h,
            fadeTheme: FadeTheme.light,
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ShimmerContainer(
                  width: 120.w,
                  height: 15.h,
                  fadeTheme: FadeTheme.light,
                  radius: 5,
                ),
                SizedBox(height: 5.h),
                ShimmerContainer(
                  width: 180.w,
                  height: 15.h,
                  fadeTheme: FadeTheme.light,
                  radius: 5,
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShimmerContainer(
                width: 50.w,
                height: 15.h,
                fadeTheme: FadeTheme.light,
                radius: 5,
              ),
              SizedBox(height: 5.h),
              ShimmerContainer(
                width: 70.w,
                height: 15.h,
                fadeTheme: FadeTheme.light,
                radius: 5,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ConsumerMainPageTile extends StatelessWidget {
  const ConsumerMainPageTile({
    super.key,
    required this.consumer,
    required this.onTap,
  });

  final ConsumerModel consumer;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    int profileCompletion = calculateProfileCompletion(consumer: consumer);

    Color profileCompletionColor = getProfileCompletionColor(profileCompletion);

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
        child: Row(
          children: [
            SizedBox(
              height: 55.h,
              width: 55.h,
              child: Stack(
                children: [
                  SizedBox(
                    height: 55.h,
                    width: 55.h,
                    child: SimpleCircularProgressBar(
                      backStrokeWidth: 0,
                      startAngle: 120,
                      progressStrokeWidth: 3,
                      progressColors: [
                        profileCompletionColor,
                        profileCompletionColor.withOpacity(.1)
                      ],
                      maxValue: profileCompletion.toDouble(),
                      animationDuration: 1,
                    ),
                  ),
                  Center(
                    child: badges.Badge(
                      position: badges.BadgePosition.bottomEnd(
                          bottom: -1.h, end: -5.h),
                      showBadge: true,
                      badgeStyle:
                          badges.BadgeStyle(badgeColor: profileCompletionColor),
                      badgeContent: profileCompletion == 100
                          ? Icon(Icons.check, color: Colors.white, size: 10.sp)
                          : Text("$profileCompletion",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: 7.sp,
                                      fontWeight: FontWeight.bold)),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: consumer.image.isEmpty
                              ? NetworkImagePath.consumerImage
                              : consumer.image,
                          height: 50.h,
                          width: 50.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consumer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(consumer.address.isEmpty ? "India" : consumer.address,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(width: 15.w),
            // if (consumer.due != 0) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("₹ ${(consumer.due != 0) ? consumer.due : consumer.paid}",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: (consumer.due != 0)
                            ? Colors.redAccent
                            : Colors.green)),
                // SizedBox(height: 2.h),
                Text((consumer.due != 0) ? "due" : "paid",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
              ],
            )
            // ] else ...[
            //   const Icon(Iconsax.security_safe, color: Colors.green)
            // ],
          ],
        ),
      ),
    );
  }
}

int calculateProfileCompletion({required ConsumerModel consumer}) {
  int totalFields = 11;

  if (consumer.gender.toLowerCase() == 'Female') {
    totalFields += 2;
  }

  int completedFields = 0;

  if (consumer.image.isNotEmpty) completedFields++;
  if (consumer.name.isNotEmpty) completedFields++;
  if (consumer.phoneNo.isNotEmpty) completedFields++;
  if (consumer.gender.isNotEmpty) completedFields++;
  if (consumer.consumerNo.isNotEmpty) completedFields++;
  if (consumer.address.isNotEmpty) completedFields++;
  if (consumer.svNo.isNotEmpty) completedFields++;
  if (consumer.consumerAadharNo.isNotEmpty) completedFields++;
  if (consumer.rationNo.isNotEmpty) completedFields++;
  if (consumer.bankAccountNo.isNotEmpty) completedFields++;
  // ignore: unnecessary_null_comparison
  if (consumer.registrationTD != null) completedFields++;

  if (consumer.gender.toLowerCase() == 'Female') {
    if (consumer.husbandspouseName.isNotEmpty) completedFields++;
    if (consumer.husbandspouseAadharNo.isNotEmpty) completedFields++;
  }

  return ((completedFields / totalFields) * 100).toInt();
}

Color getProfileCompletionColor(int completion) {
  if (completion <= 50) {
    return Colors.redAccent;
  } else if (completion > 50 && completion < 100) {
    return Colors.orange;
  } else {
    return Colors.green;
  }
}
