part of 'notification_cubit.dart';

@immutable
sealed class NotificationState {}

final class NotificationInitial extends NotificationState {}

final class NotificationInitialized extends NotificationState {}

final class NotificationError extends NotificationState {
  final String error;

  NotificationError(this.error);
}

final class NotificationShown extends NotificationState {}

final class NotificationScheduled extends NotificationState {}

final class NotificationCancelled extends NotificationState {}

final class AllNotificationsCancelled extends NotificationState {}

final class NotificationsLoading extends NotificationState {}

final class PendingNotificationsLoaded extends NotificationState {
  final List<PendingNotificationRequest> pendingNotifications;

  PendingNotificationsLoaded(this.pendingNotifications);
}
