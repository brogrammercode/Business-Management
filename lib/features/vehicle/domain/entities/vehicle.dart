import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String logo;
  final String regOdometer;
  final String regNo;
  final String vehicleFrontURL;
  final String vehicleBackURL;
  final String vehicleRCURL;
  final String vehicleInsuranceURL;
  final String orgID;
  final Timestamp registrationTD;
  final String registeredBy;
  final bool deactivate;

  const Vehicle({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.logo,
    required this.regOdometer,
    required this.regNo,
    required this.vehicleFrontURL,
    required this.vehicleBackURL,
    required this.vehicleRCURL,
    required this.vehicleInsuranceURL,
    required this.orgID,
    required this.registrationTD,
    required this.registeredBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        model,
        logo,
        regOdometer,
        regNo,
        vehicleFrontURL,
        vehicleBackURL,
        vehicleRCURL,
        vehicleInsuranceURL,
        orgID,
        registrationTD,
        registeredBy,
        deactivate,
      ];
}
