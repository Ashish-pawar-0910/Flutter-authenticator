import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biometric/main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class LogOut extends StatelessWidget {
  const LogOut({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title of the application
      title: 'Hello World Demo Application',
      // theme of the widget
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      // Inner UI of the application
      home: const MyTestPage(title: 'Logout page'),
    );
  }
}

/* This class is similar to MyApp instead it
returns Scaffold Widget */
class MyTestPage extends StatelessWidget {
  const MyTestPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // Sets the content to the
        // center of the application page
        body: Container(
          child: Center(
            child: ElevatedButton(
                onPressed: () async {
                  var sharedPref = await SharedPreferences.getInstance();
                  sharedPref.setBool(HomePageState.KEYLOGIN, false);

                  // ignore: use_build_context_synchronously
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.success,
                    confirmBtnText: "Ok",
                    onConfirmBtnTap: () => {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyApp())),
                      Navigator.of(context, rootNavigator: true).pop()
                    },
                    title: 'Login session ended',
                    text: 'Value reset',
                  );
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
                child: const Text('Reset the value')),
          ),
        ));
  }
}
