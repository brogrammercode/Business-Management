import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/vehicle/domain/entities/fuel.dart';

class FuelModel extends Fuel {
  const FuelModel({
    required super.id,
    required super.vehicleID,
    required super.volume,
    required super.fees,
    required super.location,
    required super.odometer,
    required super.businessID,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  FuelModel copyWith({
    String? id,
    String? vehicleID,
    num? volume,
    num? fees,
    String? location,
    num? odometer,
    String? businessID,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return FuelModel(
      id: id ?? this.id,
      vehicleID: vehicleID ?? this.vehicleID,
      volume: volume ?? this.volume,
      fees: fees ?? this.fees,
      location: location ?? this.location,
      odometer: odometer ?? this.odometer,
      businessID: businessID ?? this.businessID,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleID': vehicleID,
      'volume': volume,
      'fees': fees,
      'location': location,
      'odometer': odometer,
      'businessID': businessID,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  factory FuelModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return throw ArgumentError('Invalid JSON: null value found');
    }

    return FuelModel(
      id: json['id'] as String? ?? '',
      vehicleID: json['vehicleID'] as String? ?? '',
      volume: (json['volume'] as num?) ?? 0,
      fees: (json['fees'] as num?) ?? 0,
      location: json['location'] as String? ?? '',
      odometer: (json['odometer'] as num?) ?? 0,
      businessID: json['businessID'] as String? ?? '',
      creationTD: json['creationTD'] as Timestamp? ?? Timestamp.now(),
      createdBy: json['createdBy'] as String? ?? '',
      deactivate: json['deactivate'] as bool? ?? false,
    );
  }
}
