import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class VehicleMainPageTile extends StatelessWidget {
  const VehicleMainPageTile({
    super.key,
    required this.onTap,
    required this.vehicle,
    required this.driving,
    required this.lastPosition,
    required this.lastFueled,
    required this.lastRepaired,
    required this.lastDriver,
  });

  final void Function() onTap;
  final VehicleModel vehicle;
  final bool driving;
  final String lastPosition;
  final String lastFueled;
  final String lastRepaired;
  final String lastDriver;

  @override
  Widget build(BuildContext context) {
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
                    child: driving
                        ? SimpleCircularProgressBar(
                            backStrokeWidth: 0,
                            startAngle: 120,
                            progressStrokeWidth: 3,
                            progressColors: [
                              Theme.of(context).primaryColor,
                              Theme.of(context).primaryColor.withOpacity(.1)
                            ],
                            animationDuration: 1,
                          )
                        : null,
                  ),
                  Center(
                    child: badges.Badge(
                      position: badges.BadgePosition.bottomEnd(
                          bottom: -1.h, end: -5.h),
                      showBadge: driving,
                      badgeStyle: badges.BadgeStyle(
                          badgeColor: Theme.of(context).primaryColor),
                      badgeContent: Icon(Icons.electric_bolt_rounded,
                          color: Colors.white, size: 10.sp),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: vehicle.logo,
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
                  Text("${vehicle.brand} ${vehicle.model}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.location_history,
                          color: driving
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(lastPosition,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: driving
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Iconsax.gas_station,
                          color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(lastFueled,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Icons.car_repair_rounded,
                          color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(lastRepaired,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Iconsax.user, color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(lastDriver,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
