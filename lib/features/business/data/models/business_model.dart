import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/business/domain/entities/business.dart';

class BusinessModel extends Business {
  const BusinessModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.avatar,
    required super.location,
    required super.socialHandles,
    required super.owners,
    required super.admins,
    required super.employees,
    required super.requests,
    required super.creationTD,
    required super.createdBy,
    required super.deactivate,
  });

  BusinessModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatar,
    UserLocationModel? location,
    List? socialHandles,
    List? owners,
    List? admins,
    List? employees,
    List? requests,
    Timestamp? creationTD,
    String? createdBy,
    bool? deactivate,
  }) {
    return BusinessModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      socialHandles: socialHandles ?? this.socialHandles,
      owners: owners ?? this.owners,
      admins: admins ?? this.admins,
      employees: employees ?? this.employees,
      requests: requests ?? this.requests,
      creationTD: creationTD ?? this.creationTD,
      createdBy: createdBy ?? this.createdBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  factory BusinessModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON map cannot be null');
    }

    return BusinessModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      avatar: json['avatar'] ?? '',
      location: UserLocationModel.fromJson(json['location'] ?? {}),
      socialHandles: List.from(json['socialHandles'] ?? []),
      owners: List.from(json['owners'] ?? []),
      admins: List.from(json['admins'] ?? []),
      employees: List.from(json['employees'] ?? []),
      requests: List.from(json['requests'] ?? []),
      creationTD: json['creationTD'] is Timestamp
          ? json['creationTD']
          : Timestamp(0, 0),
      createdBy: json['createdBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'location': location.toJson(),
      'socialHandles': socialHandles,
      'owners': owners,
      'admins': admins,
      'employees': employees,
      'requests': requests,
      'creationTD': creationTD,
      'createdBy': createdBy,
      'deactivate': deactivate,
    };
  }

  @override
  String toString() {
    return 'BusinessModel(id: $id, name: $name, bio: $bio, avatar: $avatar, location: $location, socialHandles: $socialHandles, owners: $owners, admins: $admins, employees: $employees, requests: $requests, creationTD: $creationTD, createdBy: $createdBy, deactivate: $deactivate)';
  }
}
