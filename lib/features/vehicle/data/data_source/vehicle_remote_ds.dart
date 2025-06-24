import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/vehicle/data/models/fuel_model.dart';
import 'package:gas/features/vehicle/data/models/repair_model.dart';
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';
import 'package:gas/features/vehicle/domain/repo/vehicle_remote_repo.dart';

class VehicleRemoteDs implements VehicleRemoteRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<FuelModel>> getFuels({required String businessID}) async {
    try {
      final snapshot = await _firestore
          .collection('fuels')
          .where('businessID', isEqualTo: businessID)
          .get();

      return snapshot.docs
          .map((doc) => FuelModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error fetching fuels: $e');
      throw Exception('Error fetching fuels: $e');
    }
  }

  @override
  Future<List<RepairModel>> getRepairs({required String businessID}) async {
    try {
      final snapshot = await _firestore
          .collection('repairs')
          .where('businessID', isEqualTo: businessID)
          .get();

      return snapshot.docs
          .map((doc) => RepairModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error fetching repairs: $e');
      throw Exception('Error fetching repairs: $e');
    }
  }

  @override
  Future<List<VehicleModel>> getVehicles({required String businessID}) async {
    try {
      final snapshot = await _firestore
          .collection('vehicles')
          .where('businessID', isEqualTo: businessID)
          .get();

      return snapshot.docs
          .map((doc) => VehicleModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      log('Error fetching vehicles: $e');
      throw Exception('Error fetching vehicles: $e');
    }
  }

  @override
  Future<bool> setFuels({required FuelModel fuel}) async {
    try {
      await _firestore.collection('fuels').doc(fuel.id).set(fuel.toJson());
      return true;
    } catch (e) {
      log('Error setting fuel: $e');
      throw Exception('Error setting fuel: $e');
    }
  }

  @override
  Future<bool> setRepairs({required RepairModel repair}) async {
    try {
      await _firestore
          .collection('repairs')
          .doc(repair.id)
          .set(repair.toJson());
      return true;
    } catch (e) {
      log('Error setting repair: $e');
      throw Exception('Error setting repair: $e');
    }
  }

  @override
  Future<bool> setVehicles({required VehicleModel vehicle}) async {
    try {
      await _firestore
          .collection('vehicles')
          .doc(vehicle.id)
          .set(vehicle.toJson());
      return true;
    } catch (e) {
      log('Error setting vehicle: $e');
      throw Exception('Error setting vehicle: $e');
    }
  }
}
