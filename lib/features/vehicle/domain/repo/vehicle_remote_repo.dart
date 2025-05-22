import 'package:gas/features/vehicle/data/models/fuel_model.dart';
import 'package:gas/features/vehicle/data/models/repair_model.dart';
import 'package:gas/features/vehicle/data/models/vehicle_model.dart';

abstract class VehicleRemoteRepo {
  Future<List<VehicleModel>> getVehicles({required String businessID});
  Future<List<FuelModel>> getFuels({required String businessID});
  Future<List<RepairModel>> getRepairs({required String businessID});
  Future<bool> setVehicles({required VehicleModel vehicle});
  Future<bool> setFuels({required FuelModel fuel});
  Future<bool> setRepairs({required RepairModel repair});
}
