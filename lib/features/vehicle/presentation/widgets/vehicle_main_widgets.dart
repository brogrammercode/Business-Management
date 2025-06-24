// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';

class VehicleMainPageTile extends StatelessWidget {
  const VehicleMainPageTile({
    super.key,
    required this.onTap,
    required this.vehicle,
    required this.lastFueled,
    required this.lastRepaired,
  });

  final void Function() onTap;
  final VehicleModel vehicle;
  final String lastFueled;
  final String lastRepaired;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(.3)),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    height: 50.h,
                    width: 50.h,
                    fit: BoxFit.cover,
                    imageUrl: vehicle.logo,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  "${vehicle.brand} ${vehicle.model}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Last Repaired",
              style: Theme.of(
                context,
              ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.h),
            Text(lastRepaired),
            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Last Fueled",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.h),
                Text(lastFueled),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
