import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/assets.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';
import 'package:gas/features/consumer/presentation/widgets/consumer_detail_widgets.dart';
import 'package:iconsax/iconsax.dart';

class ConsumerDetailPage extends StatelessWidget {
  final ConsumerModel consumer;
  const ConsumerDetailPage({super.key, required this.consumer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 15.h),
            Padding(
                padding: EdgeInsets.only(left: 25.w, right: 15.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(consumer.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Icon(Iconsax.hashtag,
                                  color: Colors.grey, size: 17.h),
                              SizedBox(width: 6.w),
                              Text(consumer.consumerNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.ellipsis_vertical))
                  ],
                )),
            SizedBox(height: 20.h),
            ProfileImagePicker(
                networkImage: consumer.image.isEmpty
                    ? NetworkImagePath.consumerImage
                    : consumer.image,
                onImageSelected: (i) {}),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 15.w, bottom: 20.h),
              child: ConsumerInfoTile(
                  showAlertBadge: consumer.name.isEmpty,
                  leadingIcon: Iconsax.user,
                  actionIcon:
                      consumer.name.isEmpty ? Iconsax.add : Iconsax.edit_2,
                  actionFunction: () {},
                  title: 'Name',
                  subtitle:
                      consumer.name.isEmpty ? "Enter Name" : consumer.name),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 15.w, bottom: 20.h),
              child: ConsumerInfoTile(
                  showAlertBadge: consumer.address.isEmpty,
                  leadingIcon: Iconsax.location,
                  actionIcon:
                      consumer.address.isEmpty ? Iconsax.add : Iconsax.edit_2,
                  actionFunction: () {},
                  title: 'Address',
                  subtitle: consumer.address.isEmpty
                      ? "Select Address"
                      : consumer.address),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 15.w, bottom: 20.h),
              child: ConsumerInfoTile(
                  showAlertBadge: consumer.phoneNo.isEmpty,
                  leadingIcon: Iconsax.call,
                  actionIcon:
                      consumer.phoneNo.isEmpty ? Iconsax.add : Iconsax.edit_2,
                  actionFunction: () {},
                  title: 'Phone Number',
                  subtitle: consumer.phoneNo.isEmpty
                      ? "Enter Phone Number"
                      : consumer.phoneNo),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 15.w, bottom: 20.h),
              child: ConsumerInfoTile(
                  showAlertBadge: consumer.gender.isEmpty,
                  leadingIcon: consumer.gender == "Male"
                      ? Icons.male
                      : consumer.gender == "Female"
                          ? Icons.female
                          : Iconsax.user_add,
                  actionIcon: consumer.gender.isEmpty
                      ? Iconsax.add
                      : CupertinoIcons.chevron_up,
                  actionFunction: () {},
                  title: 'Gender',
                  subtitle: consumer.gender.isEmpty
                      ? "Select Gender"
                      : consumer.gender),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 15.w, bottom: 20.h),
              child: ConsumerInfoTile(
                  showAlertBadge: consumer.consumerAadharNo.isEmpty,
                  leadingIcon: Iconsax.personalcard,
                  actionIcon: consumer.consumerAadharNo.isEmpty
                      ? Iconsax.add
                      : Iconsax.edit_2,
                  actionFunction: () {},
                  title: 'Aadhar Card No',
                  subtitle: consumer.consumerAadharNo.isEmpty
                      ? "Enter Aadhar Card No"
                      : consumer.consumerAadharNo),
            ),
          ],
        ),
      ),
    );
  }
}
