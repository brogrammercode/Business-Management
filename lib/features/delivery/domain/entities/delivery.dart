import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/core/utils/location.dart';

class Delivery extends Equatable {
  final String id;
  final String consumerID;
  final String employeeID;
  final String vehicleID;
  final String deliveryImage;
  final UserLocationModel deliveryLocation;
  final num fees;
  final num paid;
  final String paymentMethod;
  final Timestamp deliveryTD;
  final String businessID;
  final String status;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Delivery({
    required this.id,
    required this.consumerID,
    required this.employeeID,
    required this.vehicleID,
    required this.deliveryImage,
    required this.deliveryLocation,
    required this.fees,
    required this.paid,
    required this.paymentMethod,
    required this.deliveryTD,
    required this.status,
    required this.businessID,
    required this.creationTD,
    required this.createdBy,
    required this.deactivate,

  });

  @override
  List<Object?> get props => [
        id,
        consumerID,
        employeeID,
        vehicleID,
        deliveryImage,
        deliveryLocation,
        fees,
        paid,
        paymentMethod,
        deliveryTD,
        status,
        businessID,
        creationTD,
        createdBy,
        deactivate,
      ];
}
