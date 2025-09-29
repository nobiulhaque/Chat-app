import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifiService{
  static final NotifiService _instance = NotifiService._internal();
  factory NotifiService() => _instance;
  NotifiService._internal();

  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSeetingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSetting = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSeetingsIOS,
    );

    await notificationPlugin.initialize(initSetting);
    _isInitialized = true;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "chat_channel",
        "Chat Messages",
        channelDescription: "Shows notifications for incoming chat messages",
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationPlugin.show(
      id,
      title,
      body,
      notificationDetails(),
    );
  }
}
