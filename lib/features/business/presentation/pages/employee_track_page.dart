// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EmployeeTrackPage extends StatelessWidget {
  final String employeeID;
  const EmployeeTrackPage({super.key, required this.employeeID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BusinessCubit, BusinessState>(
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser?.uid;

        final myBusiness = state.businesses.firstWhere(
          (business) =>
              business.owners.any((owner) => owner.employee.id == uid) ||
              business.admins.any((admin) => admin.employee.id == uid) ||
              business.requests.any((request) => request.employee.id == uid) ||
              business.employees.any((employee) => employee.employee.id == uid),
        );

        final employees = [
          ...myBusiness.admins,
          ...myBusiness.owners,
          ...myBusiness.employees,
          ...myBusiness.requests,
        ];

        final selectedEmployee = employees.firstWhere(
          (e) => e.employee.id == employeeID,
        );

        final tracks = selectedEmployee.tracks;
        final allTracks = tracks.expand((e) => e.tracks).toList();
        final selectedEmployeeDetail = selectedEmployee.employee;
        final salaries = selectedEmployee.salaries;

        return Scaffold(
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  _buildSliverAppBar(
                    context: context,
                    employee: selectedEmployeeDetail,
                  ),
                  SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () {
                        showSnack(
                          text: "Will be available in next update",
                          backgroundColor: AppColors.red500,
                        );
                        // Navigator.pushNamed(
                        //   context,
                        //   AppRoutes.trackPage,
                        //   arguments: {"employeeID": selectedEmployeeDetail.id},
                        // );
                      },
                      child: CachedNetworkImage(
                        height: 300.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: mapImage(
                          points: [selectedEmployeeDetail.address.geopoint],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: salaries.length,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SliverFillRemaining(),
                ],
              ),
              _buildDraggableSheet(allTracks),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSliverAppBar({
    required BuildContext context,
    required EmployeeModel employee,
  }) {
    return SliverAppBar(
      expandedHeight: 180.h,
      stretch: true,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(Iconsax.arrow_left),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Text(
                "${employee.address.area}, ${employee.address.city}, ${employee.address.state}, ${employee.address.country} Pin - ${employee.address.pincode}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(.3)),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                "Updated on ${DateFormat("dd MMM, hh:mm a").format(employee.address.updateTD.toDate())}",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
      title: Text(
        employee.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  Widget _buildDraggableSheet(List<UserLocationModel> tracks) {
    // Step 1: Sort the tracks by `updateTD` in descending order
    tracks.sort((a, b) => b.updateTD.compareTo(a.updateTD));

    // Step 2: Remove duplicates but allow same area if 20 min has passed
    // final Map<String, DateTime> lastSeenArea = {};
    List<UserLocationModel> filteredTracks = [];

    // for (var track in tracks) {
    //   final area = track.area;
    //   final timestamp = track.updateTD.toDate();

    //   if (!lastSeenArea.containsKey(area) ||
    //       timestamp.difference(lastSeenArea[area]!).inMinutes > 20) {
    //     filteredTracks.add(track);
    //     lastSeenArea[area] = timestamp;
    //   }
    // }

    filteredTracks = tracks;

    return DraggableScrollableSheet(
      initialChildSize: 0.42,
      minChildSize: 0.42,
      maxChildSize: 0.78,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
            boxShadow: [BoxShadow(blurRadius: 10.r, color: Colors.black12)],
          ),
          child: Column(
            children: [
              Container(
                height: 5.h,
                width: 50.w,
                margin: EdgeInsets.all(10.h),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: filteredTracks.length,
                  itemBuilder: (context, index) {
                    final track = filteredTracks[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              index != (filteredTracks.length - 1)
                                  ? BorderSide(
                                    color: Colors.grey.withOpacity(.1),
                                  )
                                  : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat(
                                    "dd",
                                  ).format(track.updateTD.toDate()),
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat(
                                    "MMM",
                                  ).format(track.updateTD.toDate()),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 15.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${track.area}, ${track.city}, ${track.state}, ${track.country} Pin - ${track.pincode}",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  DateFormat(
                                    "dd MMM, hh:mm a",
                                  ).format(track.updateTD.toDate()),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
