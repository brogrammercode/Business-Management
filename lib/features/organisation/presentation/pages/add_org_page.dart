import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/organisation/data/models/org_model.dart';
import 'package:gas/features/organisation/presentation/cubit/org_cubit.dart';

class AddOrgPage extends StatefulWidget {
  const AddOrgPage({super.key});

  @override
  State<AddOrgPage> createState() => _AddOrgPageState();
}

class _AddOrgPageState extends State<AddOrgPage> {
  File? _avatar;
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();
  final _socialController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      floatingActionButton:
          CommonFloatingActionButton(onPressed: _addOrg, icon: Icons.check),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Text('Add Organization',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold))),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Text(
                    "Adds a new organization by interacting with the repository and updates the state to reflect the success or failure of the operation.",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey))),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
              child: ProfileImagePicker(
                profileImage: _avatar,
                onImageSelected: (File selectedImage) =>
                    setState(() => _avatar = selectedImage),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: CommonTextField(
                controller: _nameController,
                labelText: 'Organization Name',
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: CommonTextField(
                controller: _bioController,
                labelText: 'Organization Description',
                keyboardType: TextInputType.name,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: CommonTextField(
                controller: _addressController,
                labelText: 'Select Address',
                keyboardType: TextInputType.name,
                readOnly: true,
                onTap: _selectAddress,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
              child: CommonTextField(
                controller: _socialController,
                labelText: 'Social Handle Link',
                keyboardType: TextInputType.name,
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(toolbarHeight: 0);
  }

  void _addOrg() async {
    final td = Timestamp.now();
    context.read<OrgCubit>().addOrg(
          org: OrgModel(
              id: td.millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              bio: _bioController.text,
              avatar: "",
              address: UserLocationModel(),
              socialHandles: [_socialController.text],
              owners: [FirebaseAuth.instance.currentUser?.uid ?? ""],
              admins: const [],
              employees: const [],
              requests: const [],
              registrationTD: td,
              registeredBy: FirebaseAuth.instance.currentUser?.uid ?? "",
              deactivate: false),
          avatar: _avatar,
        );
  }

  void _selectAddress() async {}
}
