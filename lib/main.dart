
import 'package:flutter_biometric/Screens/homepage.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

// class FirebaseService {
//   static FirebaseMessaging? _firebaseMessaging;
//   static FirebaseMessaging get firebaseMessaging =>
//       FirebaseService._firebaseMessaging ?? FirebaseMessaging.instance;

//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     FirebaseService._firebaseMessaging = FirebaseMessaging.instance;
//     await FirebaseService.initializeLocalNotifications();
//     await FCMProvider.onMessage();
//     await FirebaseService.onBackgroundMsg();
//   }

//   Future<String?> getDeviceToken() async =>
//       await FirebaseMessaging.instance.getToken();

//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initializeLocalNotifications() async {
//     const InitializationSettings _initSettings = InitializationSettings(
//       android: AndroidInitializationSettings("icon_name"),
//       // iOS: DarwinInitializationSettings()
//     );

//     /// on did receive notification response = for when app is opened via notification while in foreground on android
//     await FirebaseService._localNotificationsPlugin.initialize(_initSettings,
//         onDidReceiveNotificationResponse: FCMProvider.onTapNotification);

//     /// need this for ios foregournd notification
//     await FirebaseService.firebaseMessaging
//         .setForegroundNotificationPresentationOptions(
//       alert: true, // Required to display a heads up notification
//       badge: true,
//       sound: true,
//     );
//   }

//   static NotificationDetails platformChannelSpecifics =
//       const NotificationDetails(
//     android: AndroidNotificationDetails(
//       "high_importance_channel",
//       "High Importance Notifications",
//       priority: Priority.max,
//       importance: Importance.max,
//     ),
//   );

//   // for receiving message when app is in background or foreground
//   static Future<void> onMessage() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       if (Platform.isAndroid) {
//         // if this is available when Platform.isIOS, you'll receive the notification twice
//         await FirebaseService._localNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           FirebaseService.platformChannelSpecifics,
//           payload: message.data.toString(),
//         );
//       }
//     });
//   }

//   static Future<void> onBackgroundMsg() async {
//     FirebaseMessaging.onBackgroundMessage(FCMProvider.backgroundHandler);
//   }
// }

// class FCMProvider with ChangeNotifier {
//   static BuildContext? _context;
//   final _db = FirebaseFirestore.instance;

//   // static BuildContext context;
//   static void setContext(BuildContext context) =>
//       FCMProvider._context = context;

//   static Future<String?> getUserId(String? id) async {
//     final db = FirebaseFirestore.instance;
//     final snapshot =
//         await db.collection("Users").where("id", isEqualTo: id).get();
//     final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
//     // print(userData);
//     return userData.id;
//   }

//   /// when app is in the foreground
//   static Future<void> onTapNotification(NotificationResponse? response) async {
//     if (FCMProvider._context == null || response?.payload == null) return;
//     // final Json _data = FCMProvider.convertPayload(response!.payload!);

//     // ignore: unrelated_type_equality_checks
//     String? fcmToken = FirebaseMessaging.instance.getToken() as String?;

//     // ignore: unrelated_type_equality_checks
//     if (FCMProvider.getUserId(fcmToken) == false) {
//       await Navigator.push(
//         _context!,
//         MaterialPageRoute(builder: (context) => const RoutedScreen()),
//       );
//     }
//   }

//   // static Json convertPayload(String payload) {
//   //   final String _payload = payload.substring(1, payload.length - 1);
//   //   List<String> _split = [];
//   //   _payload.split(",")..forEach((String s) => _split.addAll(s.split(":")));
//   //   Json _mapped = {};
//   //   for (int i = 0; i < _split.length + 1; i++) {
//   //     if (i % 2 == 1)
//   //       _mapped.addAll({_split[i - 1].trim().toString(): _split[i].trim()});
//   //   }
//   //   return _mapped;
//   // }

//   static Future<void> onMessage() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       // if (FCMProvider._refreshNotifications != null) await FCMProvider._refreshNotifications!(true);
//       // if this is available when Platform.isIOS, you'll receive the notification twice
//       if (Platform.isAndroid) {
//         await FirebaseService._localNotificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           FirebaseService.platformChannelSpecifics,
//           payload: message.data.toString(),
//         );
//       }
//     });
//   }

//   static Future<void> backgroundHandler(RemoteMessage message) async {
//     Stream<RemoteMessage> _stream = FirebaseMessaging.onMessageOpenedApp;
//     _stream.listen((RemoteMessage event) async {
//       // ignore: unnecessary_null_comparison
//       if (event.data != null) {
//         // await Navigator.of(_context!).push('/display');
//         await Navigator.push(
//           _context!,
//           MaterialPageRoute(builder: (context) => const RoutedScreen()),
//         );
//       }
//     });
//   }
// }

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   print('Handling a background message ${message.messageId}');
// }

// late AndroidNotificationChannel channel;
// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'high_importance_channel', // id
//     'High Importance Notifications', // title
//     description:
//         'This channel is used for important notifications.', // description
//     importance: Importance.high,
//   );

