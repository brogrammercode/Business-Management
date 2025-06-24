import 'dart:io';

import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/employee/data/models/salary_model.dart';
import 'package:gas/features/employee/data/models/track_model.dart';

abstract class BusinessRepo {
  Stream<List<BusinessParams>> getBusinesses();
  Future<bool> addBusiness({
    required BusinessModel business,
    required File? avatar,
  });
  Future<bool> updateBusiness({
    required BusinessModel business,
    required File? avatar,
  });
  Future<void> requestToJoinBusiness({required String businessID});
}

class BusinessParams {
  final BusinessModel business;
  final List<EmployeeParam> owners;
  final List<EmployeeParam> admins;
  final List<EmployeeParam> employees;
  final List<EmployeeParam> requests;

  BusinessParams({
    required this.business,
    required this.owners,
    required this.admins,
    required this.employees,
    required this.requests,
  });
}

class EmployeeParam {
  final EmployeeModel employee;
  final List<SalaryModel> salaries;
  final List<TrackModel> tracks;

  EmployeeParam({
    required this.employee,
    required this.salaries,
    required this.tracks,
  });
}
