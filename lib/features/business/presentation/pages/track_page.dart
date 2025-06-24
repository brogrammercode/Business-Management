// ignore_for_file: prefer_final_fields, deprecated_member_use, unused_element

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/features/business/presentation/cubit/business_cubit.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';

class TrackPage extends StatefulWidget {
  final String employeeID;
  const TrackPage({super.key, required this.employeeID});

  @override
  State<TrackPage> createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  MapController _mapController = MapController();
  List<LatLng> routeCoordinates = [];
  bool routeLoading = true;
  String? lastFetchedRoute;

  @override
  void initState() {
    super.initState();
    // _fetchRouteData();
  }

  Future<void> _fetchRouteData() async {
    final state = context.read<BusinessCubit>().state;
    final business = state.businesses.firstWhere(
      (e) => e.business.id == state.businessID,
    );
    final List<EmployeeModel> employees = [
      ...business.admins.map((e) => e.employee),
      ...business.owners.map((e) => e.employee),
      ...business.employees.map((e) => e.employee),
    ];
    final EmployeeModel target = employees.firstWhere(
      (e) => e.id == widget.employeeID,
    );

    final EmployeeModel me = employees.firstWhere(
      (e) => e.id == FirebaseAuth.instance.currentUser?.uid,
    );

    final newRoute = await fetchRoute(
      firstLatLng: LatLng(
        me.address.geopoint.latitude,
        me.address.geopoint.longitude,
      ),
      secondLatLng: LatLng(
        target.address.geopoint.latitude,
        target.address.geopoint.longitude,
      ),
    );

    setState(() {
      routeCoordinates = newRoute;
      routeLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessCubit, BusinessState>(
      listenWhen: (previous, current) =>
          previous.businesses != current.businesses,
      listener: (context, state) async {
        final business = state.businesses.firstWhere(
          (e) => e.business.id == state.businessID,
        );
        final List<EmployeeModel> employees = [
          ...business.admins.map((e) => e.employee),
          ...business.owners.map((e) => e.employee),
          ...business.employees.map((e) => e.employee),
        ];
        final EmployeeModel target = employees.firstWhere(
          (e) => e.id == widget.employeeID,
        );

        final EmployeeModel me = employees.firstWhere(
          (e) => e.id == FirebaseAuth.instance.currentUser?.uid,
        );

        final newRoute = await fetchRoute(
          firstLatLng: LatLng(
            me.address.geopoint.latitude,
            me.address.geopoint.longitude,
          ),
          secondLatLng: LatLng(
            target.address.geopoint.latitude,
            target.address.geopoint.longitude,
          ),
        );

        setState(() {
          routeCoordinates = newRoute;
          routeLoading = false;
        });
      },
      builder: (context, state) {
        try {
          final business = state.businesses.firstWhere(
            (e) => e.business.id == state.businessID,
          );
          final List<EmployeeModel> employees = [
            ...business.admins.map((e) => e.employee),
            ...business.owners.map((e) => e.employee),
            ...business.employees.map((e) => e.employee),
          ];
          final EmployeeModel target = employees.firstWhere(
            (e) => e.id == widget.employeeID,
          );

          final EmployeeModel me = employees.firstWhere(
            (e) => e.id == FirebaseAuth.instance.currentUser?.uid,
          );
          log("LOADING");

          return Scaffold(body: Stack(children: [_map(target, me)]));
        } catch (e) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(60.w),
                child: Text(
                  e.toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  FlutterMap _map(EmployeeModel target, EmployeeModel me) {
    final LatLng targetLatLng = LatLng(
      target.address.geopoint.latitude,
      target.address.geopoint.longitude,
    );

    final LatLng meLatLng = LatLng(
      me.address.geopoint.latitude,
      me.address.geopoint.longitude,
    );

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCameraFit: CameraFit.bounds(
          bounds: LatLngBounds.fromPoints([targetLatLng, meLatLng]),
          padding: EdgeInsets.all(50.r),
        ),
      ),
      children: [
        TileLayer(
          urlTemplate:
              "https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=4796c8bcd90d4d4aa12b29a5d7bbcf17",
          userAgentPackageName: "com.example.gas",
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: routeCoordinates,
              color: Colors.black.withOpacity(1),
              strokeWidth: 3.0,
            ),
          ],
        ),
        MarkerLayer(
          markers: [_marker(meLatLng, me), _marker(targetLatLng, target)],
        ),
      ],
    );
  }

  Marker _marker(LatLng location, EmployeeModel user) {
    return Marker(
      point: location,
      width: 70.r,
      height: 70.r,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20.r,
              spreadRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Icon(Iconsax.location5, color: Colors.white, size: 70.r),
            Positioned(
              top: 5.r,
              child: Container(
                height: 50.h,
                width: 50.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(4.w),
                child: CircleAvatar(
                  radius: 30.r,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(user.avatar),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
