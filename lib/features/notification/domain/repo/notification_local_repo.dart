abstract interface class NotificationLocalRepo {
  Future<List<String>> getNotifiedNotification();
  Future<bool> setNotifiedNotification({required String notificationID});
}
