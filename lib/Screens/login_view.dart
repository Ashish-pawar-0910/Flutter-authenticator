import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_biometric/Screens/userpage.dart';
import 'package:flutter_biometric/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biometric/Screens/phone.dart';
import 'package:flutter_biometric/Screens/secondscreen.dart';
import 'package:flutter_biometric/Screens/verify.dart';

import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../controller/simple_ui_controller.dart';
import '../repository/user_repository.dart';
import 'finalpage.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  static String verify = '';
  static String mobileNo = '';
  static int login_no = 0;

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  static String phone = '';
  static int? forceRT = 0;
  static const String KEYLOGIN = " ";
  static const String session_mobile = " ";

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
    // whereToGo();

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
                onPressed: () {
                  // var sharedPref = await SharedPreferences.getInstance();

                  // var isLoggedIn = sharedPref.getBool(LoginViewState.KEYLOGIN);
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
      // Navigator.of(context).pop();
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

  Future<void> whereToGo() async {
    var sharedPref = await SharedPreferences.getInstance();
    final session_no = sharedPref.getString("session_mobile") ?? '';

    var isLoggedIn = sharedPref.getBool(KEYLOGIN);

    if (kDebugMode) {
      print(isLoggedIn);
    }

    if (isLoggedIn != null) {
      if (isLoggedIn) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => UserPage(session_no: session_no)));
      }
    }
  }

  SimpleUIController simpleUIController = Get.put(SimpleUIController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SimpleUIController simpleUIController = Get.find<SimpleUIController>();
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
                return _buildLargeScreen(size, simpleUIController);
              } else {
                return _buildSmallScreen(size, simpleUIController);
              }
            },
          ),
        ),
      ),
    );
  }

  /// For large screens
  Widget _buildLargeScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
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
          child: _buildMainBody(
            size,
            simpleUIController,
          ),
        ),
      ],
    );
  }

  /// For Small screens
  Widget _buildSmallScreen(
    Size size,
    SimpleUIController simpleUIController,
  ) {
    return Center(
      child: _buildMainBody(
        size,
        simpleUIController,
      ),
    );
  }

  /// Main Body
  Widget _buildMainBody(
    Size size,
    SimpleUIController simpleUIController,
  ) {
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
            'Login',
            style: kLoginTitleStyle(size),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            'Welcome Back',
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
                /// username or Gmail
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
                // SizedBox(
                //   height: size.height * 0.02,
                // ),
                // TextFormField(
                //   controller: emailController,
                //   decoration: const InputDecoration(
                //     prefixIcon: Icon(Icons.email_rounded),
                //     hintText: 'gmail',
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(Radius.circular(15)),
                //     ),
                //   ),
                //   // The validator receives the text that the user has entered.
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter gmail';
                //     } else if (!value.endsWith('@gmail.com')) {
                //       return 'please enter valid gmail';
                //     }
                //     return null;
                //   },
                // ),
                // SizedBox(
                //   height: size.height * 0.02,
                // ),

                // /// password
                // Obx(
                //   () => TextFormField(
                //     style: kTextFormFieldStyle(),
                //     controller: passwordController,
                //     obscureText: simpleUIController.isObscure.value,
                //     decoration: InputDecoration(
                //       prefixIcon: const Icon(Icons.lock_open),
                //       suffixIcon: IconButton(
                //         icon: Icon(
                //           simpleUIController.isObscure.value
                //               ? Icons.visibility
                //               : Icons.visibility_off,
                //         ),
                //         onPressed: () {
                //           simpleUIController.isObscureActive();
                //         },
                //       ),
                //       hintText: 'Password',
                //       border: const OutlineInputBorder(
                //         borderRadius: BorderRadius.all(Radius.circular(15)),
                //       ),
                //     ),
                //     // The validator receives the text that the user has entered.
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter some text';
                //       } else if (value.length < 7) {
                //         return 'at least enter 6 characters';
                //       } else if (value.length > 13) {
                //         return 'maximum character is 13';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
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

                /// Login Button
                loginButton(),
                SizedBox(
                  height: size.height * 0.03,
                ),

                /// Navigate To Login Screen
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/signup");
                    nameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    _formKey.currentState?.reset();
                    simpleUIController.isObscure.value = true;
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: kHaveAnAccountStyle(size),
                      children: [
                        TextSpan(
                            text: " Sign up",
                            style: TextStyle(color: Colors.green)),
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

  // Login Button
  Widget loginButton() {
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
            // FirebaseAuth auth = FirebaseAuth.instance;
            // await auth.setSettings(
            //     appVerificationDisabledForTesting:
            //         true); // <-- here is the magic
            Future<void> otpMethod() async {
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: "+91$phone",
                timeout: const Duration(seconds: 20),
                forceResendingToken: forceRT,
                verificationCompleted: (PhoneAuthCredential credential) async {
                  // await FirebaseAuth.instance
                  //     .signInWithCredential(credential);
                },
                verificationFailed: (FirebaseAuthException e) async {
                  if (e.code == 'invalid-phone-number') {
                    // error = "invalid";
                    if (kDebugMode) {
                      print('The provided phone number is not valid.');
                    }
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
                  LoginView.verify = verificationId;
                  LoginView.mobileNo = phone;
                  forceRT = forceResendingToken;
                  LoginView.login_no = 1;

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

            // Navigator.of(context).pop();
          }
        },
        child: const Text('Login'),
      ),
    );
  }
}
