import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/finalpage.dart';
import 'package:flutter_biometric/Screens/loginRedirect.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/logout.dart';
import 'package:flutter_biometric/Screens/signUp_view.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:flutter_biometric/authentication.dart';
import 'package:flutter_biometric/main.dart';
import 'package:quickalert/quickalert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/user_repository.dart';

class SecondPage extends StatelessWidget {
  SecondPage({super.key});
  final _db = FirebaseFirestore.instance;

  var screen_no = 0;
  DateTime pre_backpress = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //   final timegap = DateTime.now().difference(pre_backpress);
        //   final cantExit = timegap >= Duration(seconds: 3);
        //   pre_backpress = DateTime.now();
        //   if (cantExit) {
        //     //show snackbar
        //     final snack = SnackBar(
        //       content: Text('Press Back button again to Exit'),
        //       duration: Duration(seconds: 3),
        //     );
        //     ScaffoldMessenger.of(context).showSnackBar(snack);
        //     return false;
        //   } else {
        //     return true;
        //   }
        // final value = await QuickAlert.show(
        //   context: context,
        //   type: QuickAlertType.confirm,
        //   title: "Alert",
        //   text: 'Do you want to exit?',
        //   confirmBtnText: "Yes",
        //   cancelBtnText: "No",
        //   onConfirmBtnTap: () => {Navigator.of(context).pop(true)},
        //   onCancelBtnTap: () => {Navigator.of(context).pop()},
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0.0,
          title: const Text('Authentication'),
          automaticallyImplyLeading: false,
        ),
        // const SizedBox(height: 20);
        body: SizedBox(
            // height: 20,
            width: double.infinity,
            child: Center(
              child: ElevatedButton(
                onPressed: () async {
                  final FirebaseFirestore firestore =
                      FirebaseFirestore.instance;

                  bool isAuthenticated =
                      await Authentication.authenticateWithBiometrics();

                  if (isAuthenticated) {
                    var sharedPref = await SharedPreferences.getInstance();
                    final session_no =
                        sharedPref.getString("session_mobile") ?? '';

                    if (kDebugMode) {
                      print(session_no);
                    }

                    final QuerySnapshot querySnapshot = await firestore
                        .collection("Users")
                        .where("Mobile", isEqualTo: session_no)
                        .get();

                    if (querySnapshot.size > 0) {
                      // Retrieve the document ID of the first document in the query snapshot
                      final DocumentSnapshot documentSnapshot =
                          querySnapshot.docs[0];
                      final String documentId = documentSnapshot.id;
                      _db
                          .collection("Users")
                          .doc(documentId)
                          .update({"Notify": true});
                    }

                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FinalPage(
                                  title: 'Authentication from secondscreen',
                                )));
                    // QuickAlert.show(
                    //   context: context,
                    //   type: QuickAlertType.success,
                    //   title: 'Congratulations',
                    //   text: 'User logged in successfully',
                    //   confirmBtnText: "Ok",
                    //   onConfirmBtnTap: () => {
                    //     Navigator.pushReplacement(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => const RootPage())
                    //     )
                    //   },
                    // );
                  } else {
                    var sharedPref = await SharedPreferences.getInstance();
                    final session_no =
                        sharedPref.getString("session_mobile") ?? '';

                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: 'Invalid fingerprint',
                      text: 'Try again next time!!!',
                      confirmBtnText: "Ok",
                      onConfirmBtnTap: () => {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPage(
                                      session_no: session_no,
                                    )))
                      },
                    );
                  }
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
                  backgroundColor:
                      const MaterialStatePropertyAll<Color>(Colors.green),

                  // height: 100;
                ),
                child: const Text("Approve"),
              ),
            )),
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
}
