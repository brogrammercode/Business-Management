import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/employee/domain/entities/salary.dart';

class SalaryModel extends Salary {
  const SalaryModel({
    required super.id,
    required super.employeeID,
    required super.stipend,
    required super.startTD,
    required super.endTD,
    required super.businessID,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  SalaryModel copyWith({
    String? id,
    String? employeeID,
    num? stipend,
    Timestamp? startTD,
    Timestamp? endTD,
    String? businessID,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return SalaryModel(
      id: id ?? this.id,
      employeeID: employeeID ?? this.employeeID,
      stipend: stipend ?? this.stipend,
      startTD: startTD ?? this.startTD,
      endTD: endTD ?? this.endTD,
      businessID: businessID ?? this.businessID,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  factory SalaryModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return throw ArgumentError('JSON cannot be null');

    return SalaryModel(
      id: json['id'] as String? ?? '',
      employeeID: json['employeeID'] as String? ?? '',
      stipend: json['stipend'] as num? ?? 0,
      startTD: json['startTD'] as Timestamp? ?? Timestamp.now(),
      endTD: json['endTD'] as Timestamp? ?? Timestamp.now(),
      businessID: json['businessID'] as String? ?? '',
      creationTD: json['creationTD'] as Timestamp? ?? Timestamp.now(),
      createdBy: json['createdBy'] as String? ?? '',
      deactivate: json['deactivate'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeID': employeeID,
      'stipend': stipend,
      'startTD': startTD,
      'endTD': endTD,
      'businessID': businessID,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  @override
  String toString() {
    return 'SalaryModel(id: $id, employeeID: $employeeID, stipend: $stipend, startTD: $startTD, endTD: $endTD, businessID: $businessID, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate)';
  }
}
