// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/home/presentation/cubit/home_cubit.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  LatLng _pickedLocation = const LatLng(25.5941, 85.1376); // Default: Patna
  UserLocationModel? locationModel;
  List<UserLocationModel> searchResults = [];
  final mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final DraggableScrollableController _draggableController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocationAndUpdatePickedLocation();
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _draggableController.animateTo(
          0.9,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _draggableController.dispose();
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
      top: 10.h,
      child: IconButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        icon: Icon(Iconsax.arrow_left, color: Colors.white),
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
        initialCenter: _pickedLocation,
        initialZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
          retinaMode: true,
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayer(markers: [_marker()]),
      ],
    );
  }

  Marker _marker() {
    return Marker(
      width: 250.w,
      height: 50.h,
      point: _pickedLocation,
      alignment: Alignment.topCenter,
      child: Container(
        width: 250.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black12.withOpacity(.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12.withOpacity(.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              SizedBox(width: 20.w),
              Expanded(
                child: Text(
                  "${locationModel?.area ?? ""}, "
                  "${locationModel?.city ?? ""}, "
                  "${locationModel?.state ?? ""}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 20.w),
              IconButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                onPressed: () => Navigator.pop(context, locationModel),
                icon: Icon(Iconsax.arrow_right_1, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  DraggableScrollableSheet _search() {
    return DraggableScrollableSheet(
      controller: _draggableController,
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
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 5.h,
                  width: 70.w,
                  margin: EdgeInsets.only(bottom: 20.h, top: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(.3),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                TextFormField(
                  focusNode: _focusNode,
                  controller: _searchController,
                  onChanged: _onSearch,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30.w),
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.1),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(.3),
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    suffixIcon: Container(
                      margin: EdgeInsets.all(3.w),
                      child: IconButton(
                        onPressed: () {
                          _onSearch(_searchController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        icon: Icon(
                          Iconsax.search_normal_1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                // Search results:
                if (searchResults.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    itemBuilder: (_, index) {
                      final loc = searchResults[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          "${loc.area}, ${loc.city}, ${loc.state}",
                          style: Theme.of(context).textTheme.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          final newPoint = LatLng(
                            loc.geopoint.latitude,
                            loc.geopoint.longitude,
                          );
                          setState(() {
                            _pickedLocation = newPoint;
                            locationModel = loc;
                            mapController.move(newPoint, 15);
                            searchResults.clear();
                          });
                          FocusScope.of(context).unfocus();
                          _draggableController.animateTo(
                            0.15,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _getCurrentLocationAndUpdatePickedLocation() async {
    final currentPosition = context.read<HomeCubit>().state.position;
    if (currentPosition != null) {
      final currentLocation = LatLng(
        currentPosition.latitude,
        currentPosition.longitude,
      );
      final address = await getUserLocationFromPosition(currentPosition);
      setState(() {
        _pickedLocation = currentLocation;
        locationModel = address;
        mapController.move(currentLocation, 15);
      });
    }
  }

  Future<void> _onSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    final results = await getLocationsFromQuery(query);
    setState(() {
      searchResults = results;
    });
  }

  Future<List<UserLocationModel>> getLocationsFromQuery(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url =
        'https://nominatim.openstreetmap.org/search?q=$encodedQuery&format=json&addressdetails=1&limit=5';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'User-Agent':
            'com.example.gas (harshsharma55115@gmail.com)', // Nominatim requires a valid user agent
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<UserLocationModel> results = [];

      for (final item in data) {
        final lat = double.parse(item['lat']);
        final lon = double.parse(item['lon']);
        final address = item['address'] ?? {};

        results.add(
          UserLocationModel(
            state: address['state'] ?? '',
            area:
                address['suburb'] ??
                address['neighbourhood'] ??
                address['quarter'] ??
                address['residential'] ??
                address['hamlet'] ??
                address['locality'] ??
                address['road'] ??
                '',
            city:
                address['city'] ?? address['town'] ?? address['village'] ?? '',
            pincode: address['postcode'] ?? '',
            country: address['country'] ?? '',
            geopoint: GeoPoint(lat, lon),
          ),
        );
      }

      return results;
    } else {
      throw Exception('Nominatim error: ${response.body}');
    }
  }

}
