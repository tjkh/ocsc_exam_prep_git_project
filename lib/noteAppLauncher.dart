// // เรียกใช้ แอปข้างนอก -- ยังไม่ทำงาน
 import 'package:flutter/material.dart';
// import 'package:android_intent_plus/android_intent.dart';
// import 'package:android_intent_plus/flag.dart';
//
 class NoteAppLauncher {
//   static Future<void> launchNoteApp(BuildContext context) async {
//     try {
//       final intent = AndroidIntent(
//         action: 'android.intent.action.MAIN',
//         category: 'android.intent.category.APP_NOTE',
//         flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
//       );
//       await intent.launch();
//     } catch (e) {
//       _showNoAppDialog(context);
//     }
//   }
//
//   static void _showNoAppDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('No Note App Available'),
//           content: Text('No note app available. Please install one on Play Store.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
 }
//
//
//
//
// // import 'package:android_intent_plus/android_intent.dart';
// // import 'package:android_intent_plus/flag.dart';
// //
// // class NoteAppLauncher {
// //   void open() {
// //     final intent = AndroidIntent(
// //       action: 'android.intent.action.SEND',
// //       type: 'text/plain',
// //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
// //     );
// //
// //     try {
// //       intent.launch();
// //     } catch (error) {
// //       print('Error launching note app: $error');
// //     }
// //   }
// // }
//
//
//
// // import 'package:android_intent_plus/android_intent.dart';
// // import 'package:android_intent_plus/flag.dart';
// //
// // class NoteAppLauncher {
// //   final String packageName;
// //
// //   NoteAppLauncher({
// //     required this.packageName,
// //   });
// //
// //   void open() {
// //     final intent = AndroidIntent(
// //       action: 'android.intent.action.MAIN',
// //       package: packageName,
// //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
// //     );
// //
// //     intent.launch().catchError((error) {
// //       // Handle error if the app is not installed or if there is any other issue
// //       print('Error opening note app: $error');
// //     });
// //   }
// // }
//
//
//
//
// // import 'package:android_intent_plus/android_intent.dart';
// // import 'package:android_intent_plus/flag.dart';
// //
// // class NoteAppLauncher {
// //   final String packageName;
// //
// //   NoteAppLauncher({
// //     required this.packageName,
// //   });
// //
// //   void open() {
// //     final intent = AndroidIntent(
// //       action: 'android.intent.action.MAIN',
// //       package: packageName,
// //       componentName: 'com.android.notes/.MainActivity', // Replace with the correct component name if necessary
// //       flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
// //     );
// //
// //     intent.launch().catchError((error) {
// //       // Handle error if the app is not installed or if there is any other issue
// //       print('Error opening note app: $error');
// //     });
// //   }
// // }
//
//
