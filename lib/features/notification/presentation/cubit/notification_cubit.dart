import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gas/core/utils/error.dart';
import 'package:gas/core/utils/local_notification.dart';
import 'package:gas/features/notification/data/models/notification_model.dart';
import 'package:gas/features/notification/domain/repo/notification_local_repo.dart';
import 'package:gas/features/notification/domain/repo/notification_remote_repo.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRemoteRepo _repo;
  final NotificationLocalRepo _localRepo;
  StreamSubscription? _subscription;

  NotificationCubit({
    required NotificationRemoteRepo repo,
    required NotificationLocalRepo localRepo,
  }) : _repo = repo,
       _localRepo = localRepo,
       super(const NotificationState());

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }

  Future<void> initNotificationsStream({required String businessID}) async {
    try {
      emit(state.copyWith(streamNotificationsStatus: StateStatus.loading));

      _subscription = _repo.streamNotifications(businessID: businessID).listen((
        notifications,
      ) async {
        final notifiedIDs = await _localRepo.getNotifiedNotification();
        final localNotification = LocalNotification();

        for (final notification in notifications) {
          final alreadyNotified = notifiedIDs.contains(notification.id);
          final isTodayNotification = _isToday(
            notification.creationTD.toDate(),
          );

          if (!alreadyNotified && isTodayNotification) {
            await localNotification.defaultNotify(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              title: notification.title,
              body: notification.description,
              payload: notification.id,
            );
            await _localRepo.setNotifiedNotification(
              notificationID: notification.id,
            );
          }
        }

        emit(
          state.copyWith(
            notifications: notifications,
            streamNotificationsStatus: StateStatus.success,
          ),
        );
      });
    } catch (e) {
      emit(
        state.copyWith(
          streamNotificationsStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
    }
  }

  bool _isToday(DateTime dt) {
    final now = DateTime.now();
    return dt.year == now.year && dt.month == now.month && dt.day == now.day;
  }

  Future<bool> addNotification({
    required NotificationModel notification,
  }) async {
    try {
      emit(state.copyWith(addNotificationStatus: StateStatus.loading));
      await _repo.addNotification(notification: notification);
      emit(state.copyWith(addNotificationStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          addNotificationStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> updateNotification({
    required NotificationModel notification,
  }) async {
    try {
      emit(state.copyWith(updateNotificationStatus: StateStatus.loading));
      await _repo.updateNotification(notification: notification);
      emit(state.copyWith(updateNotificationStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          updateNotificationStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }

  Future<bool> readAllNotification({required String businessID}) async {
    try {
      emit(state.copyWith(readAllNotificationStatus: StateStatus.loading));
      await _repo.readAllNotification(businessID: businessID);
      emit(state.copyWith(readAllNotificationStatus: StateStatus.success));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          readAllNotificationStatus: StateStatus.failure,
          error: CommonError(consoleMessage: e.toString()),
        ),
      );
      return false;
    }
  }
}
