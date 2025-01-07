import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/core/utils/location.dart';

class Organization extends Equatable {
  final String id;
  final String name;
  final String bio;
  final String avatar;
  final UserLocationModel address;
  final List socialHandles;
  final List owners;
  final List admins;
  final List employees;
  final List requests;
  final Timestamp registrationTD;
  final String registeredBy;
  final bool deactivate;

  const Organization({
    required this.id,
    required this.name,
    required this.bio,
    required this.avatar,
    required this.address,
    required this.socialHandles,
    required this.owners,
    required this.admins,
    required this.employees,
    required this.requests,
    required this.registrationTD,
    required this.registeredBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        bio,
        avatar,
        address,
        socialHandles,
        owners,
        admins,
        employees,
        requests,
        registrationTD,
        registeredBy,
        deactivate,
      ];
}
