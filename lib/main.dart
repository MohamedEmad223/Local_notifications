import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_notification/feature/local%20notification/logic/cubit/notification_cubit.dart';
import 'package:timezone/data/latest.dart' as timezone;

import 'feature/local notification/data/repo/local_notification_repo.dart';
import 'feature/local notification/views/screens/notifications_screen.dart';

void main() {
  timezone.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit(
        NotificationsRepository(
          FlutterLocalNotificationsPlugin(),
        ),
      ),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Local Notification Demo',
        home: NotificationsScreen(),
      ),
    );
  }
}
