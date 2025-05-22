// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class BusinessMain extends StatefulWidget {
  const BusinessMain({super.key});

  @override
  State<BusinessMain> createState() => _BusinessMainState();
}

class _BusinessMainState extends State<BusinessMain> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        final businesses = state.businesses;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: businesses.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final business = businesses[index];
                  final participants = [
                    ...business.owners,
                    ...business.admins,
                    ...business.employees,
                    ...business.requests,
                  ];
                  return InkWell(
                    onTap: () => _onOrgtap(businessID: business.business.id),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 15.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(
                            imageUrl: business.business.avatar,
                            title: business.business.name,
                            subtitle:
                                business.owners.isEmpty
                                    ? "Owner"
                                    : business.owners.first.employee.name,
                          ),
                          SizedBox(height: 20.h),
                          _buildSectionTitle(context, "Created On"),
                          Text(
                            DateFormat(
                              "dd MMM, yyyy",
                            ).format(business.business.creationTD.toDate()),
                          ),
                          SizedBox(height: 20.h),
                          _buildSectionTitle(context, "Participants"),
                          SizedBox(height: 10.h),
                          _buildParticipantsRow(
                            images:
                                participants
                                    .map((e) => e.employee.avatar)
                                    .toList(),
                            context: context,
                            businessID: business.business.id,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            height: 50.h,
            width: 50.h,
            fit: BoxFit.cover,
            imageUrl: imageUrl,
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(subtitle),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildParticipantsRow({
    required List<String> images,
    required BuildContext context,
    required String businessID,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 45.h,
            child: Stack(
              children:
                  images.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final url = entry.value;

                    if (idx > 3) {
                      return const SizedBox.shrink(); // Hide extra avatars
                    }

                    return Positioned(
                      left: idx * 25.w,
                      child:
                          idx == 3 && images.length > 4
                              ? _buildMoreParticipantsIndicator(
                                context,
                                images.length - 3,
                              )
                              : _buildParticipantAvatar(url),
                    );
                  }).toList(),
            ),
          ),
        ),
        TextButton(
          onPressed:
              () => context.read<BusinessCubit>().requestToJoinBusiness(
                businessID: businessID,
              ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Request to Join',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 7.w),
              Icon(Iconsax.arrow_right_3, size: 14.r),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantAvatar(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.w),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 35.h,
          width: 35.h,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildMoreParticipantsIndicator(
    BuildContext context,
    int remainingCount,
  ) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.w),
        boxShadow: [
          BoxShadow(color: Colors.black12.withOpacity(0.1), blurRadius: 5),
        ],
      ),
      child: ClipOval(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          height: 35.h,
          width: 35.h,
          child: Center(
            child: Text(
              '+$remainingCount',
              style: TextStyle(
                color: Colors.white,
                fontSize:
                    Theme.of(context).textTheme.bodySmall?.fontSize ?? 12.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onOrgtap({required String businessID}) async {
    context.read<BusinessCubit>().updateBusinessID(businessID: businessID);
    //
  }
}
