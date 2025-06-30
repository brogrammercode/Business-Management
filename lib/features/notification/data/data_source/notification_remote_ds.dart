import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gas/features/notification/data/models/notification_model.dart';
import 'package:gas/features/notification/domain/repo/notification_remote_repo.dart';

class NotificationRemoteDs implements NotificationRemoteRepo {
  final _firestore = FirebaseFirestore.instance;
  final String _notificationPath = 'notifications';

  @override
  Future<bool> addNotification({
    required NotificationModel notification,
  }) async {
    try {
      await _firestore
          .collection(_notificationPath)
          .doc(notification.id)
          .set(notification.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> readAllNotification({required String businessID}) async {
    try {
      final snapshot = await _firestore
          .collection(_notificationPath)
          .where('businessID', isEqualTo: businessID)
          .get();

      final batch = _firestore.batch();

      for (final doc in snapshot.docs) {
        final data = doc.data();
        final notification = NotificationModel.fromJson(data);

        final seenList = List<SeenModel>.from(notification.seen);
        final uid = FirebaseAuth.instance.currentUser?.uid ?? "";
        final alreadySeen = seenList.any((s) => s.uid == uid);

        if (!alreadySeen) {
          seenList.add(SeenModel(uid: uid, td: Timestamp.now()));
          batch.update(doc.reference, {
            'seen': seenList.map((e) => e.toJson()).toList(),
          });
        }
      }

      await batch.commit();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<List<NotificationModel>> streamNotifications({
    required String businessID,
  }) {
    return _firestore
        .collection(_notificationPath)
        .where('businessID', isEqualTo: businessID)
        .orderBy('creationTD', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => NotificationModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<bool> updateNotification({
    required NotificationModel notification,
  }) async {
    try {
      await _firestore
          .collection(_notificationPath)
          .doc(notification.id)
          .update(notification.toJson());
      return true;
    } catch (_) {
      return false;
    }
  }
}
