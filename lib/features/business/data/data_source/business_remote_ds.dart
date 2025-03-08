import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:rxdart/rxdart.dart' as rx;
import 'package:gas/core/utils/upload_image.dart';
import 'package:gas/features/business/data/models/business_model.dart';
import 'package:gas/features/business/domain/repositories/business_repo.dart';
import 'package:gas/features/employee/data/models/employee_model.dart';

class BusinessRemoteDs implements BusinessRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<bool> addBusiness({
    required BusinessModel business,
    required File? avatar,
  }) async {
    try {
      String avatarUrl = "";
      if (avatar != null) {
        avatarUrl = await uploadImage(
          id: business.id,
          image: avatar,
          folder: "Organizations",
          fileName: "avatar.jpg",
        );
      }

      final orgCollection = firestore.collection('organizations');
      await orgCollection.doc(business.id).set(
            business.copyWith(avatar: avatarUrl).toJson(),
          );

      return true;
    } catch (e) {
      log('Failed to add organization: $e');
      return false;
    }
  }

  final Map<String, rx.BehaviorSubject<EmployeeModel?>> _employeeCache = {};

  @override
  Stream<List<BusinessParams>> getBusinesses() {
    return firestore.collection('organizations').snapshots().switchMap(
      (orgSnapshots) {
        final businessStreams = orgSnapshots.docs.map((doc) {
          final business = BusinessModel.fromJson(doc.data());

          return _combineBusinessStreams(business);
        });

        return rx.Rx.combineLatestList(businessStreams);
      },
    );
  }

  Stream<BusinessParams> _combineBusinessStreams(BusinessModel business) {
    final ownersStream = _fetchEmployeesByUIDs(business.owners);
    final adminsStream = _fetchEmployeesByUIDs(business.admins);
    final employeesStream = _fetchEmployeesByUIDs(business.employees);
    final requestsStream = _fetchEmployeesByUIDs(business.requests);

    return rx.Rx.combineLatest4(
      ownersStream,
      adminsStream,
      employeesStream,
      requestsStream,
      (List<EmployeeModel> owners, List<EmployeeModel> admins,
          List<EmployeeModel> employees, List<EmployeeModel> requests) {
        return BusinessParams(
          business: business,
          owners: owners,
          admins: admins,
          employees: employees,
          requests: requests,
        );
      },
    );
  }

  Stream<List<EmployeeModel>> _fetchEmployeesByUIDs(List<dynamic> uids) {
    if (uids.isEmpty) return Stream.value([]);

    final List<Stream<EmployeeModel?>> employeeStreams = [];

    for (String uid in uids) {
      if (!_employeeCache.containsKey(uid)) {
        final subject = rx.BehaviorSubject<EmployeeModel?>();
        _employeeCache[uid] = subject;

        firestore
            .collection('employees')
            .doc(uid)
            .snapshots()
            .listen((snapshot) {
          if (snapshot.exists) {
            subject.add(EmployeeModel.fromJson(snapshot.data()!));
          } else {
            subject.add(null);
          }
        });
      }
      employeeStreams.add(_employeeCache[uid]!);
    }

    return rx.Rx.combineLatest<List<EmployeeModel?>, List<EmployeeModel>>(
      employeeStreams.map((stream) => stream.map((employee) => [employee])),
      (data) => data.expand((e) => e).whereType<EmployeeModel>().toList(),
    );
  }

  @override
  Future<void> requestToJoinBusiness({required String businessID}) async {
    try {
      final orgDoc = firestore.collection('organizations').doc(businessID);
      await orgDoc.update({
        'requests': FieldValue.arrayUnion([auth.currentUser?.uid ?? ""]),
      });
    } catch (e) {
      throw Exception('Failed to request to join organization: $e');
    }
  }
}
