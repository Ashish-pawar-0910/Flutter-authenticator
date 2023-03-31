import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/finalpage.dart';
import 'package:flutter_biometric/Screens/login_view.dart';
import 'package:flutter_biometric/Screens/phone.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/verify.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/sign_in_controller.dart';
import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../repository/user_repository.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);
  static String verify = '';
  static String mobileNo = '';
  static int signup_no = 0;
  static int? forceRT = 0;
  static String sign_session_mobile = "";

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  static String phone = '';

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    countryController.text = "+91";

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
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: "Error",
                    text: 'User is not logged in ',
                    confirmBtnText: "Ok",
                    onConfirmBtnTap: () => {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                        (route) => route.isFirst,
                      )
                    },
                  );
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
      if (notification != null && android != null) {
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
      }
    });
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    final controller = Get.put(SignInController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: WillPopScope(
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
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            body: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildLargeScreen(size, simpleUIController, theme);
                } else {
                  return _buildSmallScreen(size, simpleUIController, theme);
                }
              },
            )),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: RotatedBox(
            quarterTurns: 3,
            child: Lottie.asset(
              'assets/images/coin.json',
              height: size.height * 0.3,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(width: size.width * 0.06),
        Expanded(
          flex: 5,
          child: _buildMainBody(size, simpleUIController, theme),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Center(
      child: _buildMainBody(size, simpleUIController, theme),
    );
  }

  /// Main Body
  Widget _buildMainBody(
      Size size, SimpleUIController simpleUIController, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          size.width > 600 ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        size.width > 600
            ? Container()
            : Lottie.asset(
                'assets/images/wave.json',
                height: size.height * 0.2,
                width: size.width,
                fit: BoxFit.fill,
              ),
        SizedBox(
          height: size.height * 0.09,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Sign Up',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Create Account',
            style: kLoginSubtitleStyle(size),
          ),
        ),
        SizedBox(
          height: size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// username
                TextFormField(
                  style: kTextFormFieldStyle(),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Mobile number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                  ),
                  keyboardType: TextInputType.phone,

                  controller: nameController,
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter number';
                    } else if (value.length < 10 || value.length > 10) {
                      return 'No. of digits must be 10';
                    }
                    return null;
                  },
                  onChanged: (value) async {
                    phone = value;
                    var sharedPref = await SharedPreferences.getInstance();

                    sharedPref.setString("session_mobile", phone);
                    final myString =
                        sharedPref.getString('session_mobile') ?? '';
                    if (kDebugMode) {
                      print(myString);
                    }
                  },
                ),

                SizedBox(
                  height: size.height * 0.01,
                ),
                Text(
                  'Creating an account means you\'re okay with our Terms of Services and our Privacy Policy',
                  style: kLoginTermsAndPrivacyStyle(size),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                /// SignUp Button
                signUpButton(theme),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (ctx) => const LoginView()));
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();

                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                            text: " Login",
                            style: TextStyle(color: Colors.green)
                            // style: kLoginOrSignUpTextStyle(size)
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // SignUp Button
  Widget signUpButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        onPressed: () async {
          // Validate returns true if the form is valid, or false otherwise.
          if (_formKey.currentState!.validate()) {
            // ... Navigate To your Home Page
            QuickAlert.show(
              context: context,
              type: QuickAlertType.loading,
              title: 'Processing',
              text: 'Please wait',
            );

            bool checkUser =
                await UserRepository.instance.checkUserExists(phone);
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
                  verificationFailed: (FirebaseAuthException e) async {
                    if (e.code == 'invalid-phone-number') {
                      // error = "invalid";
                      print('The provided phone number is not valid.');
                      Navigator.of(context).pop();
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        title: 'Error',
                        text: 'Phone number is invalid',
                        confirmBtnText: "Ok",
                        onConfirmBtnTap: () => {Navigator.of(context).pop()},
                      );
                    }
                  },
                  codeSent: (String verificationId, int? forceResendingToken) {
                    SignUpView.verify = verificationId;
                    SignUpView.mobileNo = phone;
                    SignUpView.forceRT = forceResendingToken;
                    SignUpView.signup_no = 1;
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyVerify()));
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
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
                onConfirmBtnTap: () => {Navigator.of(context).pop()},
              );
            }
          }
        },
        child: const Text('Sign up'),
      ),
    );
  }
}
