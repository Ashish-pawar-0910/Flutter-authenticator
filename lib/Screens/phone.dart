import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/homepage.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/verify.dart';
import 'package:flutter_biometric/main.dart';
import 'package:flutter_biometric/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../Controller/sign_in_controller.dart';
import '../models/user_model.dart';

class MyPhone extends StatefulWidget {
  static String verify = '';
  static String mobileNo = '';
  static int? forceRT = 0;

  // static String verify = '';

  const MyPhone({Key? key}) : super(key: key);

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  static String phone = '';
  // DateTime pre_backpress = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    // Future<String> _getMockData() async {
    //   var appSignatureID = SmsAutoFill().getAppSignature;
    //   return appSignatureID;
    // }

    // void submit() async {
    //   Future<String> stringFuture = _getMockData();
    //   String message = await stringFuture;
    //   if (kDebugMode) {
    //     print(message);
    //   }
    // }

    // submit();

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
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/phonepage.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Phone Verification",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Enter your mobile number",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countryController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Text(
                        "|",
                        style: TextStyle(fontSize: 33, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: TextField(
                        controller: controller.mobile,
                        onChanged: (value) {
                          phone = value;
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: () async {
                        // Widget okButton1 = TextButton(
                        //   child: const Text("Ok"),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const RootPage()));
                        //   },
                        // );
                        // Widget okButton2 = TextButton(
                        //   child: const Text("Ok"),
                        //   onPressed: () {
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => const RootPage()));
                        //   },
                        // );

                        // // );
                        // AlertDialog invalidNumber = AlertDialog(
                        //   title: const Text("Failure"),
                        //   content:
                        //       const Text("Phone number entered is not valid"),
                        //   actions: [
                        //     okButton1,
                        //   ],
                        // );

                        // AlertDialog registeredAlert = AlertDialog(
                        //   // title: const Text("confirm"),
                        //   title: const Icon(Icons.confirm_amber_outlined),
                        //   content: const Text("User is already Registered!!"),
                        //   actions: [
                        //     okButton2,
                        //   ],
                        // );
                        // showDialog(
                        //     context: context,
                        //     builder: (context) {
                        //       return const Center(
                        //           child: CircularProgressIndicator());
                        //     });
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Processing',
                          text: 'Please wait',
                        );

                        bool checkUser = await UserRepository.instance
                            .checkUserExists(controller.mobile.text.trim());
                        if (!checkUser) {
                          // FirebaseAuth auth = FirebaseAuth.instance;
                          // await auth.setSettings(
                          //     appVerificationDisabledForTesting:
                          //         true); // <-- here is the magic
                          Future<void> otpMethod() async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: countryController.text + phone,
                              timeout: const Duration(seconds: 20),
                              forceResendingToken: MyPhone.forceRT,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                // await FirebaseAuth.instance
                                //     .signInWithCredential(credential);
                              },
                              verificationFailed:
                                  (FirebaseAuthException e) async {
                                if (e.code == 'invalid-phone-number') {
                                  // error = "invalid";
                                  print(
                                      'The provided phone number is not valid.');
                                  Navigator.of(context).pop();
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.error,
                                    title: 'Error',
                                    text: 'Phone number is invalid',
                                    confirmBtnText: "Ok",
                                    onConfirmBtnTap: () =>
                                        {Navigator.of(context).pop()},
                                  );
                                }
                              },
                              codeSent: (String verificationId,
                                  int? forceResendingToken) {
                                MyPhone.verify = verificationId;
                                MyPhone.mobileNo = phone;
                                MyPhone.forceRT = forceResendingToken;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyVerify()));
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {
                                MyPhone.verify = verificationId;
                              },
                            );
                          }

                          otpMethod();
                        } else {
                          Navigator.of(context).pop();
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            title: "",
                            text: 'User already registered ',
                            confirmBtnText: "Ok",
                            onConfirmBtnTap: () =>
                                {Navigator.of(context).pop()},
                          );
                        }

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => const MyVerify()));
                      },
                      child: Text("Send the code")),
                )
              ],
            ),
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
}
