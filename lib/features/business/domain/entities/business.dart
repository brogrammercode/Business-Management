import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/core/utils/location.dart';

class Business extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String avatar;
  final UserLocationModel location;
  final List socialHandles;
  final List owners;
  final List admins;
  final List employees;
  final List requests;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Business({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatar,
    required this.location,
    required this.socialHandles,
    required this.owners,
    required this.admins,
    required this.employees,
    required this.requests,
    required this.creationTD,
    required this.createdBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        bio,
        avatar,
        location,
        socialHandles,
        owners,
        admins,
        employees,
        requests,
        creationTD,
        createdBy,
        deactivate,
      ];
}
