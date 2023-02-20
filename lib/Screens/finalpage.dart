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

import 'package:flutter/material.dart';
import 'package:flutter_biometric/main.dart';

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

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RootPage())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
