import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Fuel extends Equatable {
  final String id;
  final String vehicleID;
  final num volume; // field
  final num fees; // field
  final String location;
  final num odometer; // field
  final String businessID;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Fuel(
      {required this.id,
      required this.vehicleID,
      required this.volume,
      required this.fees,
      required this.location,
      required this.odometer,
      required this.businessID,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
      
  @override
  List<Object?> get props => [
        id,
        vehicleID,
        volume,
        fees,
        location,
        odometer,
        businessID,
        creationTD,
        createdBy,
        deactivate,
      ];
}
