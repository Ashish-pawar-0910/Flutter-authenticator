import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_view.dart';

class UserPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  UserPage({super.key, required this.session_no});

  final String session_no;

  @override
  State<UserPage> createState() => UserPageState(session_no: this.session_no);
}

class UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  UserPageState({required this.session_no});
  final String session_no;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.repeat();
    if (kDebugMode) {
      print(session_no);
    }

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
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginView()));
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

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
      }
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var sharedPref = await SharedPreferences.getInstance();

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
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
          appBar: AppBar(
            backgroundColor: Colors.green,
            elevation: 0.0,
            title: const Text('Biometric Authenticator'),
            automaticallyImplyLeading: false,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: const Text(
                'User Profile',
                style: TextStyle(
                  fontFamily: "Fredoka",
                  // fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              )),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  'assets/images/user1.png',
                  width: 100,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Center(
                  child: Text(
                'Mobile: +91$session_no',
                style: TextStyle(
                  fontFamily: "Tilt",
                  color: Colors.transparent,
                  // fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [Shadow(color: Colors.black, offset: Offset(0, -5))],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.green,
                  decorationThickness: 3,
                ),
              )),
              SizedBox(
                height: 25,
              ),
              Center(
                  child: const Text(
                'You are logged in',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )),
              Center(
                child: Lottie.asset(
                  'assets/images/fingerprint.json',
                  height: 250,
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      var sharedPref = await SharedPreferences.getInstance();
                      sharedPref.setBool(LoginViewState.KEYLOGIN, false);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginView()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      minimumSize:
                          MaterialStateProperty.all(const Size(120, 30)),
                      textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 20),
                      ),
                      overlayColor: MaterialStateProperty.all(
                        Colors.blue,
                      ),
                      shadowColor: MaterialStateProperty.all(Colors.yellow),
                      elevation: MaterialStateProperty.all(15),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15)),
                    ),
                    // child: const Text('Scan QR')),
                    child: const Text('Logout')),
              ),
            ],
          )),
    );
  }
}
