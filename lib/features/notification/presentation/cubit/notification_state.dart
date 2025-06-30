part of 'notification_cubit.dart';

class NotificationState extends Equatable {
  final List<NotificationModel> notifications;
  final StateStatus streamNotificationsStatus;
  final StateStatus addNotificationStatus;
  final StateStatus updateNotificationStatus;
  final StateStatus readAllNotificationStatus;
  final CommonError error;

  const NotificationState({
    this.notifications = const [],
    this.streamNotificationsStatus = StateStatus.initial,
    this.addNotificationStatus = StateStatus.initial,
    this.updateNotificationStatus = StateStatus.initial,
    this.readAllNotificationStatus = StateStatus.initial,
    this.error = const CommonError(),
  });

  NotificationState copyWith({
    List<NotificationModel>? notifications,
    StateStatus? streamNotificationsStatus,
    StateStatus? addNotificationStatus,
    StateStatus? updateNotificationStatus,
    StateStatus? readAllNotificationStatus,
    StateStatus? notifyInPhoneStatus,
    CommonError? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      streamNotificationsStatus:
          streamNotificationsStatus ?? this.streamNotificationsStatus,
      addNotificationStatus:
          addNotificationStatus ?? this.addNotificationStatus,
      updateNotificationStatus:
          updateNotificationStatus ?? this.updateNotificationStatus,
      readAllNotificationStatus:
          readAllNotificationStatus ?? this.readAllNotificationStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [
    notifications,
    streamNotificationsStatus,
    addNotificationStatus,
    updateNotificationStatus,
    readAllNotificationStatus,
    error,
  ];
}
