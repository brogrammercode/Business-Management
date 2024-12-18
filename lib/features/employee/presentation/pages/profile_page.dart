import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Center(
            child: SizedBox(
              height: 135.h,
              width: 135.h,
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  height: 125.h,
                  width: 125.h,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 10)
                      ],
                      border: Border.all(color: Colors.white, width: 7.w)),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                          height: 125.h,
                          width: 125.h,
                          fit: BoxFit.cover,
                          imageUrl:
                              "https://cdn.dribbble.com/userupload/16281153/file/original-b6ff14bfc931d716c801ea7e250965ce.png?resize=1600x1200&vertical=center")),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text("Credence Anderson",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          Text("Employee",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w500, color: Colors.grey)),
          SizedBox(height: 30.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.frame_1),
                    SizedBox(width: 20.w),
                    const Text("Your Profile",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                const Icon(Iconsax.arrow_right_3)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.dollar_circle),
                    SizedBox(width: 20.w),
                    const Text("Salary & Earnings",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                const Icon(Iconsax.arrow_right_3)
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.unlock),
                    SizedBox(width: 20.w),
                    const Text("Log out",
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                const Icon(Iconsax.arrow_right_3)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
