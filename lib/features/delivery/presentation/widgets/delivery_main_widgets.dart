import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/delivery/data/models/delivery_model.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';
import 'package:intl/intl.dart';

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
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.withOpacity(.3)),
            borderRadius: BorderRadius.circular(10)),
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
                      imageUrl: consumer.image),
                        ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consumer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(employee.name),
                  ],
                )
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "Order Location",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5.h),
            Text(delivery.deliveryAddress.toString()),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Time",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text(DateFormat("dd MMM, yyyy - hh:mm a")
                        .format(delivery.registrationTD.toDate()))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order Fee",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5.h),
                    Text("₹ ${delivery.fees}")
                  ],
                ),
              ],
            ),
            if (!delivered) ...[
              SizedBox(height: 20.h),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Track Order",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ))
            ],
          ],
        ),
      ),
    );
  }
}
