import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Repair extends Equatable {
  final String id;
  final String vehicleID;
  final String type; // field
  final num fees; // field
  final String location;
  final String businessID;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Repair(
      {required this.id,
      required this.vehicleID,
      required this.type,
      required this.fees,
      required this.location,
      required this.businessID,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
  
  @override
  List<Object?> get props => [
        id,
        vehicleID,
        type,
        fees,
        location,
        businessID,
        creationTD,
        createdBy,
        deactivate,
      ];
}