//   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   AndroidNotification? android = message.notification?.android;
//   if (notification != null && android != null && !kIsWeb) {
//     flutterLocalNotificationsPlugin.show(
//       notification.hashCode,
//       notification.title,
//       notification.body,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           channel.id,
//           channel.name,
//           channelDescription: channel.description,
//           icon: 'launch_background',
//         ),
//       ),
//     );
//   }
// }

// late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
// void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // const AndroidInitializationSettings initializationSettingsAndroid =
  //     AndroidInitializationSettings("@mipmap/ic_launcher");
  // // ignore: prefer_typing_uninitialized_variables
  // var onDidReceiveLocalNotification;
  // final IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //         onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  // final InitializationSettings initializationSettings = InitializationSettings(
  //     android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //     onSelectNotification: onSelectNotification);
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // if (!kIsWeb) {
  //   await setupFlutterNotifications();
  // }
  runApp(const MyApp());
}

// Future<void> onSelectNotification(String? payload) async {
//   if (payload != null) {
//     // Trigger local authentication flow
//   }
// }

// Future<void> onDidReceiveLocalNotification(String? payload) async {
//   if (payload != null) {
//     // Trigger local authentication flow
//   }
// }

// Future<void> showNotification() async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//           'your channel id', 'your channel name', 'your channel description',
//           importance: Importance.max, priority: Priority.high);
//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);
//   await flutterLocalNotificationsPlugin.show(
//       0, 'New message', 'Hello Flutter!', platformChannelSpecifics,
//       payload: 'trigger-local-authentication');
// }
// class Profile {
//   final String name;

//   const Profile({required this.name});

//   factory Profile.fromJson(Map<String, dynamic> json) {
//     return Profile(
//       name: json['name'],
//     );
//   }
// }
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Messaging Example App',
//       theme: ThemeData.dark(),
//       routes: {
//         '/': (context) => AuthenticatorApp(),
//         '/message': (context) => MessageView(),
//       },
//     );
//   }
// }

// int _messageCount = 0;
// String constructFCMPayload(String? token) {
//   _messageCount++;
//   return jsonEncode({
//     'token': token,
//     'data': {
//       'via': 'FlutterFire Cloud Messaging!!!',
//       'count': _messageCount.toString(),
//     },
//     'notification': {
//       'title': 'Hello FlutterFire!',
//       'body': 'This notification (#$_messageCount) was created via FCM!',
//     },
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const Authenticate(),

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const RootPage(),
      // routes: <String, WidgetBuilder>{
      //   '/display': (BuildContext context) => const FinalPage(),
      // },
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;

  // var _context;
  //  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Biometric Authenticator"),
      ),
      body: const HomePage(),
      // bottomNavigationBar: NavigationBar(
      //   destinations: const [
      //     NavigationDestination(icon: Icon(Icons.home_filled), label: 'Home'),
      //     NavigationDestination(icon: Icon(Icons.person), label: "Sign Up"),
      //   ],
      //   onDestinationSelected: (int index) {
      //     setState(() {
      //       currentPage = index;
      //     });
      //   },
      //   selectedIndex: currentPage,
      // ),
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        // flutterLocalNotificationsPlugin.show(
        //     notification.hashCode,
        //     notification.title,
        //     notification.body,
        //     NotificationDetails(
        //       android: AndroidNotificationDetails(
        //         channel.id,
        //         channel.name,
        //         channelDescription: channel.description,
        //         color: Colors.blue,
        //         playSound: true,
        //         icon: '@mipmap/ic_launcher',
        //       ),
        //     ));
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            // title: Row(children:[Text: "Authentication required!"]),
            //
            title: Row(children: [
              Image.asset(
                "assets/images/authentication.png",
                width: 50,
                height: 50,
                fit: BoxFit.contain,
              ),
              const Text(
                "Authentication request!",
                style: TextStyle(color: Colors.black),
              )
            ]),
            content: const Text(
                "Please click on the below button for authentication"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondPage()));
                },
                child: Container(
                  color: Colors.blue[300],
                  padding: const EdgeInsets.all(14),
                  child: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });

    // Future<String?> getUserId(Future<String?> id) async {
    //   final db = FirebaseFirestore.instance;
    //   final snapshot =
    //       await db.collection("Users").where("id", isEqualTo: id).get();
    //   final userData =
    //       snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    //   // print(userData);
    //   return userData.id;
    // }

    // Future<String?> fcmToken = FirebaseMessaging.instance.getToken();

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SecondPage()));
      }
    });
  }
}
      // ignore: empty_statements


    // void showNotification() {
    //   setState(() {
    //     _counter++;
    //   });
    //   flutterLocalNotificationsPlugin.show(
    //       0,
    //       "Testing $_counter",
    //       "How you doin ?",
    //       NotificationDetails(
    //           android: AndroidNotificationDetails(channel.id, channel.name,
    //               channelDescription: channel.description,
    //               importance: Importance.high,
    //               color: Colors.blue,
    //               playSound: true,
    //               icon: '@mipmap/ic_launcher')));
    // }
  
