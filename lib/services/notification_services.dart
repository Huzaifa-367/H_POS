// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as devtools show log;
// import 'dart:io';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:googleapis_auth/auth_io.dart' as auth;
// import '../main.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:android_intent_plus/android_intent.dart';

// Future<void> handleBackgroundMessage(RemoteMessage message) async {
//   print('===========Title ${message.notification?.title}');
//   print('===========Body: ${message.notification?.body}');
//   print('===========Payload: ${message.data}');
// }

// class FirebasePushNotificationApi {
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   final androidChannel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   void handleMessage(RemoteMessage? message) {
//     print('=========handleMessage:: $message');
//     if (message == null) return;

//     // Get.toNamed(kSplashScreenRoute, arguments: message);
//   }

//   void showProgressNotification(int progress, int id) {
//     final androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'upload_channel',
//       'Upload Channel',
//       importance: Importance.low,
//       priority: Priority.low,
//       showProgress: true,
//       maxProgress: 100,
//       progress: progress,
//     );
//     const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
//     final platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//     flutterLocalNotificationsPlugin.show(
//       0,
//       'Uploading file',
//       '$progress%',
//       platformChannelSpecifics,
//     );
//   }

//   void showCompletionNotification() {
//     const androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'upload_channel',
//       'Upload Channel',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//     const iOSPlatformChannelSpecifics = DarwinNotificationDetails();
//     const platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//     flutterLocalNotificationsPlugin.show(
//       0,
//       'Upload complete',
//       'Your file has been uploaded successfully.',
//       platformChannelSpecifics,
//     );
//   }

//   Future<void> initPushNotifications() async {
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//     FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     FirebaseMessaging.onMessage.listen((message) {
//       final notification = message.notification;
//       if (notification == null) return;

//       flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             iOS: const DarwinNotificationDetails(),
//             android: AndroidNotificationDetails(
//               androidChannel.id,
//               androidChannel.name,
//               playSound: true, importance: Importance.high,
//               channelDescription: androidChannel.description,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: '@mipmap/ic_launcher',
//             ),
//           ),
//           payload: jsonEncode(message.toMap()));
//     });
//   }

//   Future initLocalNotifications() async {
//     const ios = DarwinInitializationSettings(
//       requestSoundPermission: false,
//       requestBadgePermission: false,
//       requestAlertPermission: false,
//     );
//     const android = AndroidInitializationSettings("@mipmap/ic_launcher");
//     const settings = InitializationSettings(android: android, iOS: ios);
//     await flutterLocalNotificationsPlugin.initialize(settings,
//         onDidReceiveNotificationResponse: (response) {
//       final message = RemoteMessage.fromMap(jsonDecode(response.payload ?? ""));
//       handleMessage(message);
//     });
//     final platfrom =
//         flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();
//     await platfrom?.createNotificationChannel(androidChannel);
//   }

//   Future<String> initNotifications() async {
//     await _firebaseMessaging.requestPermission();
//     final fcmToken = await _firebaseMessaging.getToken();
//     print("======fcm token $fcmToken");
//     // FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
//     await initPushNotifications();
//     await initLocalNotifications();
//     return fcmToken ?? "";
//   }
// }

// Future<bool> sendPushMessage({
//   required String title,
//   required String body,
//   required String? token,
//   required bool isToken,
// }) async {
//   // final accountCredentials =
//   //     ServiceAccountCredentials.fromJson(serviceAccountKeyJson);
//   // final client = await clientViaServiceAccount(
//   //   accountCredentials,
//   //   ['https://www.googleapis.com/auth/cloud-platform'],
//   // );
//   final jsonCredentials = await rootBundle.loadString(
//       'assets/pei-sindh-54068-firebase-adminsdk-f4oyq-e8d1479744.json');
//   final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

//   final client = await auth.clientViaServiceAccount(
//     creds,
//     ['https://www.googleapis.com/auth/cloud-platform'],
//   );
//   final notificationData = {
//     'message': {
//       if (isToken) 'token': token else 'topic': token,
//       'notification': {'title': title, 'body': body},
//     },
//   };
//   final response = await client.post(
//     Uri.parse('https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
//     headers: {
//       'content-type': 'application/json',
//     },
//     body: jsonEncode(notificationData),
//   );

//   client.close();
//   if (response.statusCode == 200) {
//     devtools.log('Notification Sent: ${response.statusCode}, ${response.body}');
//     return true; // Success!
//   }
//   devtools.log('Notification Sent: ${response.statusCode}, ${response.body}');
//   return false;
// }

// // Future<void> requestExactAlarmPermission(BuildContext context) async {
// //   if (Platform.isAndroid) {
// //     final androidVersion =
// //         int.parse(Platform.operatingSystemVersion.split(' ')[0]);
// //     if (androidVersion >= 12) {
// //       final intent = AndroidIntent(
// //         action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
// //         package: 'com.pei.eoc', // Replace with your app's package name
// //       );
// //       await intent.launch();
// //     } else {
// //       // Not Android 12 or above, no special handling required.
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //             content: Text(
// //                 'Exact alarm permission is not required for this Android version.')),
// //       );
// //     }
// //   }
// // }

// // int getAndroidVersion() {
// //   if (Platform.isAndroid) {
// //     final versionString = Platform.operatingSystemVersion;
// //     // Extract numeric part of the version using a regular expression
// //     final match = RegExp(r'\d+').firstMatch(versionString);
// //     if (match != null) {
// //       return int.parse(match.group(0)!); // Get the first numeric match
// //     }
// //   }
// //   return -1; // Return -1 if the version cannot be determined
// // }

// // Future<void> scheduleReminderAt4PM(BuildContext context) async {
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   final androidVersion = getAndroidVersion();
// //   if (androidVersion >= 12) {
// //     final granted = await flutterLocalNotificationsPlugin
// //             .resolvePlatformSpecificImplementation<
// //                 AndroidFlutterLocalNotificationsPlugin>()
// //             ?.areNotificationsEnabled() ??
// //         false;

// //     if (!granted) {
// //       await requestExactAlarmPermission(context);
// //       return;
// //     }
// //   }

// //   tz.initializeTimeZones();
// //   tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

// //   final now = tz.TZDateTime.now(tz.local);
// //   tz.TZDateTime scheduledDate = tz.TZDateTime(
// //     tz.local,
// //     now.year,
// //     now.month,
// //     now.day,
// //     21, // 4:00 PM
// //     22,
// //   );

// //   if (scheduledDate.isBefore(now)) {
// //     scheduledDate = scheduledDate.add(const Duration(days: 1));
// //   }

// //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
// //     'reminder_channel_id',
// //     'Daily Reminders',
// //     channelDescription: 'Reminders for specific times',
// //     importance: Importance.high,
// //     priority: Priority.high,
// //   );

// //   const NotificationDetails notificationDetails =
// //       NotificationDetails(android: androidDetails);

// //   print('Scheduling notification for: $scheduledDate');

// //   await flutterLocalNotificationsPlugin.zonedSchedule(
// //     0,
// //     'Reminder',
// //     'This is your 4:00 PM reminder.',
// //     scheduledDate,
// //     notificationDetails,
// //     // androidAllowWhileIdle: true,
// //     androidScheduleMode: AndroidScheduleMode.alarmClock,
// //     uiLocalNotificationDateInterpretation:
// //         UILocalNotificationDateInterpretation.absoluteTime,
// //     matchDateTimeComponents: DateTimeComponents.time,
// //   );
// // }

// Future<void> sendLocalNotification({
//   required int id,
//   required String title,
//   required String body,
// }) async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   // Notification details
//   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//     'test_channel_id', // Channel ID
//     'Test Notifications', // Channel Name
//     channelDescription: 'This channel is for testing notifications',
//     importance: Importance.high,
//     priority: Priority.high,
//   );

//   const NotificationDetails notificationDetails =
//       NotificationDetails(android: androidDetails);

//   // Trigger the notification
//   await flutterLocalNotificationsPlugin.show(
//       id, title, body, notificationDetails);
// }
