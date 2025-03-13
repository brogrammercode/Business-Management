import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/core/utils/location.dart';
import 'package:gas/features/employee/data/models/track_model.dart';
import 'package:gas/features/home/domain/repo/home_repo.dart';

class HomeRemoteDs implements HomeRemoteRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserLocationModel?> getLocationFromDatabase() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return null;

    final doc = await _firestore.collection('employees').doc(userId).get();
    final data = doc.data();
    if (data == null || !data.containsKey('address')) return null;

    return UserLocationModel.fromJson(data['address']);
  }

  @override
  Future<bool> updateLocationToDatabase(
      {required UserLocationModel location}) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return false;

      final now = Timestamp.now();
      final todayDate =
          DateTime(now.toDate().year, now.toDate().month, now.toDate().day);
      final tracksRef = _firestore.collection('tracks');

      final existingTrackQuery = await tracksRef
          .where("employeeID", isEqualTo: userId)
          .where("creationTD",
              isGreaterThanOrEqualTo: Timestamp.fromDate(todayDate))
          .limit(1)
          .get();

      final batch = _firestore.batch();

      if (existingTrackQuery.docs.isNotEmpty) {
        final existingDocRef = existingTrackQuery.docs.first.reference;
        batch.update(existingDocRef, {
          "tracks": FieldValue.arrayUnion([location.toJson()])
        });
      } else {
        final trackDocId = now.millisecondsSinceEpoch.toString();
        final newTrackRef = tracksRef.doc(trackDocId);

        batch.set(
            newTrackRef,
            TrackModel(
              id: trackDocId,
              employeeID: userId,
              tracks: [location],
              creationTD: now,
              createdBy: userId,
              deactivate: false,
            ).toJson());
      }

      final employeeRef = _firestore.collection('employees').doc(userId);
      batch.set(
          employeeRef, {"address": location.toJson()}, SetOptions(merge: true));

      await batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }
}
