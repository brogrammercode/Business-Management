// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/address_picker.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/delivery/data/models/consumer_model.dart';
import 'package:gas/features/delivery/presentation/cubit/delivery_cubit.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class AddConsumerPage extends StatefulWidget {
  final ConsumerModel? consumer;
  const AddConsumerPage({super.key, this.consumer});

  @override
  State<AddConsumerPage> createState() => _AddConsumerPageState();
}

class _AddConsumerPageState extends State<AddConsumerPage> {
  File? profileImage;
  String? profileImageUrl;
  final _nameController = TextEditingController();
  final _fatherSpouseNameController = TextEditingController();
  final _phoneNumberController = TextEditingController(text: "+91");
  final _dobController = TextEditingController();
  DateTime _dob = DateTime.now();
  final _consumerNumberController = TextEditingController();
  final _addressController = TextEditingController();
  UserLocationModel _address = UserLocationModel();
  final _subscriptionVoucherController = TextEditingController();
  final _consumerAadhaarController = TextEditingController();
  final _fatherSpouseAadhaarController = TextEditingController();
  final _rationCardController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _moneyPaidController = TextEditingController();
  final _moneyDueController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final toUpdate = widget.consumer != null;
    if (toUpdate) {
      final c = widget.consumer!;
      _nameController.text = c.name;
      _fatherSpouseNameController.text = c.husbandspouseName;
      _phoneNumberController.text = c.phoneNo;
      _dob = c.dob.toDate();
      _dobController.text = DateFormat('dd MMMM, yyyy').format(_dob);
      _consumerNumberController.text = c.consumerNo;
      _address = c.address;
      _addressController.text =
          "${c.address.area}, ${c.address.city}, ${c.address.state}";
      _subscriptionVoucherController.text = c.svNo;
      _consumerAadhaarController.text = c.consumerAadharNo;
      _fatherSpouseAadhaarController.text = c.husbandspouseAadharNo;
      _rationCardController.text = c.rationNo;
      _bankAccountController.text = c.bankAccountNo;
      _moneyPaidController.text = c.paid.toString();
      _moneyDueController.text = c.due.toString();
      _genderController.text = c.gender;
      profileImageUrl = c.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                CommonImagePicker(
                  networkImage: profileImageUrl,
                  onImageSelected: (file) {
                    setState(() {
                      profileImage = file;
                    });
                  },
                  profileImage: profileImage,
                ),
                SizedBox(height: 30.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Name",
                  hintText: "e.g. Xyz Kumar",
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: 'Phone Number',
                  hintText: "e.g. +91 986754657",
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: 'Date of Birth',
                  hintText: "e.g. 27 May, 2025",
                  controller: _dobController,
                  suffixIcon: Iconsax.arrow_down_1,
                  onTap: () async {
                    final date = await pickDate(initialDate: _dob);
                    if (date != null) {
                      setState(() {
                        _dob = date;
                        _dobController.text = DateFormat(
                          'dd MMMM, yyyy',
                        ).format(date);
                      });
                    }
                  },
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Gender",
                  hintText: "e.g. Male",
                  controller: _genderController,
                  suffixIcon: Iconsax.arrow_down_1,
                  onTap: () async {
                    openBottomSheet(
                      minChildSize: 0.22,
                      initialChildSize: 0.22,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          bottomSheetTile(
                            context: context,
                            icon: Iconsax.man,
                            title: 'Male',
                            subtitle: 'He / Him',
                            onTap: () {
                              setState(() {
                                _genderController.text = "Male";
                              });
                              Navigator.pop(context);
                            },
                          ),
                          bottomSheetTile(
                            context: context,
                            icon: Iconsax.woman,
                            title: 'Female',
                            subtitle: 'She / Her',
                            onTap: () {
                              setState(() {
                                _genderController.text = "Female";
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Address",
                  hintText: "e.g. Barai, Bhagalpur, Bihar",
                  keyboardType: TextInputType.multiline,
                  controller: _addressController,
                  suffixIcon: Iconsax.arrow_down_1,
                  onTap: () async {
                    final address = await pickAddress(
                      context: context,
                      initialAddress: _address,
                    );
                    if (address != null) {
                      setState(() {
                        _address = address;
                        _addressController.text =
                            "${address.area}, ${address.city}, ${address.state}";
                      });
                    }
                  },
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Aadhar Number",
                  hintText: "e.g. 8327823924928",
                  keyboardType: TextInputType.number,
                  controller: _consumerAadhaarController,
                ),
                SizedBox(height: 10.h),
                _heading(text: "Father / Spouse Details"),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Father's / Spouse's Name",
                  hintText: "e.g. Xyz Kumar",
                  keyboardType: TextInputType.name,
                  controller: _fatherSpouseNameController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Father's / Spouse's Aadhar No.",
                  hintText: "e.g. 8327823924928",
                  keyboardType: TextInputType.number,
                  controller: _fatherSpouseAadhaarController,
                ),
                SizedBox(height: 10.h),
                _heading(text: "Account Details"),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Consumer No.",
                  hintText: "e.g. 56689645678",
                  keyboardType: TextInputType.number,
                  controller: _consumerNumberController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Subscription Voucher No.",
                  hintText: "e.g. 87654678",
                  keyboardType: TextInputType.number,
                  controller: _subscriptionVoucherController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Ration Card No.",
                  hintText: "e.g. 867876756779",
                  keyboardType: TextInputType.number,
                  controller: _rationCardController,
                ),
                SizedBox(height: 10.h),
                CommonTextFormField(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  labelText: "Bank Account No.",
                  hintText: "e.g. 12000000100100100",
                  keyboardType: TextInputType.number,
                  controller: _bankAccountController,
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFormField(
                        margin: EdgeInsets.only(left: 15.w, right: 10.w),
                        labelText: "Money Paid",
                        hintText: "e.g. 1200",
                        keyboardType: TextInputType.number,
                        controller: _moneyPaidController,
                      ),
                    ),
                    Expanded(
                      child: CommonTextFormField(
                        margin: EdgeInsets.only(right: 15.w),
                        labelText: "Money Due",
                        hintText: "e.g. 100",
                        keyboardType: TextInputType.number,
                        controller: _moneyDueController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding _heading({required String text}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
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
        "Add Consumer",
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () async {
            showSnack(
              text: "Saving Consumer...",
              backgroundColor: AppColors.blue500,
              sticky: true,
            );
            final td = Timestamp.now();
            final businessID = context.read<BusinessCubit>().state.businessID;
            final oldConsumer = widget.consumer;

            final result = widget.consumer != null
                ? await context.read<DeliveryCubit>().updateConsumer(
                    image: profileImage,
                    consumer: ConsumerModel(
                      id: oldConsumer?.id ?? "",
                      name: _nameController.text,
                      image: "",
                      husbandspouseName: _fatherSpouseNameController.text,
                      phoneNo: _phoneNumberController.text,
                      gender: _genderController.text,
                      dob: Timestamp.fromDate(_dob),
                      consumerNo: _consumerNumberController.text,
                      address: _address,
                      svNo: _subscriptionVoucherController.text,
                      consumerAadharNo: _consumerAadhaarController.text,
                      husbandspouseAadharNo:
                          _fatherSpouseAadhaarController.text,
                      rationNo: _rationCardController.text,
                      bankAccountNo: _bankAccountController.text,
                      paid: _moneyPaidController.text.isEmpty
                          ? 0
                          : num.parse(_moneyPaidController.text),
                      due: _moneyDueController.text.isEmpty
                          ? 0
                          : num.parse(_moneyDueController.text),
                      businessID: businessID,
                      creationTD: oldConsumer?.creationTD ?? td,
                      createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
                      deactivate: false,
                    ),
                  )
                : await context.read<DeliveryCubit>().addConsumer(
                    image: profileImage,
                    consumer: ConsumerModel(
                      id: td.millisecondsSinceEpoch.toString(),
                      name: _nameController.text,
                      image: "",
                      husbandspouseName: _fatherSpouseNameController.text,
                      phoneNo: _phoneNumberController.text,
                      gender: _genderController.text,
                      dob: Timestamp.fromDate(_dob),
                      consumerNo: _consumerNumberController.text,
                      address: _address,
                      svNo: _subscriptionVoucherController.text,
                      consumerAadharNo: _consumerAadhaarController.text,
                      husbandspouseAadharNo:
                          _fatherSpouseAadhaarController.text,
                      rationNo: _rationCardController.text,
                      bankAccountNo: _bankAccountController.text,
                      paid: _moneyPaidController.text.isEmpty
                          ? 0
                          : num.parse(_moneyPaidController.text),
                      due: _moneyDueController.text.isEmpty
                          ? 0
                          : num.parse(_moneyDueController.text),
                      businessID: businessID,
                      creationTD: td,
                      createdBy: FirebaseAuth.instance.currentUser?.uid ?? "",
                      deactivate: false,
                    ),
                  );

            if (result) {
              Navigator.of(context).pop();
              showSnack(
                text: "Consumer Added Successfully",
                backgroundColor: AppColors.green500,
              );
            } else {
              showSnack(
                text: "Failed to add consumer",
                backgroundColor: AppColors.red500,
              );
            }
          },
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
