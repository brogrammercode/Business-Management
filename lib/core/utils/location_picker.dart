// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
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
        _pickedLocation.latitude, _pickedLocation.longitude);

    if (placemarks.isNotEmpty) {
      final placemark = placemarks.first;
      final address =
          "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}";
      Navigator.pop(context, address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Address')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search a location",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _moveToLocation(_searchController.text),
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                onTap: (tapPosition, point) {
                  setState(() {
                    _pickedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=4796c8bcd90d4d4aa12b29a5d7bbcf17",
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _pickedLocation,
                      child: const Icon(Icons.location_pin,
                          color: Colors.red, size: 36),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: _getAddressFromCoordinates,
              icon: const Icon(Icons.check),
              label: const Text("Use This Location"),
            ),
          )
        ],
      ),
    );
  }
}
