import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/delivery/domain/entities/consumer.dart';

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
    required super.svNo,
    required super.consumerAadharNo,
    required super.husbandspouseAadharNo,
    required super.rationNo,
    required super.bankAccountNo,
    required super.paid,
    required super.due,
    required super.businessID,
    required super.creationTD,
    required super.createdBy,
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
    UserLocationModel? address,
    String? svNo,
    String? consumerAadharNo,
    String? husbandspouseAadharNo,
    String? rationNo,
    String? bankAccountNo,
    num? paid,
    num? due,
    String? businessID,
    Timestamp? creationTD,
    bool? deactivate,
    String? createdBy,
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
      svNo: svNo ?? this.svNo,
      consumerAadharNo: consumerAadharNo ?? this.consumerAadharNo,
      husbandspouseAadharNo:
          husbandspouseAadharNo ?? this.husbandspouseAadharNo,
      rationNo: rationNo ?? this.rationNo,
      bankAccountNo: bankAccountNo ?? this.bankAccountNo,
      paid: paid ?? this.paid,
      due: due ?? this.due,
      businessID: businessID ?? this.businessID,
      creationTD: creationTD ?? this.creationTD,
      deactivate: deactivate ?? this.deactivate,
      createdBy: createdBy ?? this.createdBy,
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
      'address': address.toJson(),
      'svNo': svNo,
      'consumerAadharNo': consumerAadharNo,
      'husbandspouseAadharNo': husbandspouseAadharNo,
      'rationNo': rationNo,
      'bankAccountNo': bankAccountNo,
      'paid': paid,
      'due': due,
      'businessID': businessID,
      'creationTD': creationTD,
      'deactivate': deactivate,
      'createdBy': createdBy,
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
      address: UserLocationModel.fromJson(json['address'] ?? {}),
      svNo: json['svNo'] ?? "",
      consumerAadharNo: json['consumerAadharNo'] ?? "",
      husbandspouseAadharNo: json['husbandspouseAadharNo'] ?? "",
      rationNo: json['rationNo'] ?? "",
      bankAccountNo: json['bankAccountNo'] ?? "",
      paid: json['paid'] ?? 0,
      due: json['due'] ?? 0,
      businessID: json['businessID'] ?? "",
      creationTD: json['creationTD'] ?? Timestamp.now(),
      deactivate: json['deactivate'] ?? false,
      createdBy: json['createdBy'] ?? "",
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
  svNo: $svNo,
  consumerAadharNo: $consumerAadharNo,
  husbandspouseAadharNo: $husbandspouseAadharNo,
  rationNo: $rationNo,
  bankAccountNo: $bankAccountNo,
  paid: $paid,
  due: $due,
  businessID: $businessID,
  creationTD: $creationTD,
  deactivate: $deactivate,
  createdBy: $createdBy,
)
    ''';
  }
}
