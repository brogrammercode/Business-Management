import 'dart:io';

import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/business/data/models/business_model.dart';

abstract class BusinessRepo {
  Stream<List<BusinessParams>> getBusinesses();
  Future<bool> addBusiness(
      {required BusinessModel business, required File? avatar});
  Future<void> requestToJoinBusiness({required String businessID});
}

class BusinessParams {
  final BusinessModel business;
  final List<EmployeeModel> owners;
  final List<EmployeeModel> admins;
  final List<EmployeeModel> employees;
  final List<EmployeeModel> requests;

  BusinessParams(
      {required this.business,
      required this.owners,
      required this.admins,
      required this.employees,
      required this.requests});
}
