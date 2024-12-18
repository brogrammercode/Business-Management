import 'package:gas/core/config/routes/routes.dart';
import 'package:gas/core/utils/assets.dart';
import 'package:gas/core/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  IconPath.laptop,
                  height: 60.h,
                ),
                SizedBox(width: 10.w),
                Image.asset(
                  IconPath.worker,
                  height: 60.h,
                )
              ],
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      children: [
                        const TextSpan(text: 'Effortless Delivery, '),
                        TextSpan(
                            text: 'Trusted Service, ',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        const TextSpan(text: 'Efficient You'),
                      ])),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .iconTheme
                                .color!
                                .withOpacity(.4),
                          ),
                      children: [
                        const TextSpan(
                            text:
                                'Streamline your business operations with real-time delivery tracking, seamless data management, and '),
                        TextSpan(
                            text: 'Enhanced Accountability !',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ])),
            ),
            SizedBox(height: 60.h),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.home),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: Theme.of(context)
                            .iconTheme
                            .color!
                            .withOpacity(.1))),
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      IconPath.google,
                      height: 30.h,
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      'Continue with Google',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
