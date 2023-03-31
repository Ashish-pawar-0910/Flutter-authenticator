import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/loginRedirect.dart';
import 'package:flutter_biometric/Screens/logout.dart';
import 'package:flutter_biometric/Screens/phone.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/sign_in.dart';
import 'package:flutter_biometric/main.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'finalpage.dart';

class HomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static const String KEYLOGIN = " ";

  // DateTime pre_backpress = DateTime.now();
  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  Future<void> whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();

    var isLoggedIn = sharedPref.getBool(KEYLOGIN);

    if (kDebugMode) {
      print(isLoggedIn);
    }

    Timer(const Duration(seconds: 2), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SecondPage()));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LogApp()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LogApp()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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

        final value = await QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          title: "Alert",
          text: 'Do you want to exit?',
          confirmBtnText: "Yes",
          cancelBtnText: "No",
          onConfirmBtnTap: () => {Navigator.of(context).pop(true)},
          onCancelBtnTap: () => {Navigator.of(context).pop()},
        );
        if (kDebugMode) {
          print(value);
        }
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) {
                  // return const SignIn();
                  return const MyPhone();
                },
              ));
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(const Size(150, 30)),
              textStyle: MaterialStateProperty.all(
                const TextStyle(fontSize: 25),
              ),
              overlayColor: MaterialStateProperty.all(
                Colors.cyan,
              ),
              shadowColor: MaterialStateProperty.all(Colors.yellow),
              elevation: MaterialStateProperty.all(15),
              padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
            ),
            // child: const Text('Scan QR')),
            child: const Text('Sign Up')),
      ),
    );
  }
}
