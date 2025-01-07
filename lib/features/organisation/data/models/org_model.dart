import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/organisation/domain/entities/organisation.dart';

class OrgModel extends Organization {
  const OrgModel({
    required super.id,
    required super.name,
    required super.bio,
    required super.avatar,
    required super.address,
    required super.socialHandles,
    required super.owners,
    required super.admins,
    required super.employees,
    required super.requests,
    required super.registrationTD,
    required super.registeredBy,
    required super.deactivate,
  });

  OrgModel copyWith({
    String? id,
    String? name,
    String? bio,
    String? avatar,
    UserLocationModel? address,
    List? socialHandles,
    List? owners,
    List? admins,
    List? employees,
    List? requests,
    Timestamp? registrationTD,
    String? registeredBy,
    bool? deactivate,
  }) {
    return OrgModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      socialHandles: socialHandles ?? this.socialHandles,
      owners: owners ?? this.owners,
      admins: admins ?? this.admins,
      employees: employees ?? this.employees,
      requests: requests ?? this.requests,
      registrationTD: registrationTD ?? this.registrationTD,
      registeredBy: registeredBy ?? this.registeredBy,
      deactivate: deactivate ?? this.deactivate,
    );
  }

  factory OrgModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      throw ArgumentError('JSON map cannot be null');
    }

    return OrgModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      avatar: json['avatar'] ?? '',
      address: UserLocationModel.fromJson(json['address'] ?? {}),
      socialHandles: List.from(json['socialHandles'] ?? []),
      owners: List.from(json['owners'] ?? []),
      admins: List.from(json['admins'] ?? []),
      employees: List.from(json['employees'] ?? []),
      requests: List.from(json['requests'] ?? []),
      registrationTD: json['registrationTD'] is Timestamp
          ? json['registrationTD']
          : Timestamp(0, 0),
      registeredBy: json['registeredBy'] ?? '',
      deactivate: json['deactivate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'address': address.toJson(),
      'socialHandles': socialHandles,
      'owners': owners,
      'admins': admins,
      'employees': employees,
      'requests': requests,
      'registrationTD': registrationTD,
      'registeredBy': registeredBy,
      'deactivate': deactivate,
    };
  }

  @override
  String toString() {
    return 'OrgModel(id: $id, name: $name, bio: $bio, avatar: $avatar, address: $address, socialHandles: $socialHandles, owners: $owners, admins: $admins, employees: $employees, requests: $requests, registrationTD: $registrationTD, registeredBy: $registeredBy, deactivate: $deactivate)';
  }
}
