// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<UserLocationModel?> pickAddress({
  required BuildContext context,
  required UserLocationModel initialAddress,
}) async {
  final pincodeController = TextEditingController(text: initialAddress.pincode);
  List<String> areas = [];
  String? selectedArea;
  String city = '';
  String state = '';
  bool loading = false;
  String? error;

  final _address = await openBottomSheet<UserLocationModel>(
    child: SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Address",
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );

  // final result = await showDialog<UserLocationModel>(
  //   context: context,

  //   builder: (context) {
  //     return StatefulBuilder(
  //       builder: (context, setState) {
  //         Future<void> fetchAddress(String pincode) async {
  //           setState(() {
  //             loading = true;
  //             error = null;
  //             areas = [];
  //             selectedArea = null;
  //             city = '';
  //             state = '';
  //           });

  //           final uri = Uri.parse(
  //             'https://api.postalpincode.in/pincode/$pincode',
  //           );
  //           final response = await http.get(uri);

  //           setState(() {
  //             loading = false;
  //           });

  //           if (response.statusCode == 200) {
  //             final data = jsonDecode(response.body);
  //             final postOffices = data[0]['PostOffice'];
  //             if (postOffices != null && postOffices is List) {
  //               setState(() {
  //                 areas = postOffices
  //                     .map<String>((e) => e['Name'] as String)
  //                     .toList();
  //                 city = postOffices[0]['District'];
  //                 state = postOffices[0]['State'];
  //               });
  //             } else {
  //               setState(() {
  //                 error = 'No areas found for this pincode.';
  //               });
  //             }
  //           } else {
  //             setState(() {
  //               error = 'Failed to fetch address.';
  //             });
  //           }
  //         }

  //         return AlertDialog(
  //           title: Text('Pick Address'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 TextField(
  //                   controller: pincodeController,
  //                   keyboardType: TextInputType.number,
  //                   decoration: InputDecoration(
  //                     labelText: 'Pincode',
  //                     suffixIcon: IconButton(
  //                       icon: Icon(Icons.search),
  //                       onPressed: () =>
  //                           fetchAddress(pincodeController.text.trim()),
  //                     ),
  //                   ),
  //                 ),
  //                 if (loading)
  //                   Padding(
  //                     padding: EdgeInsets.all(8),
  //                     child: CircularProgressIndicator(),
  //                   ),
  //                 if (error != null)
  //                   Padding(
  //                     padding: EdgeInsets.all(8),
  //                     child: Text(error!, style: TextStyle(color: Colors.red)),
  //                   ),
  //                 if (areas.isNotEmpty)
  //                   DropdownButton<String>(
  //                     value: selectedArea,
  //                     hint: Text('Select Area'),
  //                     isExpanded: true,
  //                     items: areas
  //                         .map(
  //                           (area) => DropdownMenuItem(
  //                             value: area,
  //                             child: Text(area),
  //                           ),
  //                         )
  //                         .toList(),
  //                     onChanged: (value) =>
  //                         setState(() => selectedArea = value),
  //                   ),
  //                 if (city.isNotEmpty) Text('City: $city'),
  //                 if (state.isNotEmpty) Text('State: $state'),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: Text('Cancel'),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (selectedArea != null &&
  //                     city.isNotEmpty &&
  //                     state.isNotEmpty) {
  //                   Navigator.pop(
  //                     context,
  //                     UserLocationModel(
  //                       area: selectedArea!,
  //                       city: city,
  //                       state: state,
  //                       pincode: pincodeController.text.trim(),
  //                       country: 'India',
  //                       continent: 'Asia',
  //                       locality: selectedArea!,
  //                       geopoint: GeoPoint(
  //                         initialAddress.geopoint.latitude,
  //                         initialAddress.geopoint.longitude,
  //                       ),
  //                     ),
  //                   );
  //                 }
  //               },
  //               child: Text('Save'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   },
  // );
  return _address;
}

