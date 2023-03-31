import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/finalpage.dart';
import 'package:flutter_biometric/Screens/homepage.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/phone.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/signUp_view.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:flutter_biometric/Screens/verify.dart';
// import 'package:flutter_biometric/Screens/verify.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/splashscreen.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

Future<void> main() async {
// void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash(),
      // initialRoute: "/home",S
      // define routes here
      routes: {
        "/signup": (context) => const SignUpView(),
        "/login": (context) => const LoginView(),
        "/final": (context) => const FinalPage(
              title: 'route',
            ),
        "/verify": (context) => const MyVerify(),
        "/secondscreen": (context) => SecondPage(),
      },
      // onGenerateRoute: generateRoute,
    );
  }
}

// class RootPage extends StatefulWidget {
//   const RootPage({super.key});

//   @override
//   State<RootPage> createState() => _RootPageState();
// }

// class _RootPageState extends State<RootPage> {
//   int currentPage = 0;
  
//   // DateTime pre_backpress = DateTime.now();

//   // var _context;
//   //  int _counter = 0;

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         final value = await QuickAlert.show(
//           context: context,
//           type: QuickAlertType.confirm,
//           title: "Alert",
//           text: 'Do you want to exit?',
//           confirmBtnText: "Yes",
//           cancelBtnText: "No",
//           onConfirmBtnTap: () => {Navigator.of(context).pop(true)},
//           onCancelBtnTap: () => {Navigator.of(context).pop()},
//         );
//         if (kDebugMode) {
//           print(value);
//         }
//         if (value != null) {
//           return Future.value(value);
//         } else {
//           return Future.value(false);
//         }
//         // final timegap = DateTime.now().difference(pre_backpress);
//         // final cantExit = timegap >= Duration(seconds: 2);
//         // pre_backpress = DateTime.now();
//         // if (cantExit) {
//         //   //show snackbar
//         //   final snack = SnackBar(
//         //     content: Text('Press Back button again to Exit'),
//         //     duration: Duration(seconds: 2),
//         //   );
//         //   ScaffoldMessenger.of(context).showSnackBar(snack);
//         //   return false;
//         // } else {
//         //   return true;
//         // }
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Biometric Authenticator"),
//           automaticallyImplyLeading: false,
//         ),
//         body: HomePage(),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     super.initState();
//     // whereToGo();
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;

//       if (notification != null && android != null) {
//         // flutterLocalNotificationsPlugin.show(
//         //     notification.hashCode,
//         //     notification.title,
//         //     notification.body,
//         //     NotificationDetails(
//         //       android: AndroidNotificationDetails(
//         //         channel.id,
//         //         channel.name,
//         //         channelDescription: channel.description,
//         //         color: Colors.blue,
//         //         playSound: true,
//         //         icon: '@mipmap/ic_launcher',
//         //       ),
//         //     ));
//         showDialog(
//           context: context,
//           builder: (ctx) => AlertDialog(
//             // title: Row(children:[Text: "Authentication required!"]),
//             //
//             title: Row(children: [
//               Image.asset(
//                 "assets/images/authentication.png",
//                 width: 50,
//                 height: 50,
//                 fit: BoxFit.contain,
//               ),
//               const Text(
//                 "Authentication request!",
//                 style: TextStyle(color: Colors.black),
//               )
//             ]),
//             content: const Text(
//                 "Please click on the below button for authentication"),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (context) => SecondPage()));
//                 },
//                 child: Container(
//                   color: Colors.blue[300],
//                   padding: const EdgeInsets.all(14),
//                   child: const Text(
//                     "Proceed",
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }
//     });

//     // Future<String?> getUserId(Future<String?> id) async {
//     //   final db = FirebaseFirestore.instance;
//     //   final snapshot =
//     //       await db.collection("Users").where("id", isEqualTo: id).get();
//     //   final userData =
//     //       snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
//     //   // print(userData);
//     //   return userData.id;
//     // }

//     // Future<String?> fcmToken = FirebaseMessaging.instance.getToken();

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       if (kDebugMode) {
//         print('A new onMessageOpenedApp event was published!');
//       }
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null) {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => SecondPage()));
//       }
//     });
//   }

//   // void toast(BuildContext context, String text) {
//   //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//   //       content: Text(
//   //         text,
//   //         textAlign: TextAlign.center,
//   //       ),
//   //       behavior: SnackBarBehavior.floating,
//   //       shape:
//   //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))));
//   // }

//   // Future<bool> onBackButtonDoubleClicked(BuildContext context) async {
//   //   final difference = DateTime.now().difference(backPressedTime);
//   //   backPressedTime = DateTime.now();

//   //   if (difference >= const Duration(seconds: 2)) {
//   //     toast(context, "Click Again to Close The App ");
//   //     return false;
//   //   } else {
//   //     SystemNavigator.pop(animated: true);
//   //     return true;
//   //   }
//   // }
 
// }
