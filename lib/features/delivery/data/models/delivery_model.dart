import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/delivery/domain/entities/delivery.dart';

class DeliveryModel extends Delivery {
  const DeliveryModel({
    required super.id,
    required super.consumerID,
    required super.employeeID,
    required super.vehicleID,
    required super.deliveryImage,
    required super.deliveryLocation,
    required super.fees,
    required super.paid,
    required super.paymentMethod,
    required super.deliveryTD,
    required super.status,
    required super.businessID,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  DeliveryModel copyWith({
    String? id,
    String? consumerID,
    String? employeeID,
    String? vehicleID,
    String? deliveryImage,
    UserLocationModel? deliveryLocation,
    num? fees,
    num? paid,
    String? paymentMethod,
    Timestamp? deliveryTD,
    String? status,
    String? businessID,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      consumerID: consumerID ?? this.consumerID,
      employeeID: employeeID ?? this.employeeID,
      vehicleID: vehicleID ?? this.vehicleID,
      deliveryImage: deliveryImage ?? this.deliveryImage,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      fees: fees ?? this.fees,
      paid: paid ?? this.paid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryTD: deliveryTD ?? this.deliveryTD,
      status: status ?? this.status,
      businessID: businessID ?? this.businessID,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] ?? '',
      consumerID: json['consumerID'] ?? '',
      employeeID: json['employeeID'] ?? '',
      vehicleID: json['vehicleID'] ?? '',
      deliveryImage: json['deliveryImage'] ?? '',
      deliveryLocation:
          UserLocationModel.fromJson(json['deliveryLocation'] ?? {}),
      fees: json['fees'] ?? 0,
      paid: json['paid'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      deliveryTD: json['deliveryTD'] ?? Timestamp.now(),
      status: json['status'] ?? '',
      businessID: json['businessID'] ?? '',
      creationTD: json['creationTD'] ?? Timestamp.now(),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consumerID': consumerID,
      'employeeID': employeeID,
      'vehicleID': vehicleID,
      'deliveryImage': deliveryImage,
      'deliveryLocation': deliveryLocation.toJson(),
      'fees': fees,
      'paid': paid,
      'paymentMethod': paymentMethod,
      'deliveryTD': deliveryTD,
      'status': status,
      'businessID': businessID,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  @override
  String toString() {
    return '''
DeliveryModel(
  id: $id,
  consumerID: $consumerID,
  employeeID: $employeeID,
  vehicleID: $vehicleID,
  deliveryImage: $deliveryImage,
  deliveryLocation: $deliveryLocation,
  fees: $fees,
  paid: $paid,
  paymentMethod: $paymentMethod,
  deliveryTD: $deliveryTD,
  status: $status,
  businessID: $businessID,
  creationTD: $creationTD,
  createdBy: $createdBy,
  deactivate: $deactivate,
)
    ''';
  }
}
