import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/config/theme/colors.dart';
import 'package:gas/core/utils/common.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/home/domain/repo/home_repo.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRemoteRepo _homeRemoteRepo;
  StreamSubscription? _isLocationEnabledSubscription;

  HomeCubit({required HomeRemoteRepo homeRemoteRepo})
      : _homeRemoteRepo = homeRemoteRepo,
        super(const HomeState()) {
    //
  }

  Future<void> updatePosition({required Position position}) async {
    emit(state.copyWith(position: position));
  }

  Timer? _locationTimer;

  void initializeIsLocationEnabledListener() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission();
    }
    final bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    emit(state.copyWith(locationEnabled: isLocationEnabled));

    if (isLocationEnabled) {
      _startLocationLogging();
    }

    _isLocationEnabledSubscription =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      final bool isNowEnabled = status == ServiceStatus.enabled;
      emit(state.copyWith(locationEnabled: isNowEnabled));

      if (isNowEnabled) {
        _startLocationLogging();
      } else {
        _locationTimer?.cancel();
        _locationTimer = null;
      }
    });
  }

  Future<void> _startLocationLogging() async {
    await _getLocation();
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(minutes: 5), (timer) async {
      await _getLocation();
    });
  }

  Future<void> _getLocation() async {
    try {
      emit(state.copyWith(getLocationStatus: StateStatus.loading));
      final position = await Geolocator.getCurrentPosition();
      updatePosition(position: position);
      final lastLocation = await getUserLocationFromPosition(position);
      emit(state.copyWith(
          lastLocation: [lastLocation],
          getLocationStatus: StateStatus.success));
      await updateLocationToDatabase(location: lastLocation);
      if (state.lastLocation.isNotEmpty) {
        log("${state.lastLocation} at ---${state.lastLocation.first.geopoint.latitude}, ${state.lastLocation.first.geopoint.longitude}--- updated on ${DateFormat().format(state.lastLocation.first.updateTD.toDate())}");
      }
    } catch (e) {
      log("GET_LOCATION_STATUS_ERROR: $e");
      emit(state.copyWith(getLocationStatus: StateStatus.failure));
    }
  }

  Future<void> updateLocationToDatabase(
      {required UserLocationModel location}) async {
    try {
      emit(state.copyWith(updateLocationToDatabaseStatus: StateStatus.loading));

      showSnack(
          text: "Location Updating ...",
          backgroundColor: AppColors.blue600);
      final success =
          await _homeRemoteRepo.updateLocationToDatabase(location: location);
      if (success) {
        emit(state.copyWith(
            updateLocationToDatabaseStatus: StateStatus.success));
        showSnack(
            text: "Location Updated",
            backgroundColor: AppColors.green600);
      } else {
        emit(state.copyWith(
            updateLocationToDatabaseStatus: StateStatus.failure,
            error: const CommonError(consoleMessage: "Something went wrong")));
        log("Something went wrong");
      }
    } catch (e) {
      emit(state.copyWith(
          updateLocationToDatabaseStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
      log(e.toString());
    }
  }

  Future<void> getLocationFromDatabase() async {
    try {
      emit(state.copyWith(getLocationFromDatabaseStatus: StateStatus.loading));
      final location = await _homeRemoteRepo.getLocationFromDatabase();
      emit(state.copyWith(
          position: location != null && location.geopoint.latitude != 0
              ? Position(
                  longitude: location.geopoint.longitude,
                  latitude: location.geopoint.latitude,
                  timestamp: Timestamp.now().toDate(),
                  accuracy: 100,
                  altitude: 100,
                  altitudeAccuracy: 100,
                  heading: 100,
                  headingAccuracy: 100,
                  speed: 100,
                  speedAccuracy: 100)
              : null,
          lastLocation: location != null ? [location] : [],
          getLocationFromDatabaseStatus: StateStatus.success));
    } catch (e) {
      emit(state.copyWith(
          getLocationFromDatabaseStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString())));
    }
  }

  @override
  Future<void> close() {
    _isLocationEnabledSubscription?.cancel();
    _locationTimer?.cancel();
    return super.close();
  }
}
