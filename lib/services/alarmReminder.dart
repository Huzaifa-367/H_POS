// // ignore_for_file: depend_on_referenced_packages, avoid_print

// import 'package:alarm/alarm.dart';
// import 'package:eoc_sindh/Utils/Utils.dart';
// import 'package:eoc_sindh/services/notification_services.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'dart:io';

// Future<void> setRecurringAlarms(context) async {
//   tz.initializeTimeZones();
//   tz.setLocalLocation(tz.getLocation('Asia/Karachi'));

//   // Check "Schedule Exact Alarm" permission (Android 12+) before setting the alarm
//   final status = await Permission.scheduleExactAlarm.status;
//   print('Schedule exact alarm permission: $status.');

//   if (status.isDenied) {
//     print('Requesting schedule exact alarm permission...');
//     final res = await Permission.scheduleExactAlarm.request();

//     if (!res.isGranted) {
//       print('Schedule exact alarm permission not granted.');
//       return; // Stop if permission is not granted
//     }
//   }

//   final now = tz.TZDateTime.now(tz.local);
//   tz.TZDateTime firstAlarm = tz.TZDateTime(
//     tz.local,
//     now.year,
//     now.month,
//     now.day,
//     16, // Start at 4:00 PM
//     0,
//   );

//   if (now.isAfter(firstAlarm)) {
//     // If the current time is past 4:00 PM, do not schedule alarms
//     print('Current time is past 4:00 PM. Alarms will not be scheduled.');
//     return;
//   }

//   for (int i = 0; i < 20; i++) {
//     // Schedule alarms for 10 hours (20 alarms, 30 min apart)
//     final scheduledTime = firstAlarm.add(Duration(minutes: i * 30));

//     final alarmSettings = AlarmSettings(
//       id: i + 1, // Unique ID for each alarm
//       dateTime: scheduledTime,
//       assetAudioPath: 'assets/alarm.mp3',
//       loopAudio: true,
//       vibrate: true,
//       volume: 0.8,
//       fadeDuration: 3.0,
//       warningNotificationOnKill: Platform.isIOS,
//       androidFullScreenIntent: true,
//       notificationSettings: const NotificationSettings(
//         title: 'Check Out Reminder',
//         body: 'Please don\'t forget to mark attendance!',
//         stopButton: 'Stop the alarm',
//         icon: 'notification_icon', // Add the icon to `res/drawable` for Android
//       ),
//     );

//     // Schedule each alarm
//     try {
//       await Alarm.set(alarmSettings: alarmSettings).then(
//         (value) async {
//           if (i == 0) {
//             // Send notification only for the first alarm setup
//             sendLocalNotification(
//               id: 3,
//               title: "Alert!",
//               body: "Recurring reminders set starting from 4:00 PM",
//             );
//           }
//         },
//       ).catchError((error) {
//         Utils.toastMessage(
//           title: "Error setting reminder: $error",
//           type: ToastType.error,
//           context: context,
//         );
//       });
//     } catch (e) {
//       print('Error occurred while setting alarm: $e');
//     }
//   }
// }

// Future<void> cancelAllAlarms() async {
//   try {
//     await Alarm.stopAll();
//     print('All alarms have been canceled.');
//   } catch (e) {
//     print('Error occurred while canceling alarms: $e');
//   }
// }
