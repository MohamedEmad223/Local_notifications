import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_notification/feature/local%20notification/logic/cubit/notification_cubit.dart';
import 'package:timezone/data/latest.dart' as timezone;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    timezone.initializeTimeZones();
    context.read<NotificationCubit>().initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Notifications Example'),
      ),
      body: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
    
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<NotificationCubit>().showInstantNotification(
                          1,
                          'Instant Notification',
                          'This is an instant notification',
                        );
                  },
                  child: const Text('Show Instant Notification'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final DateTime scheduledTime =
                        DateTime.now().add(const Duration(seconds: 10));
                    context.read<NotificationCubit>().scheduleNotification(
                          2,
                          'Scheduled Notification',
                          'This notification is scheduled.',
                          scheduledTime,
                        );
                  },
                  child: const Text('Schedule Notification in 10 seconds'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<NotificationCubit>().cancelNotification(1);
                  },
                  child: const Text('Cancel Notification with ID 1'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<NotificationCubit>()
                        .cancelAllNotifications();
                  },
                  child: const Text('Cancel All Notifications'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<NotificationCubit>()
                        .fetchPendingNotifications();
                  },
                  child: const Text('Fetch Pending Notifications'),
                ),
                if (state is PendingNotificationsLoaded)
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.pendingNotifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            state.pendingNotifications[index];
                        return ListTile(
                          title: Text(notification.title ?? 'No Title'),
                          subtitle: Text('ID: ${notification.id}'),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
