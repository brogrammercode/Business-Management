import 'package:gas/features/notification/data/models/notification_model.dart';

abstract interface class NotificationRemoteRepo {
  Stream<List<NotificationModel>> streamNotifications({
    required String businessID,
  });
  Future<bool> addNotification({required NotificationModel notification});
  Future<bool> updateNotification({required NotificationModel notification});
  Future<bool> readAllNotification({required String businessID});
}
