import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/vehicle/domain/entities/vehicle.dart';

class VehicleModel extends Vehicle {
  const VehicleModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.model,
    required super.logo,
    required super.regOdometer,
    required super.regNo,
    required super.vehicleFrontURL,
    required super.vehicleBackURL,
    required super.vehicleRCURL,
    required super.vehicleInsuranceURL,
    required super.businessID,
    required super.registrationTD,
    required super.registeredBy,
    required super.deactivate,
  });

  // copyWith method
  VehicleModel copyWith({
    String? id,
    String? name,
    String? brand,
    String? model,
    String? logo,
    num? regOdometer,
    String? regNo,
    String? vehicleFrontURL,
    String? vehicleBackURL,
    String? vehicleRCURL,
    String? vehicleInsuranceURL,
    String? businessID,
    Timestamp? registrationTD,
    String? registeredBy,
    bool? deactivate,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      logo: logo ?? this.logo,
      regOdometer: regOdometer ?? this.regOdometer,
      regNo: regNo ?? this.regNo,
      vehicleFrontURL: vehicleFrontURL ?? this.vehicleFrontURL,
      vehicleBackURL: vehicleBackURL ?? this.vehicleBackURL,
      vehicleRCURL: vehicleRCURL ?? this.vehicleRCURL,
      vehicleInsuranceURL: vehicleInsuranceURL ?? this.vehicleInsuranceURL,
      businessID: businessID ?? this.businessID,
      registrationTD: registrationTD ?? this.registrationTD,
      registeredBy: registeredBy ?? this.registeredBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'logo': logo,
      'regOdometer': regOdometer,
      'regNo': regNo,
      'vehicleFrontURL': vehicleFrontURL,
      'vehicleBackURL': vehicleBackURL,
      'vehicleRCURL': vehicleRCURL,
      'vehicleInsuranceURL': vehicleInsuranceURL,
      'businessID': businessID,
      'registrationTD': registrationTD,
      'registeredBy': registeredBy,
      'deactivate': deactivate,
    };
  }

  // fromJson method
  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      brand: json['brand'] ?? "",
      model: json['model'] ?? "",
      logo: json['logo'] ?? "",
      regOdometer: json['regOdometer'] ?? 0,
      regNo: json['regNo'] ?? "",
      vehicleFrontURL: json['vehicleFrontURL'] ?? "",
      vehicleBackURL: json['vehicleBackURL'] ?? "",
      vehicleRCURL: json['vehicleRCURL'] ?? "",
      vehicleInsuranceURL: json['vehicleInsuranceURL'] ?? "",
      businessID: json['businessID'] ?? "",
      registrationTD: json['registrationTD'] ?? Timestamp.now(),
      registeredBy: json['registeredBy'] ?? "",
      deactivate: json['deactivate'] ?? false,
    );
  }

  // toString method
  @override
  String toString() {
    return '''
VehicleModel(
  id: $id,
  name: $name,
  brand: $brand,
  model: $model,
  logo: $logo,
  regOdometer: $regOdometer,
  regNo: $regNo,
  vehicleFrontURL: $vehicleFrontURL,
  vehicleBackURL: $vehicleBackURL,
  vehicleRCURL: $vehicleRCURL,
  vehicleInsuranceURL: $vehicleInsuranceURL,
  businessID: $businessID,
  registrationTD: $registrationTD,
  registeredBy: $registeredBy,
  deactivate: $deactivate,
)
    ''';
  }
}
