import 'package:gas/features/notification/data/models/notification_model.dart';
import 'package:gas/features/notification/domain/repo/notification_remote_repo.dart';

class NotificationRemoteDs implements NotificationRemoteRepo {
  @override
  Future<bool> addNotification({required NotificationModel notification}) {
    // TODO: implement addNotification
    throw UnimplementedError();
  }

  @override
  Future<bool> notifyInPhone({required NotificationModel notification}) {
    // TODO: implement notifyInPhone
    throw UnimplementedError();
  }

  @override
  Future<bool> readAllNotification({required String businessID}) {
    // TODO: implement readAllNotification
    throw UnimplementedError();
  }

  @override
  Stream<List<NotificationModel>> streamNotifications({
    required String businessID,
  }) {
    // TODO: implement streamNotifications
    throw UnimplementedError();
  }

  @override
  Future<bool> updateNotification({required NotificationModel notification}) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }
}
