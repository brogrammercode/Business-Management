import 'dart:io';

import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/organisation/data/models/org_model.dart';

abstract class OrgRepo {
  Future<List<OrgParams>> getOrgs();
  Future<void> addOrg({required OrgModel org, required File? avatar});
  Future<void> requestToJoinOrg({required String orgID});
}

class OrgParams {
  final OrgModel org;
  final List<EmployeeModel> employee;

  OrgParams({required this.org, required this.employee});
}