String timeAgo(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) {
    final secs = diff.inSeconds;
    return '$secs sec${secs == 1 ? '' : 's'}';
  } else if (diff.inMinutes < 60) {
    final mins = diff.inMinutes;
    return '$mins min${mins == 1 ? '' : 's'}';
  } else if (diff.inHours < 24) {
    final hours = diff.inHours;
    return '$hours hour${hours == 1 ? '' : 's'}';
  } else if (diff.inDays < 30) {
    final days = diff.inDays;
    return '$days day${days == 1 ? '' : 's'}';
  } else if (diff.inDays < 365) {
    final months = diff.inDays ~/ 30;
    return '$months month${months == 1 ? '' : 's'}';
  } else {
    final years = diff.inDays ~/ 365;
    return '$years year${years == 1 ? '' : 's'}';
  }
}

List<Widget> get commonEmpty {
  return [
    SizedBox(height: 200.h),
    CachedNetworkImage(
      height: 50.h,
      width: 50.h,
      fit: BoxFit.cover,
      imageUrl: "https://cdn-icons-png.flaticon.com/128/7486/7486760.png",
    ),
    SizedBox(height: 30.h),
    const Text(
      "It's quite in here...",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 10.h),
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Text(
        "You can explore our services, our trustworthy and professional useful features to get the best user experience.",
        style: Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!
            .copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ),
  ];
}

List<Widget> get commonEmptySmall {
  return [
    CachedNetworkImage(
      height: 50.h,
      width: 50.h,
      fit: BoxFit.cover,
      imageUrl: "https://cdn-icons-png.flaticon.com/128/7486/7486760.png",
    ),
    SizedBox(height: 10.h),
    Text(
      "It's quite in here...",
      style: Theme.of(
        navigatorKey.currentContext!,
      ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
    ),
  ];
}

String? validationForEmpty({required String? value, String label = ""}) {
  if (value == null || value.isEmpty) {
    return "Please enter the $label";
  }
  return null;
}

class CommonTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? margin;
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool isEnabled;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final String? Function(String?)? validator;

  const CommonTextFormField({
    super.key,
    this.margin,
    required this.labelText,
    this.hintText,
    required this.controller,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.validator,
  });

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isEmpty = widget.controller.text.isEmpty;

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: GestureDetector(
        onTap:
            widget.onTap ??
            () => FocusScope.of(context).requestFocus(_focusNode),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.labelText,
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: widget.controller,
                              focusNode: _focusNode,
                              enabled: widget.isEnabled && widget.onTap == null,
                              maxLines: widget.maxLines,
                              minLines: widget.minLines,
                              maxLength: widget.maxLength,
                              keyboardType: widget.keyboardType,
                              validator: widget.validator,
                              onTap: widget.onTap,
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                isCollapsed: true,
                                hintText: isEmpty ? widget.hintText : null,
                                hintStyle: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                  right: widget.suffixIcon != null ? 40.w : 0,
                                ),
                              ),
                            ),
                          ),
                          if (widget.suffixIcon != null) ...[
                            SizedBox(width: 20.w),
                            Icon(widget.suffixIcon, size: 20.r),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<DateTime?> pickDate({
  DateTime? initialDate,
  DateTime? lastDate,
  DateTime? firstDate,
}) async {
  final now = DateTime.now();
  return await showDatePicker(
    context: navigatorKey.currentContext!,
    initialDate: initialDate ?? now,
    firstDate: firstDate ?? DateTime(1900),
    lastDate: lastDate ?? now,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          datePickerTheme: DatePickerThemeData(
            backgroundColor: Colors.white,
            headerHeadlineStyle: Theme.of(
              context,
            ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            headerHelpStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            dividerColor: Colors.grey.withOpacity(.2),
            dayStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            weekdayStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            yearStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            rangePickerHeaderHeadlineStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            rangePickerHeaderHelpStyle: Theme.of(
              context,
            ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            confirmButtonStyle: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.r),
                side: BorderSide(color: Colors.grey.withOpacity(.2)),
              ),
            ),
            cancelButtonStyle: ElevatedButton.styleFrom(
              textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
        ),
        child: child!,
      );
    },
  );
}

class CommonFloatingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final IconData icon;
  final bool loading;
  const CommonFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: const CircleBorder(),
        foregroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor.withOpacity(1),
        child: loading
            ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2.sp)
            : Icon(icon, color: Colors.white),
      ),
    );
  }
}

class CommonImagePicker extends StatelessWidget {
  final File? profileImage;
  final String? networkImage;
  final Function(File) onImageSelected;

  const CommonImagePicker({
    super.key,
    this.profileImage,
    required this.onImageSelected,
    this.networkImage,
  });

