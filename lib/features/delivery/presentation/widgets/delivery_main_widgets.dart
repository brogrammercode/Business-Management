import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class DeliveryMainPageTile extends StatelessWidget {
  const DeliveryMainPageTile({
    super.key,
    required this.onTap,
    required this.delivery,
    required this.consumer,
    required this.delivered,
    required this.vehicle,
    required this.employee,
  });

  final void Function() onTap;
  final DeliveryModel delivery;
  final ConsumerModel consumer;
  final VehicleModel vehicle;
  final EmployeeModel employee;
  final bool delivered;

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
                    child: delivered
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
                      showBadge: delivered,
                      badgeStyle: badges.BadgeStyle(
                          badgeColor: Theme.of(context).primaryColor),
                      badgeContent:
                          Icon(Icons.check, color: Colors.white, size: 10.sp),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: consumer.image,
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
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Iconsax.clock,
                          color: delivered
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(
                            DateFormat("dd MMM, yyyy - hh:mm a")
                                .format(delivery.registrationTD.toDate()),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: delivered
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Icon(Iconsax.location, color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(delivery.deliveryAddress.toString(),
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
                      Icon(Icons.currency_rupee_rounded,
                          color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Text(delivery.fees.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                      SizedBox(width: 20.w),
                      Icon(Iconsax.truck, color: Colors.grey, size: 15.sp),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Text(employee.name,
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
