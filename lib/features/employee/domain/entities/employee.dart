import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final String id;
  final String email;
  final String name;
  final String avatar;
  final String bio;
  final String address;
  final Timestamp dob;
  final String aadharNo;
  final String phoneNo;
  final String bankAccountNo;
  final String upiID;
  final String drivingLicenseURL;
  final String panCardURL;
  final String orgID;
  final Timestamp registrationTD;
  final String registeredBy;
  final bool deactivate;

  const Employee({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.bio,
    required this.address,
    required this.dob,
    required this.aadharNo,
    required this.phoneNo,
    required this.bankAccountNo,
    required this.upiID,
    required this.drivingLicenseURL,
    required this.panCardURL,
    required this.orgID,
    required this.registrationTD,
    required this.registeredBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        bio,
        address,
        dob,
        aadharNo,
        phoneNo,
        bankAccountNo,
        upiID,
        drivingLicenseURL,
        panCardURL,
        orgID,
        registrationTD,
        registeredBy,
        deactivate,
      ];
}
