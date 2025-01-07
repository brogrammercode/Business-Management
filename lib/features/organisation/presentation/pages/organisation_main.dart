import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/features/organisation/presentation/cubit/org_cubit.dart';

class OrganisationMain extends StatefulWidget {
  const OrganisationMain({super.key});

  @override
  State<OrganisationMain> createState() => _OrganisationMainState();
}

class _OrganisationMainState extends State<OrganisationMain> {
  final List<String> participants = [
    "https://cdn.dribbble.com/userupload/16403798/file/original-ea1aa8f7d719cfc74ae33e3efc268cf7.png?resize=1600x1200&vertical=center",
    "https://cdn.dribbble.com/userupload/16403037/file/original-a19ea3eab583b6f672ecae9bfa789114.png?resize=1600x1200&vertical=center",
    "https://cdn.dribbble.com/userupload/16265134/file/original-0ecc04ffbfed43852753ced92d01cfb7.png?resize=1600x1200&vertical=center",
    "https://cdn.dribbble.com/userupload/16265349/file/original-04d33c2b6918da4a4fd5b4ff57145aef.png?resize=1600x1200&vertical=center"
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrgCubit, OrgState>(
      listener: (context, state) {},
      builder: (context, state) {
        final orgs = state.orgs;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                  itemCount: orgs.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: _onOrgtap,
                      child: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 10.h),
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            SizedBox(height: 20.h),
                            _buildSectionTitle(context, "Created On"),
                            const Text("25 Dec, 2024"),
                            SizedBox(height: 20.h),
                            _buildSectionTitle(context, "Participants"),
                            SizedBox(height: 10.h),
                            _buildParticipantsRow(),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        ClipOval(
          child: CachedNetworkImage(
            height: 50.h,
            width: 50.h,
            fit: BoxFit.cover,
            imageUrl:
                "https://cdn.dribbble.com/userupload/16404014/file/original-7cd57b8c3c4041eacb8dc3883d467fef.png?resize=1200x900&vertical=center",
          ),
        ),
        SizedBox(width: 10.w),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sonu's Org",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Sonu Kumar"),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .bodySmall!
          .copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildParticipantsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            height: 45.h,
            child: Stack(
              children: participants.asMap().entries.map((entry) {
                final idx = entry.key;
                final url = entry.value;
                return Positioned(
                  left: idx * 25.w,
                  child: idx == 3
                      ? _buildMoreParticipantsIndicator()
                      : idx > 3
                          ? const SizedBox.shrink()
                          : _buildParticipantAvatar(url),
                );
              }).toList(),
            ),
          ),
        ),
        Text('${participants.length} People joined'),
      ],
    );
  }

  Widget _buildParticipantAvatar(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 5,
          ),
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

  Widget _buildMoreParticipantsIndicator() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 5,
          ),
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
              '+${participants.length - 3}',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onOrgtap() async {
    context.read<OrgCubit>().updateOrgID(orgID: "");
  }
}
