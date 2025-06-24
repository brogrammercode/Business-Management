import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:iconsax/iconsax.dart';

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
  final _socialController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      CommonImagePicker(
                        profileImage: _avatar,
                        onImageSelected: (file) {
                          setState(() {
                            _avatar = file;
                          });
                        },
                      ),
                      SizedBox(height: 30.h),
                      CommonTextFormField(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        labelText: "Name",
                        hintText: "e.g. Xyz Business",
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        validator:
                            (v) => validationForEmpty(
                              value: v,
                              label: "Business Name",
                            ),
                      ),
                      SizedBox(height: 10.h),
                      CommonTextFormField(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        labelText: "Bio",
                        hintText: "e.g. This business is about...",
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        controller: _bioController,
                      ),
                      SizedBox(height: 10.h),
                      CommonTextFormField(
                        margin: EdgeInsets.symmetric(horizontal: 15.w),
                        labelText: "Social Handles",
                        hintText: "e.g. https://instagram.com/xyz",
                        keyboardType: TextInputType.url,
                        controller: _socialController,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Iconsax.arrow_left),
      ),
      title: Text(
        "Add Business",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: _addOrg,
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _addOrg() async {
    if (_avatar == null) {
      showSnack(
        context: context,
        text: "Please provide a business avatar",
        backgroundColor: Colors.grey,
      );
    } else if (_formKey.currentState!.validate()) {
      final td = Timestamp.now();
      final location = context.read<HomeCubit>().state.lastLocation;
      showSnack(
        context: context,
        text: "Adding ${_nameController.text} as a business",
        backgroundColor: Colors.grey,
      );
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
        showSnack(
          context: context,
          text: "${_nameController.text} added successfully",
        );
      }
    }
  }
}
