import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BusinessStatPage extends StatefulWidget {
  const BusinessStatPage({super.key});

  @override
  State<BusinessStatPage> createState() => _BusinessStatPageState();
}

class _BusinessStatPageState extends State<BusinessStatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 200.h),
            CachedNetworkImage(
              height: 50.h,
              width: 50.h,
              fit: BoxFit.cover,
              imageUrl:
                  "https://cdn-icons-png.flaticon.com/128/7486/7486760.png",
            ),
            SizedBox(height: 30.h),
            const Text("It's quite in here...",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 70.w),
              child: const Text(
                "You can explore our services, our trustworthy and professional service providers to get the best user experience.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
