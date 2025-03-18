import 'package:flutter/material.dart';
import 'package:gas/core/utils/common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VehicleAddPage extends StatefulWidget {
  const VehicleAddPage({super.key});

  @override
  State<VehicleAddPage> createState() => _VehicleAddPageState();
}

class _VehicleAddPageState extends State<VehicleAddPage> {
  final _name = TextEditingController();
  final _brand = TextEditingController();
  final _model = TextEditingController();
  final _regNo = TextEditingController();
  final _odo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: CommonTextField(labelText: "Name", controller: _name),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: CommonTextField(labelText: "Brand", controller: _brand),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: CommonTextField(labelText: "Model", controller: _model),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: CommonTextField(
                labelText: "Current Odometer",
                controller: _odo,
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: CommonTextField(
                labelText: "Registration Number",
                controller: _regNo,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
