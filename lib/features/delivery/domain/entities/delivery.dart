import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Delivery extends Equatable {
  final String id;
  final String consumerID;
  final String deliveryAddress;
  final GeoPoint deliveryGeoPoint;
  final String deliveryPhone;
  final num fees;
  final num paid;
  final String status;
  final Timestamp deliveryTD;
  final String paymentMethod;
  final String employeeID;
  final String vehicleID;
  final String orgID;
  final Timestamp registrationTD;
  final String registeredBy;
  final bool deactivate;

  const Delivery({
    required this.id,
    required this.consumerID,
    required this.deliveryAddress,
    required this.deliveryGeoPoint,
    required this.deliveryPhone,
    required this.fees,
    required this.paid,
    required this.status,
    required this.deliveryTD,
    required this.paymentMethod,
    required this.employeeID,
    required this.vehicleID,
    required this.orgID,
    required this.registrationTD,
    required this.registeredBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        consumerID,
        deliveryAddress,
        deliveryGeoPoint,
        deliveryPhone,
        fees,
        paid,
        status,
        deliveryTD,
        paymentMethod,
        employeeID,
        vehicleID,
        orgID,
        registrationTD,
        registeredBy,
        deactivate
      ];
}
