import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:developer' as dev;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/main.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  ];
}

String? validationForEmpty({required String? value, String label = ""}) {
  if (value == null || value.isEmpty) {
    return "Please enter the $label";
  }
  return null;
}

class CommonTextField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final bool isEnabled;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final bool underlineBorderedTextField;

  const CommonTextField({
    required this.labelText,
    this.hintText,
    required this.controller,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.isEnabled = true,
    this.keyboardType = TextInputType.text,
    super.key,
    this.suffixIcon,
    this.onTap,
    this.validator,
    this.underlineBorderedTextField = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          enabled: isEnabled && onTap == null,
          keyboardType: keyboardType,
          validator: validator,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            border: underlineBorderedTextField
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.5),
                    ),
                  ),
            enabledBorder: underlineBorderedTextField
                ? const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(.5),
                    ),
                  ),
            focusedBorder: underlineBorderedTextField
                ? UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
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
              ? CircularProgressIndicator(
                  color: Colors.white, strokeWidth: 2.sp)
              : Icon(icon, color: Colors.white)),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text('Select Image Source',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (networkImage != null || profileImage != null) ...[
              ListTile(
                leading: const Icon(Iconsax.eye),
                title: Text('See the image',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  if (networkImage != null || profileImage != null) {
                    await openPopUp(
                        context: context,
                        networkImage: networkImage,
                        profileImage: profileImage);
                  }
                },
              ),
            ],
            ListTile(
              leading: const Icon(Iconsax.camera),
              title: Text('Take a Photo',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await pickAndCompressImage(
                  context: context,
                  onImageSelected: onImageSelected,
                  source: ImageSource.camera,
                );
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.gallery),
              title: Text('Choose from Gallery',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(fontWeight: FontWeight.bold)),
              onTap: () async {
                Navigator.pop(context); // Close the dialog
                await pickAndCompressImage(
                  context: context,
                  onImageSelected: onImageSelected,
                  source: ImageSource.gallery,
                );
              },
            ),
          ],
        ),
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
                profileImage: profileImage);
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
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.4), // Slightly increased opacity
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(75),
                            bottomRight: Radius.circular(75),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Upload\nImage',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
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
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

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
    double a = sin(dLat / 2) * sin(dLat / 2) +
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
        point1.latitude, point1.longitude, point2.latitude, point2.longitude);
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
      '⚠️ Provide either (point1 & point2) or a list of points.');
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
  IconData icon = Iconsax.close_circle5,
  Color iconColor = Colors.red,
  required String text,
}) {
  final BuildContext? buildContext = context ?? navigatorKey.currentContext;

  if (buildContext == null) {
    debugPrint("❌ ERROR: No valid context found for Snackbar!");
    return;
  }

  ScaffoldMessenger.of(buildContext).clearSnackBars();
  ScaffoldMessenger.of(buildContext).showSnackBar(
    SnackBar(
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.r, color: iconColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: Theme.of(buildContext)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ],
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
  required LatLng consumerLatLng,
  required LatLng providerLatLng,
  String? lastFetchedRoute,
}) async {
  final String osrmUrl =
      "https://router.project-osrm.org/route/v1/driving/${providerLatLng.longitude},${providerLatLng.latitude};${consumerLatLng.longitude},${consumerLatLng.latitude}?overview=full&geometries=geojson";

  try {
    final response = await http.get(Uri.parse(osrmUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newRoute =
          json.encode(data["routes"][0]["geometry"]["coordinates"]);

      if (newRoute == lastFetchedRoute) {
        return [];
      }

      final List<dynamic> coordinates =
          data["routes"][0]["geometry"]["coordinates"];
      return coordinates
          .map<LatLng>(
              (coord) => LatLng(coord[1] as double, coord[0] as double))
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

call({required BuildContext context, required String phoneNumber}) async {
  final Uri phoneUri = Uri.parse("tel:$phoneNumber");

  if (await canLaunchUrl(phoneUri) && (phoneNumber.isNotEmpty)) {
    await launchUrl(phoneUri);
  } else {
    showSnack(
        // ignore: use_build_context_synchronously
        context: context,
        text: "Can't make a call now, Please try again later");
  }
}
