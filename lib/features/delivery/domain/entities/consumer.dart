import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gas/core/utils/location.dart';

class Consumer extends Equatable {
  final String id;
  final String name;
  final String image;
  final String husbandspouseName;
  final String phoneNo;
  final String gender;
  final Timestamp dob;
  final String consumerNo;
  final UserLocationModel address;
  final String svNo;
  final String consumerAadharNo;
  final String husbandspouseAadharNo;
  final String rationNo;
  final String bankAccountNo;
  final num paid;
  final num due;
  final String businessID;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Consumer({
    required this.id,
    required this.name,
    required this.image,
    required this.husbandspouseName,
    required this.phoneNo,
    required this.gender,
    required this.dob,
    required this.consumerNo,
    required this.address,
    required this.svNo,
    required this.consumerAadharNo,
    required this.husbandspouseAadharNo,
    required this.rationNo,
    required this.bankAccountNo,
    required this.paid,
    required this.due,
    required this.businessID,
    required this.creationTD,
    required this.createdBy,
    required this.deactivate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        husbandspouseName,
        phoneNo,
        gender,
        dob,
        consumerNo,
        address,
        svNo,
        consumerAadharNo,
        husbandspouseAadharNo,
        rationNo,
        bankAccountNo,
        paid,
        due,
        businessID,
        creationTD,
        createdBy,
        deactivate,
      ];
}
