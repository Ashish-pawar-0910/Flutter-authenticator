import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/finalpage.dart';
import 'package:flutter_biometric/Screens/homepage.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/phone.dart';
import 'package:flutter_biometric/Screens/signUp_view.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:flutter_biometric/authentication.dart';
import 'package:flutter_biometric/main.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
// import 'package:pinput/pinput.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../Controller/sign_in_controller.dart';
import '../models/user_model.dart';
// import 'package:sms/sms.dart';
import 'package:telephony/telephony.dart';
import 'login_view.dart';
import 'login_view.dart';

onBackgroundMessage(SmsMessage message) {
  debugPrint("onBackgroundMessage called");
}

class MyVerify extends StatefulWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> with CodeAutoFill {
  // String otpstate = '';
  // int cnt = 0;
  String messageValue = "";
  final telephony = Telephony.instance;
  DateTime pre_backpress = DateTime.now();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController _digit1Controller = TextEditingController();
  final TextEditingController _digit2Controller = TextEditingController();
  final TextEditingController _digit3Controller = TextEditingController();
  final TextEditingController _digit4Controller = TextEditingController();
  final TextEditingController _digit5Controller = TextEditingController();
  final TextEditingController _digit6Controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void codeUpdated() {
    if (kDebugMode) {
      print("Update code $code");
    }
    setState(() {
      if (kDebugMode) {
        print("codeUpdated");
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenOtp();

    // SmsReceiver().onSmsReceived.listen((SmsMessage message) {
    // String pattern =
    //     r'(\d{6}) is your verification code for flutterfirebase-97dc8.firebaseapp.com';
    // RegExp regExp = new RegExp(pattern);
    // Match match = regExp.firstMatch(message.body) as Match;
    // if (match != null) {
    //   String? otp = match.group(1);
    //   print('Received sms: $otp');
    // }
    // });
    initPlatformState();
  }

  onMessage(SmsMessage message) async {
    // String pattern =
    //       r'(\d{6}) is your verification code for flutterfirebase-97dc8.firebaseapp.com';
    //   RegExp regExp = new RegExp(pattern);
    //   Match match = regExp.firstMatch(message.body?) as Match;
    //   if (match != null) {
    //     String? otp = match.group(1);
    //     print('Received sms: $otp');
    //   }
    setState(() {
      messageValue = message.body ?? "Error reading message body.";
      messageValue = messageValue.substring(0, 6);
      if (messageValue.length == 6) {
        _digit1Controller.text = messageValue[0];
        _digit2Controller.text = messageValue[1];
        _digit3Controller.text = messageValue[2];
        _digit4Controller.text = messageValue[3];
        _digit5Controller.text = messageValue[4];
        _digit6Controller.text = messageValue[5];
        _isButtonEnabled = true;
        code = messageValue;
      }
    });
    if (kDebugMode) {
      print('message: $messageValue');
    }
  }

  Future<void> initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  void listenOtp() async {
    // await SmsAutoFill().unregisterListener();
    // listenForCode();
    // await SmsAutoFill().listenForCode;
    SmsAutoFill().listenForCode;
    if (kDebugMode) {
      print("OTP listen Called");
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    if (kDebugMode) {
      print("unregisterListener");
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final defaultPinTheme = PinTheme(
    //   width: 56,
    //   height: 56,
    //   textStyle: TextStyle(
    //       fontSize: 20,
    //       color: Color.fromRGBO(30, 60, 87, 1),
    //       fontWeight: FontWeight.w600),
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
    //     borderRadius: BorderRadius.circular(20),
    //   ),
    // );

    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
    //   borderRadius: BorderRadius.circular(8),
    // );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: defaultPinTheme.decoration?.copyWith(
    //     color: Color.fromRGBO(234, 239, 243, 1),
    //   ),
    // );

    String code = '';
    OtpTimerButtonController controller = OtpTimerButtonController();

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.green,
          automaticallyImplyLeading: false,
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.pop(context);
          //   },
          //   icon: Icon(
          //     Icons.arrow_back_ios_rounded,
          //     color: Colors.black,
          //   ),
          // ),
          // elevation: 0,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 25, right: 25),
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp2.png',
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
                "Enter the OTP received on your phone ",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              // PinFieldAutoFill(
              //   codeLength: 6,
              //   // defaultPinTheme: defaultPinTheme,
              //   // focusedPinTheme: focusedPinTheme,
              //   // submittedPinTheme: submittedPinTheme,
              //   onCodeChanged: (messageValue) {
              //     code = messageValue!;
              //     // print("OTP changed!");
              //     // print(code);
              //   },
              //   // cursor: ,
              //   // ignore: avoid_print
              //   onCodeSubmitted: (pin) => print(pin),
              // ),

              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit1Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit2Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit3Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit4Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit5Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: TextFormField(
                    controller: _digit6Controller,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ]),

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
                    onPressed: _isButtonEnabled
                        ? () async {
                            try {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.loading,
                                title: 'Loading',
                                text: 'Please wait',
                              );

                              // cnt = 2;
                              if (SignUpView.signup_no == 1) {
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: SignUpView.verify,
                                        smsCode: messageValue);
                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);
                                Navigator.of(context).pop();

                                if (await Authentication
                                    .authenticateWithBiometrics()) {
                                  // otpstate = "correct";
                                  var fcmToken = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  // controller.mobile = phone;
                                  final user = UserModel(
                                      id: fcmToken,
                                      mobile: SignUpView.mobileNo);
                                  SignInController.instance.createUser(user);
                                  //Successfully logged In

                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  final session_no =
                                      sharedPref.getString("session_mobile") ??
                                          '';

                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.success,
                                    title: 'Congratulations',
                                    text: 'User registered successfully',
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
                                } else {
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
                                              builder: (context) =>
                                                  const SignUpView()))
                                    },
                                  );
                                }
                              } else if (LoginView.login_no == 1) {
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: LoginView.verify,
                                        smsCode: messageValue);
                                // Sign the user in (or link) with the credential
                                await auth.signInWithCredential(credential);
                                Navigator.of(context).pop();

                                if (await Authentication
                                    .authenticateWithBiometrics()) {
                                  // otpstate = "correct";
                                  var sharedPref =
                                      await SharedPreferences.getInstance();
                                  sharedPref.setBool(
                                      LoginViewState.KEYLOGIN, true);

                                  var fcmToken = await FirebaseMessaging
                                      .instance
                                      .getToken();
                                  // controller.mobile = phone;
                                  // final user = UserModel(
                                  //     id: fcmToken, mobile: LoginView.mobileNo);
                                  // SignInController.instance.createUser(user);
                                  //Successfully logged In
                                  final FirebaseFirestore firestore =
                                      FirebaseFirestore.instance;

                                  final QuerySnapshot querySnapshot =
                                      await firestore
                                          .collection("Users")
                                          .where("Mobile",
                                              isEqualTo: LoginView.mobileNo)
                                          .get();

                                  if (querySnapshot.size > 0) {
                                    // Retrieve the document ID of the first document in the query snapshot
                                    final DocumentSnapshot documentSnapshot =
                                        querySnapshot.docs[0];
                                    final String documentId =
                                        documentSnapshot.id;
                                    firestore
                                        .collection("Users")
                                        .doc(documentId)
                                        .update({"id": fcmToken});

                                    // var sharedPref =
                                    //     await SharedPreferences.getInstance();
                                    final session_no = sharedPref
                                            .getString("session_mobile") ??
                                        '';

                                    QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.success,
                                      title: 'Congratulations',
                                      text: 'User logged in successfully',
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
                                } else {
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
                                              builder: (context) =>
                                                  const LoginView()))
                                    },
                                  );
                                }
                              }
                            } catch (e) {
                              Navigator.of(context).pop();
                              print("wrong otp");
                              // otpstate = "wrong";
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.error,
                                title: "Sorry!",
                                text: 'OTP is invalid...Try again',
                                confirmBtnText: "Ok",
                                onConfirmBtnTap: () =>
                                    {Navigator.of(context).pop()},
                              );
                            }
                          }
                        : null,
                    child: Text("Verify Phone Number")),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              'phone',
                              (route) => false,
                            );
                          },
                          child: Text(
                            "Edit Phone Number ?",
                            style: TextStyle(color: Colors.black),
                          ))),
                  Expanded(
                    child: OtpTimerButton(
                      controller: controller,
                      text: Text('Resend OTP'),
                      duration: 20,
                      radius: 20,
                      loadingIndicator: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                      loadingIndicatorColor: Colors.red,
                      onPressed: () async {
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Processing',
                          text: 'Please wait',
                        );
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: "+91${MyPhone.mobileNo}",
                          timeout: const Duration(seconds: 20),
                          forceResendingToken: MyPhone.forceRT,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {},
                          verificationFailed:
                              (FirebaseAuthException e) async {},
                          codeSent: (String verificationId,
                              int? forceResendingToken) {
                            MyPhone.verify = verificationId;
                            MyPhone.forceRT = forceResendingToken;
                            // MyPhone.mobileNo = phone;
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyVerify()));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
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
