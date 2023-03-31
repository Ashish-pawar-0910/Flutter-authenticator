// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class RoutedScreen extends StatelessWidget {
//   const RoutedScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Splash Screen Example")),
//       body: const Center(
//           child: Text("Welcome to Home Page",
//               style: TextStyle(color: Colors.black, fontSize: 30))),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/homepage.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/signUp_view.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:flutter_biometric/main.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'home_button.dart';

class FinalPage extends StatefulWidget {
  const FinalPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<FinalPage> createState() => _FinalPageState();
}

Color themeColor = const Color(0xFF43D19E);

class _FinalPageState extends State<FinalPage> {
  double screenWidth = 600;
  double screenHeight = 400;
  Color textColor = const Color(0xFF32567A);
  // DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // final timegap = DateTime.now().difference(pre_backpress);
        // final cantExit = timegap >= Duration(seconds: 3);
        // pre_backpress = DateTime.now();
        // if (cantExit) {
        //   //show snackbar
        //   final snack = SnackBar(
        //     content: Text('Press Back button again to Exit'),
        //     duration: Duration(seconds: 3),
        //   );
        //   ScaffoldMessenger.of(context).showSnackBar(snack);
        //   return false;
        // } else {
        //   return true;
        // }
        // final value = await QuickAlert.show(
        //   context: context,
        //   type: QuickAlertType.confirm,
        //   title: "Alert",
        //   text: 'Do you want to exit?',
        //   confirmBtnText: "Yes",
        //   cancelBtnText: "No",
        //   onConfirmBtnTap: () => {Navigator.of(context).pop()},
        //   onCancelBtnTap: () => {},
        // );
        // if (kDebugMode) {
        //   print(value);
        // }
        // if (value != null) {
        //   return Future.value(value);
        // } else {
        //   return Future.value(false);
        // }
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 170,
                padding: EdgeInsets.all(35),
                decoration: BoxDecoration(
                  color: themeColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  "assets/images/lock2.png",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Text(
                "Thank You!",
                style: TextStyle(
                  color: themeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Authentication done Successfully",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Click here to return to home page",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: screenHeight * 0.06),
              Flexible(
                child: ElevatedButton(
                    child: const Text('Go to home page'),
                    onPressed: () async {
                      var sharedPref = await SharedPreferences.getInstance();
                      final session_no =
                          sharedPref.getString("session_mobile") ?? '';
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => UserPage(
                                session_no: session_no,
                              )));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void toast(BuildContext context, String text) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(
  //         text,
  //         textAlign: TextAlign.center,
  //       ),
  //       behavior: SnackBarBehavior.floating,
  //       shape:
  //           RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0))));
  // }

  // Future<bool> onBackButtonDoubleClicked(BuildContext context) async {
  //   final difference = DateTime.now().difference(backPressedTime);
  //   backPressedTime = DateTime.now();

  //   if (difference >= const Duration(seconds: 2)) {
  //     toast(context, "Click Again to Close The App ");
  //     return false;
  //   } else {
  //     SystemNavigator.pop(animated: true);
  //     return true;
  //   }
  // }
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
                onPressed: () async {
                  var sharedPref = await SharedPreferences.getInstance();

                  // var sharedPref = await SharedPreferences.getInstance();
                  final session_no =
                      sharedPref.getString("session_mobile") ?? '';

                  var isLoggedIn = sharedPref.getBool(LoginViewState.KEYLOGIN);

                  if (kDebugMode) {
                    print(isLoggedIn);
                  }

                  if (isLoggedIn != null) {
                    if (isLoggedIn) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage()));
                    }
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserPage(
                                  session_no: session_no,
                                )));
                  }
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var sharedPref = await SharedPreferences.getInstance();
      final session_no = sharedPref.getString("session_mobile") ?? '';

      var isLoggedIn = sharedPref.getBool(LoginViewState.KEYLOGIN);

      if (kDebugMode) {
        print(isLoggedIn);
      }

      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SecondPage()));
        }
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserPage(
                      session_no: session_no,
                    )));
      }
    });
  }
}
