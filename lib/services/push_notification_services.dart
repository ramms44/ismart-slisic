// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotificationServices {
//   //
//   final FirebaseMessaging _fcm = FirebaseMessaging();

//   Future initialize() async {
//     //
//     if (Platform.isIOS) {
//       //
//       _fcm.requestNotificationPermissions(IosNotificationSettings());
//     }

//     _fcm.configure(
//       // Called when the app is in the foreground and we receive a push notification
//       onMessage: (Map<String, dynamic> message) async {
//         // Called whe the app has been closed completely and it's opened
//         print('onMessage: $message');
//       }, //
//       onLaunch: (Map<String, dynamic> message) async {
//         //
//         print('onLaunch: $message');
//       }, //
//       onResume: (Map<String, dynamic> message) async {
//         //
//         print('onResume: $message');
//       },
//     );
//   }
// }
