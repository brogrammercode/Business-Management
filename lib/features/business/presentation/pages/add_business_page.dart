import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';

class AddBusinessPage extends StatefulWidget {
  const AddBusinessPage({super.key});

  @override
  State<AddBusinessPage> createState() => _AddBusinessPageState();
}

class _AddBusinessPageState extends State<AddBusinessPage> {
  final _formKey = GlobalKey<FormState>();
  File? _avatar;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController(text: "h");
  final _socialController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context),
          floatingActionButton: CommonFloatingActionButton(
              onPressed: _addOrg,
              icon: Icons.check,
              loading: state.addBusinessStatus == StateStatus.loading),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text('Add Business',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold))),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    child: CommonImagePicker(
                      profileImage: _avatar,
                      onImageSelected: (File selectedImage) =>
                          setState(() => _avatar = selectedImage),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _nameController,
                      labelText: 'Business Name',
                      keyboardType: TextInputType.name,
                      validator: (v) => validationForEmpty(
                          value: v, label: "Business Name"),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _bioController,
                      labelText: 'Business Description',
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _addressController,
                      labelText: 'Select Address',
                      
                      keyboardType: TextInputType.name,
                      validator: (v) =>
                          validationForEmpty(value: v, label: "address"),
                      onTap: _selectAddress,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _socialController,
                      labelText: 'Social Handle Link',
                      keyboardType: TextInputType.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(toolbarHeight: 0);
  }

  void _addOrg() async {
    if (_avatar == null) {
      showSnack(context: context, text: "Please provide a business avatar");
    } else if (_formKey.currentState!.validate()) {
      final td = Timestamp.now();
      final location = context.read<HomeCubit>().state.lastLocation;
      final success = await context.read<BusinessCubit>().addBusiness(
            business: BusinessModel(
              id: td.millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              bio: _bioController.text,
              avatar: "",
              location: location.isEmpty ? UserLocationModel() : location.first,
              socialHandles: [_socialController.text],
              owners: [FirebaseAuth.instance.currentUser?.uid ?? ""],
              admins: const [],
              employees: const [],
              requests: const [],
              creationTD: td,
              createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
              deactivate: false,
            ),
            avatar: _avatar,
          );

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  void _selectAddress() async {}
}
