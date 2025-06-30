import 'package:gas/features/notification/domain/repo/notification_local_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationLocalDs implements NotificationLocalRepo {
  static const String _notificationSFkey = 'notified_notification';

  @override
  Future<List<String>> getNotifiedNotification() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_notificationSFkey) ?? [];
  }

  @override
  Future<bool> setNotifiedNotification({required String notificationID}) async {
    final prefs = await SharedPreferences.getInstance();
    final existingList = prefs.getStringList(_notificationSFkey) ?? [];
    if (!existingList.contains(notificationID)) {
      existingList.add(notificationID);
      return await prefs.setStringList(_notificationSFkey, existingList);
    }
    return true;
  }
}