// class _MyApp extends State<MyApp> {
//   // It is assumed that all messages contain a data field with the key 'type'
//   String? _token;
//   String? initialMessage;
//   bool _resolved = false;
//   @override
//   void initState() {
//     super.initState();

//     // Run code required to handle interacted messages in an async function
//     // as initState() must not be async
//     FirebaseMessaging.instance.getInitialMessage().then(
//           (value) => setState(
//             () {
//               _resolved = true;
//               initialMessage = value?.data.toString();
//             },
//           ),
//         );

//     FirebaseMessaging.onMessage.listen(showFlutterNotification);

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       Navigator.pushNamed(
//         context,
//         '/message',
//         arguments: MessageArguments(message, true),
//       );
//     });
//   }

//   Future<void> sendPushMessage() async {
//     if (_token == null) {
//       print('Unable to send FCM message, no token exists.');
//       return;
//     }

//     try {
//       await http.post(
//         Uri.parse('https://api.rnfirebase.io/messaging/send'),
//         // Uri.parse('https://localhost:7068/api/notification/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: constructFCMPayload(_token),
//       );
//       print('FCM request for device sent!');
//     } catch (e) {
//       print(e);
//     }
//   }

//   Future<void> onActionSelected(String value) async {
//     switch (value) {
//       case 'subscribe':
//         {
//           print(
//             'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
//           );
//           await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
//           print(
//             'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
//           );
//         }
//         break;
//       case 'unsubscribe':
//         {
//           print(
//             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
//           );
//           await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
//           print(
//             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
//           );
//         }
//         break;
//       case 'get_apns_token':
//         {
//           if (defaultTargetPlatform == TargetPlatform.iOS ||
//               defaultTargetPlatform == TargetPlatform.macOS) {
//             print('FlutterFire Messaging Example: Getting APNs token...');
//             String? token = await FirebaseMessaging.instance.getAPNSToken();
//             print('FlutterFire Messaging Example: Got APNs token: $token');
//           } else {
//             print(
//               'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
//             );
//           }
//         }
//         break;
//       default:
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cloud Messaging'),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: onActionSelected,
//             itemBuilder: (BuildContext context) {
//               return [
//                 const PopupMenuItem(
//                   value: 'subscribe',
//                   child: Text('Subscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'unsubscribe',
//                   child: Text('Unsubscribe to topic'),
//                 ),
//                 const PopupMenuItem(
//                   value: 'get_apns_token',
//                   child: Text('Get APNs token (Apple only)'),
//                 ),
//               ];
//             },
//           ),
//         ],
//       ),
//       floatingActionButton: Builder(
//         builder: (context) => FloatingActionButton(
//           onPressed: sendPushMessage,
//           backgroundColor: Colors.white,
//           child: const Icon(Icons.send),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             MetaCard('Permissions', Permissions()),
//             MetaCard(
//               'Initial Message',
//               Column(
//                 children: [
//                   Text(_resolved ? 'Resolved' : 'Resolving'),
//                   Text(initialMessage ?? 'None'),
//                 ],
//               ),
//             ),
//             MetaCard(
//               'FCM Token',
//               TokenMonitor((token) {
//                 _token = token;
//                 return token == null
//                     ? const CircularProgressIndicator()
//                     : SelectableText(
//                         token,
//                         style: const TextStyle(fontSize: 12),
//                       );
//               }),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseMessaging.instance
//                     .getInitialMessage()
//                     .then((RemoteMessage? message) {
//                   if (message != null) {
//                     Navigator.pushNamed(
//                       context,
//                       '/message',
//                       arguments: MessageArguments(message, true),
//                     );
//                   }
//                 });
//               },
//               child: const Text('getInitialMessage()'),
//             ),
//             MetaCard('Message Stream', MessageList()),
//           ],
//         ),
//       ),
//     );
//   }
// }

  /// UI Widget for displaying metadata.
// class MetaCard extends StatelessWidget {
//   final String _title;
//   final Widget _children;

//   // ignore: public_member_api_docs
//   MetaCard(this._title, this._children);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(bottom: 16),
//                 child: Text(_title, style: const TextStyle(fontSize: 18)),
//               ),
//               _children,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // class ChatArguments {
// //   ChatArguments(RemoteMessage message);
// // }

// //   @override
// //   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// // }

// // class Article {
// //   String name;

// //   Article(
// //       {required this.name});

// //   factory Article.fromJson(Map<String, dynamic> json) {
// //     return Article(
// //         name: json["name"],
// //     );

// //   }
// // }

// class Source {
//   String? id;
//   String? name;

//   Source({this.id, this.name});

//   factory Source.fromJson(Map<String, dynamic> json) {
//     return Source(
//       id: json["id"] as String,
//       name: json["name"] as String,
//     );
//   }
// }

