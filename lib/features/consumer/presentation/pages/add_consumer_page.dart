import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/consumer/domain/usecases/add_consumer.dart';
import 'package:gas/features/consumer/presentation/bloc/consumer_bloc.dart';
import 'package:gas/features/consumer/data/models/consumer_model.dart';

class AddConsumerPage extends StatefulWidget {
  const AddConsumerPage({super.key});

  @override
  State<AddConsumerPage> createState() => _AddConsumerPageState();
}

class _AddConsumerPageState extends State<AddConsumerPage> {
  File? profileImage;
  final _nameController = TextEditingController();
  final _fatherSpouseNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _consumerNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _subscriptionVoucherController = TextEditingController();
  final _consumerAadhaarController = TextEditingController();
  final _fatherSpouseAadhaarController = TextEditingController();
  final _rationCardController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _moneyPaidController = TextEditingController();
  final _moneyDueController = TextEditingController();
  final _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TransparentAppBar(),
      floatingActionButton: CommonFloatingActionButton(
          onPressed: _addConsumer, icon: Icons.check),
      body: BlocConsumer<ConsumerBloc, ConsumerState>(
        listener: (context, state) {
          if (state is ConsumerError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ConsumerUploadingDetails) {
            return Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Theme.of(context).primaryColor));
          }

          if (state is ConsumerError) {
            return Center(
                child: Text(state.message,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)));
          }

          if (state is ConsumerAllConsumersFetched) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15.h),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text('Add User',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25.w),
                      child: Text(
                          "Users can be registered by inputting the data as required.",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey))),
                  SizedBox(height: 20.h),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
                    child: ProfileImagePicker(
                      profileImage: profileImage,
                      onImageSelected: (File selectedImage) {
                        setState(() {
                          profileImage = selectedImage;
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _nameController,
                      labelText: 'Name',
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _fatherSpouseNameController,
                      labelText: "Father's / Spouse's Name",
                      keyboardType: TextInputType.name,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _phoneNumberController,
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _genderController,
                      labelText: 'Gender',
                      keyboardType: TextInputType.text,
                      readOnly: true,
                      onTap: () {
                        _showGenderPickerDialog();
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _consumerNumberController,
                      labelText: 'Consumer Number',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      keyboardType: TextInputType.streetAddress,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _subscriptionVoucherController,
                      labelText: 'Subscription Voucher No.',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _consumerAadhaarController,
                      labelText: 'Consumer Aadhaar Card No.',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _fatherSpouseAadhaarController,
                      labelText: "Father's / Spouse's Aadhaar No.",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _rationCardController,
                      labelText: "Ration Card No.",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _bankAccountController,
                      labelText: "Bank Account No.",
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _moneyPaidController,
                      labelText: 'Money Paid',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
                    child: CommonTextField(
                      controller: _moneyDueController,
                      labelText: 'Money Due',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          }
          return Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Theme.of(context).primaryColor));
        },
      ),
    );
  }

  Future<void> _addConsumer() async {
    if (_nameController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _consumerNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Please fill all the required fields',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.w500, color: Colors.white),
        )),
      );
      return;
    }

    final td = DateTime.now();

    num parseOrDefault(String value, num defaultValue) {
      try {
        return num.parse(value);
      } catch (e) {
        return defaultValue;
      }
    }

    try {
      final consumer = ConsumerModel(
        id: td.millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        image: '',
        husbandspouseName: _fatherSpouseNameController.text,
        phoneNo: _phoneNumberController.text,
        gender: _genderController.text,
        consumerNo: _consumerNumberController.text,
        address: _addressController.text,
        svNo: _subscriptionVoucherController.text,
        consumerAadharNo: _consumerAadhaarController.text,
        husbandspouseAadharNo: _fatherSpouseAadhaarController.text,
        rationNo: _rationCardController.text,
        bankAccountNo: _bankAccountController.text,
        paid: parseOrDefault(_moneyPaidController.text, 0),
        due: parseOrDefault(_moneyDueController.text, 0),
        registrationTD: Timestamp.fromDate(td),
        registeredBy: "Anonymous",
        deactivate: false,
        dob: Timestamp.now(),
        orgID: '',
        addressGeoPoint: const GeoPoint(0, 0),
      );

      BlocProvider.of<ConsumerBloc>(context).add(
        AddConsumerEvent(
            params: AddConsumerParams(
                consumer: consumer, profileImage: profileImage)),
      );
      Navigator.pop(context);
    } catch (e) {
      log('Error creating ConsumerModel: $e');
    }
  }

  void _showGenderPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text('Select Gender',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.male_rounded),
                title: Text('Male',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () {
                  _genderController.text = 'Male';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.female_rounded),
                title: Text('Female',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () {
                  _genderController.text = 'Female';
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_outline_outlined),
                title: Text('Other',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () {
                  _genderController.text = 'Other';
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
