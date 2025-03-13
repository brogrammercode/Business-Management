import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/vehicle/domain/entities/repair.dart';

class RepairModel extends Repair {
  const RepairModel({
    required super.id,
    required super.vehicleID,
    required super.type,
    required super.fees,
    required super.location,
    required super.businessID,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  RepairModel copyWith({
    String? id,
    String? vehicleID,
    String? type,
    num? fees,
    String? location,
    String? businessID,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return RepairModel(
      id: id ?? this.id,
      vehicleID: vehicleID ?? this.vehicleID,
      type: type ?? this.type,
      fees: fees ?? this.fees,
      location: location ?? this.location,
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
      'type': type,
      'fees': fees,
      'location': location,
      'businessID': businessID,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  factory RepairModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return throw ArgumentError('Invalid JSON: null value found');
    }

    return RepairModel(
      id: json['id'] as String? ?? '',
      vehicleID: json['vehicleID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      fees: (json['fees'] as num?) ?? 0,
      location: json['location'] as String? ?? '',
      businessID: json['businessID'] as String? ?? '',
      creationTD: json['creationTD'] as Timestamp? ?? Timestamp.now(),
      createdBy: json['createdBy'] as String? ?? '',
      deactivate: json['deactivate'] as bool? ?? false,
    );
  }
}
