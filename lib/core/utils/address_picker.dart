import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/location.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';

Future<UserLocationModel?> pickAddress({
  required BuildContext context,
  required UserLocationModel initialAddress,
}) async {
  final address = await openBottomSheet<UserLocationModel>(
    initialChildSize: 0.9,
    maxChildSize: 0.9,
    minChildSize: 0.9,
    child: SizedBox(
      width: double.infinity,
      child: AddressPicker(initialAddress: initialAddress),
    ),
  );
  return address;
}

Future<Map<String, dynamic>> fetchAddress(String pincode) async {
  final uri = Uri.parse('https://api.postalpincode.in/pincode/$pincode');
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final postOffices = data[0]['PostOffice'];
    if (postOffices != null && postOffices is List) {
      return {
        'postOffices': postOffices,
        'city': postOffices[0]['District'],
        'state': postOffices[0]['State'],
        'country': postOffices[0]['Country'],
        'pincode': pincode,
        'area': postOffices[0]['Name'],
        'locality': postOffices[0]['Name'],
        'geopoint': GeoPoint(
          double.parse(postOffices[0]['Latitude'] ?? '0'),
          double.parse(postOffices[0]['Longitude'] ?? '0'),
        ),
      };
    } else {
      return {'error': 'No post offices found for this pincode.'};
    }
  } else {
    return {
      'error': 'Failed to fetch address. Status code: ${response.statusCode}',
    };
  }
}

class AddressPicker extends StatefulWidget {
  final UserLocationModel initialAddress;
  const AddressPicker({super.key, required this.initialAddress});

  @override
  State<AddressPicker> createState() => _AddressPickerState();
}

class _AddressPickerState extends State<AddressPicker> {
  TextEditingController pincodeController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  List<String> areas = [];
  GeoPoint? geopoint;
  StateStatus status = StateStatus.initial;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Address",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: status == StateStatus.loading
                    ? null
                    : status == StateStatus.success
                    ? () {
                        Navigator.pop(
                          context,
                          UserLocationModel(
                            pincode: pincodeController.text.trim(),
                            area: areaController.text.trim(),
                            locality: areaController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            country: countryController.text.trim(),
                            continent: "Asia",
                            geopoint: geopoint ?? GeoPoint(0, 0),
                          ),
                        );
                      }
                    : () async {
                        setState(() {
                          status = StateStatus.loading;
                          error = null;
                        });

                        final result = await fetchAddress(
                          pincodeController.text.trim(),
                        );

                        if (!mounted) return;

                        if (result.containsKey('error')) {
                          setState(() {
                            status = StateStatus.failure;
                            error = result['error'];
                            areas.clear();
                          });
                        } else {
                          setState(() {
                            status = StateStatus.success;
                            areas = List<String>.from(
                              result['postOffices'].map(
                                (office) => office['Name'] as String,
                              ),
                            );
                            areaController.text = areas[0];
                            cityController.text = result['city'] ?? '';
                            stateController.text = result['state'] ?? '';
                            countryController.text = result['country'] ?? '';
                            geopoint = result['geopoint'] as GeoPoint?;
                          });

                          log("${geopoint?.latitude} ${geopoint?.longitude}");
                        }
                      },

                child: Text(
                  status == StateStatus.loading
                      ? "Searching ..."
                      : status == StateStatus.success
                      ? "Save"
                      : "Search",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        CommonTextFormField(
          labelText: "Postal Pin Code",
          controller: pincodeController,
          keyboardType: TextInputType.number,
        ),
        if (areas.isNotEmpty) ...[
          SizedBox(height: 10.h),
          CommonTextFormField(
            labelText: "Select Area",
            controller: areaController,
            suffixIcon: Iconsax.arrow_down_1,
            onTap: () async {
              final area = await openBottomSheet<String?>(
                child: Column(
                  children: areas
                      .map(
                        (e) => InkWell(
                          onTap: () {
                            Navigator.pop(context, e);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 15.h,
                            ),
                            child: Text(
                              e,
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
              if (area != null) {
                setState(() {
                  areaController.text = area;
                });
              }
            },
          ),
          SizedBox(height: 10.h),
          CommonTextFormField(labelText: "City", controller: cityController),
          SizedBox(height: 10.h),
          CommonTextFormField(labelText: "State", controller: stateController),
          SizedBox(height: 10.h),
          CommonTextFormField(
            labelText: "Country",
            controller: countryController,
          ),
          SizedBox(height: 40.h),
        ],
      ],
    );
  }
}
