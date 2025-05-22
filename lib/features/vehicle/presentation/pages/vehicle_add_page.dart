import 'package:flutter/material.dart';

class VehicleAddPage extends StatefulWidget {
  const VehicleAddPage({super.key});

  @override
  State<VehicleAddPage> createState() => _VehicleAddPageState();
}

class _VehicleAddPageState extends State<VehicleAddPage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            //   child: CommonTextField(labelText: "Name", controller: _name),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            //   child: CommonTextField(labelText: "Brand", controller: _brand),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            //   child: CommonTextField(labelText: "Model", controller: _model),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            //   child: CommonTextField(
            //     labelText: "Current Odometer",
            //     controller: _odo,
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            //   child: CommonTextField(
            //     labelText: "Registration Number",
            //     controller: _regNo,
            //     keyboardType: TextInputType.number,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
