import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String name; // field
  final String brand; // field
  final String model; // field
  final String regNo; // field
  final num regOdometer; // field
  final String logo; // image
  final String vehicleFrontURL; // image
  final String vehicleBackURL; // image
  final String vehicleRCURL; // image
  final String vehicleInsuranceURL; // image
  final String businessID;
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
    required this.businessID,
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
        businessID,
        registrationTD,
        registeredBy,
        deactivate,
      ];
}
