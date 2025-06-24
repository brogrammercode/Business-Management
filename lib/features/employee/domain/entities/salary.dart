import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Salary extends Equatable {
  final String id;
  final String employeeID;
  final num stipend;
  final Timestamp startTD;
  final Timestamp endTD;
  final String businessID;
  final Timestamp creationTD;
  final String createdBy;
  final bool deactivate;

  const Salary(
      {required this.id,
      required this.employeeID,
      required this.stipend,
      required this.startTD,
      required this.endTD,
      required this.businessID,
      required this.creationTD,
      required this.createdBy,
      required this.deactivate});
  
  @override
  List<Object?> get props => [
        id,
        employeeID,
        stipend,
        startTD,
        endTD,
        businessID,
        creationTD,
        createdBy,
        deactivate,
      ];
}
