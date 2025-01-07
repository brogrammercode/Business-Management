import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/core/utils/upload_image.dart';
import 'package:gas/features/organisation/data/models/org_model.dart';
import 'package:gas/features/organisation/domain/repositories/org_repo.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';

class OrgRemoteDs implements OrgRepo {
  final firestore = FirebaseFirestore.instance;
  @override
  Future<void> addOrg({required OrgModel org, required File? avatar}) async {
    try {
      String avatarUrl = "";
      if (avatar != null) {
        avatarUrl = await uploadImage(
            id: org.id,
            image: avatar,
            folder: "Organizations",
            fileName: "avatar.jpg");
      }
      final orgCollection = firestore.collection('organizations');
      await orgCollection
          .doc(org.id)
          .set(org.copyWith(avatar: avatarUrl).toJson());
    } catch (e) {
      throw Exception('Failed to add organization: $e');
    }
  }

  @override
  Future<List<OrgParams>> getOrgs() async {
    try {
      final orgCollection = firestore.collection('organizations');
      final orgSnapshots = await orgCollection.get();

      final orgParamsList = await Future.wait(
        orgSnapshots.docs.map((doc) async {
          final orgModel = OrgModel.fromJson(doc.data());
          final employees = await _getEmployeeFromOrg(orgModel.id);
          return OrgParams(org: orgModel, employee: employees);
        }).toList(),
      );

      return orgParamsList;
    } catch (e) {
      throw Exception('Failed to fetch organizations: $e');
    }
  }

  @override
  Future<void> requestToJoinOrg({required String orgID}) async {
    try {
      final orgDoc = firestore.collection('organizations').doc(orgID);
      await orgDoc.update({
        'requests': FieldValue.arrayUnion(
            [FirebaseAuth.instance.currentUser?.uid ?? ""]),
      });
    } catch (e) {
      throw Exception('Failed to request to join organization: $e');
    }
  }

  Future<List<EmployeeModel>> _getEmployeeFromOrg(String orgID) async {
    try {
      final employeesCollection = firestore.collection('employees');
      final querySnapshot =
          await employeesCollection.where('orgID', isEqualTo: orgID).get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs
            .map((doc) => EmployeeModel.fromJson(doc.data()))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception(
          'Failed to fetch employees for organization ID: $orgID. Error: $e');
    }
  }
}
