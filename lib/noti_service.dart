import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // ตั้งค่า timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.local);

    // ตั้งค่า Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // ตั้งค่า iOS (ถ้าต้องการ)
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // เมื่อกดที่ notification ให้
        print('Notification clicked: ${response.payload}');
      },
    );

    // ขอ permission สำหรับ Android 13+
    await _requestPermissions();
  }

  // ขอ permission ในการแจ้งเตือน
  Future<void> _requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
    await androidImplementation?.requestExactAlarmsPermission();
  }

  // สร้าง notification channel
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'trip_reminder_channel',
      'การแจ้งเตือนทริป',
      description: 'แจ้งเตือนการเตรียมตัวเดินทาง',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // กำหนดการแจ้งเตือนสำหรับทริป
  Future<void> scheduleTripNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    await _createNotificationChannel();

    // แปลงเวลาให้ตรงกับเวลาเครื่อง
    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    // ตรวจสอบว่าเวลาที่กำหนดยังไม่ผ่านไป
    if (scheduledTZDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print('เวลาที่กำหนดผ่านไปแล้ว ไม่สามารถตั้งการแจ้งเตือนได้');
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledTZDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'trip_reminder_channel',
          'การแจ้งเตือนทริป',
          channelDescription: 'แจ้งเตือนการเตรียมตัวเดินทาง',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );

    print('ตั้งการแจ้งเตือนสำเร็จ: $title เวลา $scheduledTZDate');
  }

  // ยกเลิกการแจ้งเตือน
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    print('ยกเลิกการแจ้งเตือน ID: $id');
  }

  // ยกเลิกการแจ้งเตือนทั้งหมด
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  // ดูรายการการแจ้งเตือนที่รออยู่
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
