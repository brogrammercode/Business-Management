// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/features/employee/data/models/salary_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:gas/features/employee/data/models/employee_model.dart';
import 'package:gas/features/employee/domain/repo/employee_remote_repo.dart';

class EmployeeRemoteDs implements EmployeeRemoteRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<EmployeeParam> streamEmployee() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return Stream.error("User not logged in");
    }

    final employeeStream = _firestore
        .collection("employees")
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) {
            throw Exception("Employee not found");
          }
          return EmployeeModel.fromJson(snapshot.data()!);
        });

    final salaryStream = _firestore
        .collection("salaries")
        .where("employeeID", isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SalaryModel.fromJson(doc.data()))
              .toList(),
        );

    return rx.Rx.combineLatest2(employeeStream, salaryStream, (
      EmployeeModel employee,
      List<SalaryModel> salaries,
    ) {
      return EmployeeParam(employee: employee, salary: salaries);
    });
  }
}
