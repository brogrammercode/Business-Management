import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/employee/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.email,
    required super.name,
    required super.avatar,
    required super.bio,
    required super.address,
    required super.dob,
    required super.aadharNo,
    required super.phoneNo,
    required super.bankAccountNo,
    required super.upiID,
    required super.drivingLicenseURL,
    required super.panCardURL,
    required super.orgID,
    required super.registrationTD,
    required super.registeredBy,
    required super.deactivate,
  });

  // copyWith method
  EmployeeModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? bio,
    String? address,
    Timestamp? dob,
    String? aadharNo,
    String? phoneNo,
    String? bankAccountNo,
    String? upiID,
    String? drivingLicenseURL,
    String? panCardURL,
    String? orgID,
    Timestamp? registrationTD,
    String? registeredBy,
    bool? deactivate,
  }) {
    return EmployeeModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      address: address ?? this.address,
      dob: dob ?? this.dob,
      aadharNo: aadharNo ?? this.aadharNo,
      phoneNo: phoneNo ?? this.phoneNo,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      upiID: upiID ?? this.upiID,
      drivingLicenseURL: drivingLicenseURL ?? this.drivingLicenseURL,
      panCardURL: panCardURL ?? this.panCardURL,
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
      'email': email,
      'name': name,
      'avatar': avatar,
      'bio': bio,
      'address': address,
      'dob': dob,
      'aadharNo': aadharNo,
      'phoneNo': phoneNo,
      'bankAccountNo': bankAccountNo,
      'upiID': upiID,
      'drivingLicenseURL': drivingLicenseURL,
      'panCardURL': panCardURL,
      'orgID': orgID,
      'registrationTD': registrationTD,
      'registeredBy': registeredBy,
      'deactivate': deactivate,
    };
  }

  // fromJson method
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      avatar: json['avatar'] ?? "",
      bio: json['bio'] ?? "",
      address: json['address'] ?? "",
      dob: json['dob'] ?? Timestamp.now(),
      aadharNo: json['aadharNo'] ?? "",
      phoneNo: json['phoneNo'] ?? "",
      bankAccountNo: json['bankAccountNo'] ?? "",
      upiID: json['upiID'] ?? "",
      drivingLicenseURL: json['drivingLicenseURL'] ?? "",
      panCardURL: json['panCardURL'] ?? "",
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
EmployeeModel(
  id: $id,
  email: $email,
  name: $name,
  avatar: $avatar,
  bio: $bio,
  address: $address,
  dob: $dob,
  aadharNo: $aadharNo,
  phoneNo: $phoneNo,
  bankAccountNo: $bankAccountNo,
  upiID: $upiID,
  drivingLicenseURL: $drivingLicenseURL,
  panCardURL: $panCardURL,
  orgID: $orgID,
  registrationTD: $registrationTD,
  registeredBy: $registeredBy,
  deactivate: $deactivate,
)
    ''';
  }
}
