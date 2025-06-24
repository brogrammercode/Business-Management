import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/employee/data/models/salary_model.dart';

abstract class EmployeeRemoteRepo {
  Stream<EmployeeParam> streamEmployee();
  Future<bool> signOut();
}

class EmployeeParam {
  final EmployeeModel employee;
  final List<SalaryModel> salary;

  EmployeeParam({required this.employee, required this.salary});
}
