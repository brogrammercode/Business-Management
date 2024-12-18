import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/delivery/domain/entities/delivery.dart';

class DeliveryModel extends Delivery {
  const DeliveryModel({
    required super.id,
    required super.consumerID,
    required super.deliveryAddress,
    required super.deliveryGeoPoint,
    required super.deliveryPhone,
    required super.fees,
    required super.paid,
    required super.status,
    required super.deliveryTD,
    required super.paymentMethod,
    required super.employeeID,
    required super.vehicleID,
    required super.orgID,
    required super.registrationTD,
    required super.registeredBy,
    required super.deactivate,
  });

  // copyWith method
  DeliveryModel copyWith({
    String? id,
    String? consumerID,
    String? deliveryAddress,
    GeoPoint? deliveryGeoPoint,
    String? deliveryPhone,
    num? fees,
    num? paid,
    String? status,
    Timestamp? deliveryTD,
    String? paymentMethod,
    String? employeeID,
    String? vehicleID,
    String? orgID,
    Timestamp? registrationTD,
    String? registeredBy,
    bool? deactivate,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      consumerID: consumerID ?? this.consumerID,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      deliveryGeoPoint: deliveryGeoPoint ?? this.deliveryGeoPoint,
      deliveryPhone: deliveryPhone ?? this.deliveryPhone,
      fees: fees ?? this.fees,
      paid: paid ?? this.paid,
      status: status ?? this.status,
      deliveryTD: deliveryTD ?? this.deliveryTD,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      employeeID: employeeID ?? this.employeeID,
      vehicleID: vehicleID ?? this.vehicleID,
      orgID: orgID ?? this.orgID,
      registrationTD: registrationTD ?? this.registrationTD,
      registeredBy: registeredBy ?? this.registeredBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumerID': consumerID,
      'deliveryAddress': deliveryAddress,
      'deliveryGeoPoint': deliveryGeoPoint,
      'deliveryPhone': deliveryPhone,
      'fees': fees,
      'paid': paid,
      'status': status,
      'deliveryTD': deliveryTD,
      'paymentMethod': paymentMethod,
      'employeeID': employeeID,
      'vehicleID': vehicleID,
      'orgID': orgID,
      'registrationTD': registrationTD,
      'registeredBy': registeredBy,
      'deactivate': deactivate,
    };
  }

  // fromJson method
  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] ?? "",
      consumerID: json['consumerID'] ?? "",
      deliveryAddress: json['deliveryAddress'] ?? "",
      deliveryGeoPoint: json['deliveryGeoPoint'] ?? const GeoPoint(0, 0),
      deliveryPhone: json['deliveryPhone'] ?? "",
      fees: json['fees'] ?? 0,
      paid: json['paid'] ?? 0,
      status: json['status'] ?? "",
      deliveryTD: json['deliveryTD'] ?? Timestamp.now(),
      paymentMethod: json['paymentMethod'] ?? "",
      employeeID: json['employeeID'] ?? "",
      vehicleID: json['vehicleID'] ?? "",
      orgID: json['orgID'] ?? "",
      registrationTD: json['registrationTD'] ?? Timestamp.now(),
      registeredBy: json['registeredBy'] ?? "",
      deactivate: json['deactivate'] ?? false,
    );
  }

  // toString method
  @override
  String toString() {
    return '''
DeliveryModel(
  id: $id,
  consumerID: $consumerID,
  deliveryAddress: $deliveryAddress,
  deliveryGeoPoint: $deliveryGeoPoint,
  deliveryPhone: $deliveryPhone,
  fees: $fees,
  paid: $paid,
  status: $status,
  deliveryTD: $deliveryTD,
  paymentMethod: $paymentMethod,
  employeeID: $employeeID,
  vehicleID: $vehicleID,
  orgID: $orgID,
  registrationTD: $registrationTD,
  registeredBy: $registeredBy,
  deactivate: $deactivate,
)
    ''';
  }
}
