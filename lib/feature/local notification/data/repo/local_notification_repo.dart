import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as timeZone;
import '../../../../core/error/error_handler.dart';

class NotificationsRepository {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationsRepository(this._notificationsPlugin);

  Future<void> initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      await _notificationsPlugin.initialize(initializationSettings);
    } catch (e) {
      throw NotificationError("Failed to initialize notifications: $e");
    }
  }

  Future<void> showInstantNotification(
      int id, String title, String body) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Channel for instant notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _notificationsPlugin.show(
          id, title, body, platformChannelSpecifics);
    } catch (e) {
      throw NotificationError("Failed to show instant notification: $e");
    }
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime scheduledTime) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'scheduled_channel',
        'Scheduled Notifications',
        channelDescription: 'Channel for scheduled notifications',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      // Convert DateTime to tz.TZDateTime
      final timeZone.TZDateTime tzScheduledTime =
          timeZone.TZDateTime.from(scheduledTime, timeZone.local);

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      throw NotificationError("Failed to schedule notification: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    try {
      await _notificationsPlugin.cancel(id);
    } catch (e) {
      throw NotificationError("Failed to cancel notification with ID $id: $e");
    }
  }

  Future<void> cancelAllNotifications() async {
    try {
      await _notificationsPlugin.cancelAll();
    } catch (e) {
      throw NotificationError("Failed to clear all notifications: $e");
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      throw NotificationError("Failed to fetch pending notifications: $e");
    }
  }
}
