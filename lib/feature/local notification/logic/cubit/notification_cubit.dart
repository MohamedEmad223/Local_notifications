import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:meta/meta.dart';

import '../../data/repo/local_notification_repo.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this._notificationsRepository) : super(NotificationInitial());
  NotificationsRepository _notificationsRepository;

  Future<void> initializeNotifications() async {
    try {
      await _notificationsRepository.initializeNotifications();
      emit(NotificationInitialized());
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

   Future<void> showInstantNotification(int id, String title, String body) async {
    try {
      await _notificationsRepository.showInstantNotification(id, title, body);
      emit(NotificationShown());
    } catch (e) {
      emit(NotificationError("Failed to show instant notification: $e"));
    }
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    try {
      final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(scheduledTime, tz.local);
      await _notificationsRepository.scheduleNotification(id, title, body, tzScheduledTime);
      emit(NotificationScheduled());
    } catch (e) {
      emit(NotificationError("Failed to schedule notification: $e"));
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsRepository.cancelNotification(id);
      emit(NotificationCancelled());
    } catch (e) {
      emit(NotificationError("Failed to cancel notification with ID $id: $e"));
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsRepository.cancelAllNotifications();
      emit(AllNotificationsCancelled());
    } catch (e) {
      emit(NotificationError("Failed to cancel all notifications: $e"));
    }
  }

  Future<void> fetchPendingNotifications() async {
    emit(NotificationsLoading());
    try {
      final pendingNotifications = await _notificationsRepository.getPendingNotifications();
      emit(PendingNotificationsLoaded(pendingNotifications));
    } catch (e) {
      emit(NotificationError("Failed to fetch pending notifications: $e"));
    }
  }


}