  Future<void> pickAndCompressImage({
    required BuildContext context,
    required Function(File) onImageSelected,
    required ImageSource source,
  }) async {
    final picker = ImagePicker();
    final XFile? xfile = await picker.pickImage(source: source);

    if (xfile != null) {
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        xfile.path,
        "${xfile.path}_compressed.jpg",
        quality: 60,
      );

      if (compressedImage != null) {
        onImageSelected(File(compressedImage.path));
      }
    }
  }

  Future<void> showImageSourceSelectionDialog({
    required BuildContext context,
    required Function(File) onImageSelected,
  }) async {
    openBottomSheet(
      minChildSize: networkImage != null || profileImage != null ? 0.28 : 0.21,
      initialChildSize: networkImage != null || profileImage != null
          ? 0.28
          : 0.21,
      child: Column(
        children: [
          if (networkImage != null || profileImage != null) ...[
            bottomSheetTile(
              context: context,
              icon: Iconsax.camera,
              title: "See the Image",
              subtitle: "View the current profile picture",
              onTap: () async {
                Navigator.pop(context);
                if (networkImage != null || profileImage != null) {
                  await openPopUp(
                    context: context,
                    networkImage: networkImage,
                    profileImage: profileImage,
                  );
                }
              },
            ),
          ],
          bottomSheetTile(
            context: context,
            icon: Iconsax.camera,
            title: "Take a Photo",
            subtitle: "Capture a new photo using the camera",
            onTap: () async {
              Navigator.pop(context);
              await pickAndCompressImage(
                context: context,
                onImageSelected: onImageSelected,
                source: ImageSource.camera,
              );
            },
          ),
          bottomSheetTile(
            context: context,
            icon: Iconsax.gallery,
            title: "Choose from Gallery",
            subtitle: "Select an existing photo from the gallery",
            onTap: () async {
              Navigator.pop(context);
              await pickAndCompressImage(
                context: context,
                onImageSelected: onImageSelected,
                source: ImageSource.gallery,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          showImageSourceSelectionDialog(
            context: context,
            onImageSelected: onImageSelected,
          );
        },
        onLongPress: () {
          if (networkImage != null || profileImage != null) {
            openPopUp(
              context: context,
              networkImage: networkImage,
              profileImage: profileImage,
            );
          }
        },
        child: ClipOval(
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (networkImage != null) ...[
                CachedNetworkImage(
                  imageUrl: networkImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
              if (profileImage != null) ...[
                Image.file(
                  profileImage!,
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ],
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  shape: BoxShape.circle,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(75),
                      bottomRight: Radius.circular(75),
                    ),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(
                            0.4,
                          ), // Slightly increased opacity
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(75),
                            bottomRight: Radius.circular(75),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Upload\nImage',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> openPopUp({
  required BuildContext context,
  required String? networkImage,
  required File? profileImage,
}) async {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Stack(
          children: [
            // Blur background
            BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                // color: Colors.black.withOpacity(0.2),
              ),
            ),
            // Circular image
            if (networkImage != null) ...[
              Center(
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: networkImage,
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.black.withOpacity(.1),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ] else if (profileImage != null) ...[
              Center(
                child: ClipOval(
                  child: Image.file(
                    profileImage,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    },
  );
}

Future<UserLocationModel> getUserLocationFromPosition(Position position) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      String continent = _getContinentFromCountry(place.country ?? "");

      return UserLocationModel(
        city: place.subAdministrativeArea ?? "",
        area: place.locality ?? "",
        pincode: place.postalCode ?? "",
        locality: place.thoroughfare ?? "",
        state: place.administrativeArea ?? "",
        country: place.country ?? "",
        continent: continent,
        geopoint: GeoPoint(position.latitude, position.longitude),
        updateTD: Timestamp.now(),
      );
    } else {
      throw Exception("No placemarks found");
    }
  } catch (e) {
    dev.log("ERROR_GETTING_LOCATION_DATA: $e");
    rethrow;
  }
}

// 🔹 Helper function to get continent based on country
String _getContinentFromCountry(String country) {
  const Map<String, String> countryToContinent = {
    "India": "Asia",
    "United States": "North America",
    "Canada": "North America",
    "Brazil": "South America",
    "United Kingdom": "Europe",
    "Germany": "Europe",
    "Australia": "Australia",
    "South Africa": "Africa",
    "Japan": "Asia",
  };

  return countryToContinent[country] ?? "Unknown";
}

/// 🌍 Calculates distance between points using the Haversine formula.
double calculateDistance({
  LatLng? point1,
  LatLng? point2,
  List<LatLng>? points,
}) {
  const double R = 6371; // 🌎 Earth radius in km

  double degToRad(double deg) => deg * (pi / 180);

  double haversine(double lat1, double lon1, double lat2, double lon2) {
    double dLat = degToRad(lat2 - lat1);
    double dLon = degToRad(lon2 - lon1);
    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(lat1)) *
            cos(degToRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  /// 📍 Distance between two points
  if (point1 != null && point2 != null) {
    return haversine(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  /// 🛣️ Total distance for multiple points
  if (points != null && points.length > 1) {
    double totalDistance = 0.0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += haversine(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }
    return totalDistance;
  }

  throw ArgumentError(
    '⚠️ Provide either (point1 & point2) or a list of points.',
  );
}

String mapImage({required List<GeoPoint> points}) {
  if (points.isEmpty) {
    throw ArgumentError("Points list cannot be empty");
  }

  // If only one point, show a single marker
  if (points.length == 1) {
    return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/"
        "pin-l+000000(${points.first.longitude},${points.first.latitude})"
        "/auto/800x800?padding=120&access_token=pk.eyJ1Ijoic2F1cmFiaC10ZWNoMjYwMyIsImEiOiJjbDk4b2FwemQwcTU4M3BtdjYzNHNkc3d1In0.K3wmWSc7atSi-EqkGtKbwg";
  }

  // Start (black) and End (green) markers
  String markers =
      "pin-l+000000(${points.first.longitude},${points.first.latitude}),"
      "pin-l+006600(${points.last.longitude},${points.last.latitude})";

  // Generate polyline path
  String path = points.map((p) => "${p.longitude},${p.latitude}").join(";");

  return "https://api.mapbox.com/styles/v1/mapbox/streets-v11/static/"
      "$markers,"
      "path-5+ff0000-0.8($path)"
      "/auto/800x800?padding=120&access_token=pk.eyJ1Ijoic2F1cmFiaC10ZWNoMjYwMyIsImEiOiJjbDk4b2FwemQwcTU4M3BtdjYzNHNkc3d1In0.K3wmWSc7atSi-EqkGtKbwg";
}

void showSnack({
  BuildContext? context,
  Color backgroundColor = Colors.green,
  required String text,
  bool sticky = false,
}) {
  final BuildContext? buildContext = context ?? navigatorKey.currentContext;

  if (buildContext == null) {
    debugPrint("❌ ERROR: No valid context found for Snackbar!");
    return;
  }

  ScaffoldMessenger.of(buildContext).clearSnackBars();
  ScaffoldMessenger.of(buildContext).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      padding: EdgeInsets.zero,
      duration: sticky ? const Duration(days: 365) : const Duration(seconds: 3),
      content: Container(
        height: 30.h,
        alignment: Alignment.center,
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(buildContext).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );
}

void clearAllSnack({BuildContext? context}) {
  final BuildContext? buildContext = context ?? navigatorKey.currentContext;

  if (buildContext == null) {
    debugPrint("❌ ERROR: No valid context found to clear SnackBars!");
    return;
  }

  ScaffoldMessenger.of(buildContext).clearSnackBars();
}

Future<List<LatLng>> fetchRoute({
  required LatLng firstLatLng,
  required LatLng secondLatLng,
  String? lastFetchedRoute,
}) async {
  final String osrmUrl =
      "https://router.project-osrm.org/route/v1/driving/${secondLatLng.longitude},${secondLatLng.latitude};${firstLatLng.longitude},${firstLatLng.latitude}?overview=full&geometries=geojson";

  try {
    final response = await http.get(Uri.parse(osrmUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newRoute = json.encode(
        data["routes"][0]["geometry"]["coordinates"],
      );

      if (newRoute == lastFetchedRoute) {
        return [];
      }

      final List<dynamic> coordinates =
          data["routes"][0]["geometry"]["coordinates"];
      return coordinates
          .map<LatLng>(
            (coord) => LatLng(coord[1] as double, coord[0] as double),
          )
          .toList();
    } else {
      debugPrint("Failed to fetch route: ${response.statusCode}");
      return [];
    }
  } catch (e) {
    debugPrint("Error fetching route: $e");
    return [];
  }
}

Future<void> call({
  required BuildContext context,
  required String phoneNumber,
}) async {
  final Uri phoneUri = Uri.parse("tel:$phoneNumber");

  if (await canLaunchUrl(phoneUri) && (phoneNumber.isNotEmpty)) {
    await launchUrl(phoneUri);
  } else {
    showSnack(
      context: context,
      text: "Can't make a call now, Please try again later",
    );
  }
}

Future<T?> openBottomSheet<T>({
  Widget child = const SizedBox(),
  double minChildSize = 0.25,
  double initialChildSize = 0.5,
  double maxChildSize = 0.9,
}) async {
  final BuildContext context = navigatorKey.currentContext!;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8.h),
                  Container(
                    height: 4.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: child,
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
  return null;
}

InkWell bottomSheetTile({
  required BuildContext context,
  required IconData icon,
  IconData? actionIcon,
  required String title,
  required String subtitle,
  required void Function() onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
      child: Row(
        children: [
          Icon(icon),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          if (actionIcon != null) ...[SizedBox(width: 20.w), Icon(actionIcon)],
        ],
      ),
    ),
  );
}

void openStatusBottomSheet({
  required BuildContext context,
  double minChildSize = 0.1,
  double initialChildSize = 0.15,
  double maxChildSize = 0.9,
  required String title,
  String subtitle = "",
  IconData icon = CupertinoIcons.check_mark,
  Color color = AppColors.green600,
  String primaryButtonText = "",
  String secondaryButtonText = "",
  bool loading = false,
  required Function() onPrimaryTap,
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: !loading,
    isScrollControlled: true,
    enableDrag: !loading,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          if (loading) {
            return false;
          } else {
            return true;
          }
        },
        child: DraggableScrollableSheet(
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: AbsorbPointer(
                absorbing: loading,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 8.h),
                      Container(
                        height: 4.h,
                        width: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                  ),
                                  child: loading
                                      ? SizedBox(
                                          height: 15.r,
                                          width: 15.r,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Icon(
                                          icon,
                                          color: Colors.white,
                                          size: 15.r,
                                        ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  title,
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
  );
}

// Future<bool> screenshotAndSaveWidget({
//   required Widget widget,
//   required BuildContext context,
//   String? filePrefix,
//   double pixelRatio = 3.0,
// }) async {
//   try {
//     final boundaryKey = GlobalKey();

//     final overlayEntry = OverlayEntry(
//       builder: (_) => Material(
//         type: MaterialType.transparency,
//         child: Center(
//           child: RepaintBoundary(
//             key: boundaryKey,
//             child: widget,
//           ),
//         ),
//       ),
//     );

//     Overlay.of(context).insert(overlayEntry);

//     await Future.delayed(const Duration(milliseconds: 100)); // let it render

//     final boundary = boundaryKey.currentContext?.findRenderObject()
//         as RenderRepaintBoundary?;
//     if (boundary == null) {
//       overlayEntry.remove();
//       return false;
//     }

//     final image = await boundary.toImage(pixelRatio: pixelRatio);
//     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     if (byteData == null) {
//       overlayEntry.remove();
//       return false;
//     }

//     final pngBytes = byteData.buffer.asUint8List();

//     final fileName =
//         '${filePrefix ?? "widget"}_${DateTime.now().millisecondsSinceEpoch}';
//     final result = await ImageGallerySaver.saveImage(pngBytes,
//         name: fileName, quality: 100);

//     overlayEntry.remove();
//     return result['isSuccess'] == true;
//   } catch (e) {
//     debugPrint('❌ Error capturing widget: $e');
//     return false;
//   }
// }

Future<String> uploadImage({
  required String id,
  required File image,
  required String storageChild,
}) async {
  try {
    final ref = FirebaseStorage.instance
        .ref()
        .child(storageChild)
        .child(id)
        .child("${DateTime.now().millisecondsSinceEpoch}.jpg");

    final uploadTask = await ref.putFile(image);
    final imageUrl = await uploadTask.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    throw Exception("Failed to upload image: $e");
  }
}
