import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/features/consumer/domain/entities/consumer.dart';

class ConsumerModel extends Consumer {
  const ConsumerModel({
    required super.id,
    required super.name,
    required super.image,
    required super.husbandspouseName,
    required super.phoneNo,
    required super.gender,
    required super.dob,
    required super.consumerNo,
    required super.address,
    required super.addressGeoPoint,
    required super.svNo,
    required super.consumerAadharNo,
    required super.husbandspouseAadharNo,
    required super.rationNo,
    required super.bankAccountNo,
    required super.paid,
    required super.due,
    required super.orgID,
    required super.registrationTD,
    required super.registeredBy,
    required super.deactivate,
  });

  // copyWith method
  ConsumerModel copyWith({
    String? id,
    String? name,
    String? image,
    String? husbandspouseName,
    String? phoneNo,
    String? gender,
    Timestamp? dob,
    String? consumerNo,
    String? address,
    GeoPoint? addressGeoPoint,
    String? svNo,
    String? consumerAadharNo,
    String? husbandspouseAadharNo,
    String? rationNo,
    String? bankAccountNo,
    num? paid,
    num? due,
    String? orgID,
    Timestamp? registrationTD,
    bool? deactivate,
    String? registeredBy,
  }) {
    return ConsumerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      husbandspouseName: husbandspouseName ?? this.husbandspouseName,
      phoneNo: phoneNo ?? this.phoneNo,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      consumerNo: consumerNo ?? this.consumerNo,
      address: address ?? this.address,
      addressGeoPoint: addressGeoPoint ?? this.addressGeoPoint,
      svNo: svNo ?? this.svNo,
      consumerAadharNo: consumerAadharNo ?? this.consumerAadharNo,
      husbandspouseAadharNo:
          husbandspouseAadharNo ?? this.husbandspouseAadharNo,
      rationNo: rationNo ?? this.rationNo,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      paid: paid ?? this.paid,
      due: due ?? this.due,
      orgID: orgID ?? this.orgID,
      registrationTD: registrationTD ?? this.registrationTD,
      deactivate: deactivate ?? this.deactivate,
      registeredBy: registeredBy ?? this.registeredBy,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'husbandspouseName': husbandspouseName,
      'phoneNo': phoneNo,
      'gender': gender,
      'dob': dob,
      'consumerNo': consumerNo,
      'address': address,
      'addressGeoPoint': addressGeoPoint,
      'svNo': svNo,
      'consumerAadharNo': consumerAadharNo,
      'husbandspouseAadharNo': husbandspouseAadharNo,
      'rationNo': rationNo,
      'bankAccountNo': bankAccountNo,
      'paid': paid,
      'due': due,
      'orgID': orgID,
      'registrationTD': registrationTD,
      'deactivate': deactivate,
      'registeredBy': registeredBy,
    };
  }

  // fromJson method
  factory ConsumerModel.fromJson(Map<String, dynamic> json) {
    return ConsumerModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      image: json['image'] ?? "",
      husbandspouseName: json['husbandspouseName'] ?? "",
      phoneNo: json['phoneNo'] ?? "",
      gender: json['gender'] ?? "",
      dob: json['dob'] ?? Timestamp.now(),
      consumerNo: json['consumerNo'] ?? "",
      address: json['address'] ?? "",
      addressGeoPoint: json['addressGeoPoint'] ?? const GeoPoint(0, 0),
      svNo: json['svNo'] ?? "",
      consumerAadharNo: json['consumerAadharNo'] ?? "",
      husbandspouseAadharNo: json['husbandspouseAadharNo'] ?? "",
      rationNo: json['rationNo'] ?? "",
      bankAccountNo: json['bankAccountNo'] ?? "",
      paid: json['paid'] ?? 0,
      due: json['due'] ?? 0,
      orgID: json['orgID'] ?? "",
      registrationTD: json['registrationTD'] ?? Timestamp.now(),
      deactivate: json['deactivate'] ?? false,
      registeredBy: json['registeredBy'] ?? "",
    );
  }

  // toString method
  @override
  String toString() {
    return '''
ConsumerModel(
  id: $id,
  name: $name,
  image: $image,
  husbandspouseName: $husbandspouseName,
  phoneNo: $phoneNo,
  gender: $gender,
  dob: $dob,
  consumerNo: $consumerNo,
  address: $address,
  addressGeoPoint: $addressGeoPoint,
  svNo: $svNo,
  consumerAadharNo: $consumerAadharNo,
  husbandspouseAadharNo: $husbandspouseAadharNo,
  rationNo: $rationNo,
  bankAccountNo: $bankAccountNo,
  paid: $paid,
  due: $due,
  orgID: $orgID,
  registrationTD: $registrationTD,
  deactivate: $deactivate,
  registeredBy: $registeredBy,
)
    ''';
  }
}
