// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng _pickedLocation = const LatLng(25.5941, 85.1376); // Default: Patna
  final mapController = MapController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _moveToLocation(String place) async {
    try {
      List<Location> locations = await locationFromAddress(place);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        setState(() {
          _pickedLocation = LatLng(loc.latitude, loc.longitude);
        });
        mapController.move(_pickedLocation, 14);
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _getAddressFromCoordinates() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _pickedLocation.latitude,
      _pickedLocation.longitude,
    );

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address =
          "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
      Navigator.pop(context, address);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(toolbarHeight: 0),
      body: Stack(children: [_map(), _back(context), _search()]),
    );
  }

  Positioned _back(BuildContext context) {
    return Positioned(
      left: 10.w,
      right: 10.w,
      top: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(),
            ),
            onPressed: () => Navigator.pop(context),
            icon: Icon(Iconsax.arrow_left),
          ),
          IconButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: CircleBorder(),
            ),
            onPressed: _saveLocation,
            icon: Icon(CupertinoIcons.check_mark),
          ),
        ],
      ),
    );
  }

  FlutterMap _map() {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        onTap: (tapPosition, point) {
          setState(() {
            _pickedLocation = point;
          });
        },

        initialZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          retinaMode: true,
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: [
           
          ],
        ),
      ],
    );
  }

  DraggableScrollableSheet _search() {
    return DraggableScrollableSheet(
      initialChildSize: 0.15,
      minChildSize: 0.15,
      maxChildSize: 0.8,
      builder: (context, scrollController) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  height: 5.h,
                  width: 70.w,
                  margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                  child: Center(
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _searchController,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 30.w),
                        filled: true,
                        fillColor: Colors.grey.withOpacity(.1),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(.3),
                          ),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(.3),
                          ),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        suffixIcon: Container(
                          margin: EdgeInsets.only(right: 7.w),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.search_normal_1,
                            color: Colors.white,
                            size: 18.r,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  void _saveLocation() {}
}
