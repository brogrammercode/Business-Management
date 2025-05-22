import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/features/employee/data/models/salary_model.dart';
import 'package:gas/features/employee/data/models/track_model.dart';
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
          folder: "Businesses",
          fileName: "avatar.jpg",
        );
      }

      final orgCollection = firestore.collection('businesses');
      await orgCollection
          .doc(business.id)
          .set(
            business.copyWith(avatar: avatarUrl).toJson(),
            SetOptions(merge: true),
          );

      return true;
    } catch (e) {
      log('Failed to add business: $e');
      return false;
    }
  }

  @override
  Future<bool> updateBusiness({
    required BusinessModel business,
    required File? avatar,
  }) async {
    try {
      String avatarUrl = business.avatar;
      if (avatar != null) {
        avatarUrl = await uploadImage(
          id: business.id,
          image: avatar,
          folder: "Businesses",
          fileName: "avatar.jpg",
        );
      }

      final orgCollection = firestore.collection('businesses');
      await orgCollection
          .doc(business.id)
          .update(business.copyWith(avatar: avatarUrl).toJson());

      return true;
    } catch (e) {
      log('Failed to add business: $e');
      return false;
    }
  }

  final Map<String, rx.BehaviorSubject<EmployeeModel?>> _employeeCache = {};

  @override
  Stream<List<BusinessParams>> getBusinesses() {
    return firestore.collection('businesses').snapshots().switchMap((
      orgSnapshots,
    ) {
      final businessStreams = orgSnapshots.docs.map((doc) {
        final business = BusinessModel.fromJson(doc.data());

        return _combineBusinessStreams(business);
      });

      return rx.Rx.combineLatestList(businessStreams);
    });
  }

  Stream<BusinessParams> _combineBusinessStreams(BusinessModel business) {
    final ownersStream = _fetchEmployeeParamsByUIDs(business.owners);
    final adminsStream = _fetchEmployeeParamsByUIDs(business.admins);
    final employeesStream = _fetchEmployeeParamsByUIDs(business.employees);
    final requestsStream = _fetchEmployeeParamsByUIDs(business.requests);

    return rx.Rx.combineLatest4(
      ownersStream,
      adminsStream,
      employeesStream,
      requestsStream,
      (
        List<EmployeeParam> owners,
        List<EmployeeParam> admins,
        List<EmployeeParam> employees,
        List<EmployeeParam> requests,
      ) {
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

  Stream<List<EmployeeParam>> _fetchEmployeeParamsByUIDs(List<dynamic> uids) {
    if (uids.isEmpty) return Stream.value([]);

    final List<Stream<EmployeeParam?>> employeeStreams = [];

    for (String uid in uids) {
      if (!_employeeCache.containsKey(uid)) {
        final subject = rx.BehaviorSubject<EmployeeModel?>();
        _employeeCache[uid] = subject;

        firestore.collection('employees').doc(uid).snapshots().listen((
          snapshot,
        ) {
          if (snapshot.exists) {
            subject.add(EmployeeModel.fromJson(snapshot.data()!));
          } else {
            subject.add(null);
          }
        });
      }

      final employeeStream = _employeeCache[uid]!.switchMap((employee) {
        if (employee == null) return Stream.value(null);

        final salariesStream = _fetchSalariesByEmployeeID(employee.id);
        final tracksStream = _fetchTracksByEmployeeID(employee.id);

        return rx.Rx.combineLatest2(salariesStream, tracksStream, (
          List<SalaryModel> salaries,
          List<TrackModel> tracks,
        ) {
          return EmployeeParam(
            employee: employee,
            salaries: salaries,
            tracks: tracks,
          );
        });
      });

      employeeStreams.add(employeeStream);
    }

    return rx.Rx.combineLatest<List<EmployeeParam?>, List<EmployeeParam>>(
      employeeStreams.map((stream) => stream.map((param) => [param])),
      (data) => data.expand((e) => e).whereType<EmployeeParam>().toList(),
    );
  }

  Stream<List<SalaryModel>> _fetchSalariesByEmployeeID(String employeeID) {
    return firestore
        .collection('salaries')
        .where('employeeID', isEqualTo: employeeID)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => SalaryModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  Stream<List<TrackModel>> _fetchTracksByEmployeeID(String employeeID) {
    return firestore
        .collection('tracks')
        .where('employeeID', isEqualTo: employeeID)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TrackModel.fromJson(doc.data()))
                  .toList(),
        );
  }

  @override
  Future<void> requestToJoinBusiness({required String businessID}) async {
    try {
      final orgDoc = firestore.collection('businesses').doc(businessID);
      await orgDoc.update({
        'requests': FieldValue.arrayUnion([auth.currentUser?.uid ?? ""]),
      });
    } catch (e) {
      throw Exception('Failed to request to join business: $e');
    }
  }
}
