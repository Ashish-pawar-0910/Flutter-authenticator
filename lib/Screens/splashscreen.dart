import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class splash extends StatefulWidget {
  const splash({super.key});

  @override
  State<splash> createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
    // LoginViewState.whereToGo();
  }

  _navigateToHome() async {
    var sharedPref = await SharedPreferences.getInstance();
    final session_no = sharedPref.getString("session_mobile") ?? '';

    var isLoggedIn = sharedPref.getBool(LoginViewState.KEYLOGIN);
    await Future.delayed(Duration(seconds: 5), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => UserPage(session_no: session_no)));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginView()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginView()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size;
    return Scaffold(
      body: Container(
        color: Color.fromARGB(255, 115, 231, 115),
        child: Column(
          children: [
            SizedBox(
              height: 200,
            ),
            Center(
              child: Lottie.asset(
                'assets/images/splash2.json',
                height: 400,
                width: 400,
                fit: BoxFit.fill,
              ),
            ),
            // Center(
            //   child: Text("Welcome"),
            // ),
          ],
        ),
      ),
    );
  }
}
