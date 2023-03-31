import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_biometric/authentication.dart';
import 'package:flutter_biometric/helpers/biometric_helper.dart';
import 'package:flutter_biometric/models/user_model.dart';
// import 'package:flutter_biometric/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biometric/repository/user_repository.dart';
// import 'package:flutter_biometric/main.dart';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_biometric/repository/user_repository.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_biometric/constants/text_strings.dart';
// import 'package:get/get_core/get_core.dart';
import 'package:flutter_biometric/Controller/sign_in_controller.dart';

// import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // DateTime backPressedTime = DateTime.now();
  // final AuthService _auth = AuthService();
  // final AuthService _auth = AuthService();
  String serviceURL = "http://localhost:8000/";
  // Future<List> getProfiles() async {
  //   List profiles = [];
  //   var response = await http.get(Uri.parse('${serviceURL}profiles'),
  //       headers: {"Accept": "application/json"});
  //   print(response);
  //   var responseData = json.decode(response.body);
  //   print(responseData);
  //   for (var profileData in responseData) {
  //     profileData = Profile.fromJson(profileData);
  //     // profiles.add(Profile.fromJson(profileData));
  //     profiles.add(profileData['name']);
  //     print(profileData['name']);
  //   }
  //   print(profiles);
  //   return profiles;
  //   // return responseData;
  // }
  // Future<List<Profile>> getProfiles() async {
  //   List<Profile> profiles = [];
  //   var response = await http.get(Uri.parse('${serviceURL}profiles'),
  //       headers: {"Accept": "application/json"});
  //   print(response);
  //   var responseData = json.decode(response.body);
  //   print(responseData);
  //   for (var profileData in responseData) {
  //     profiles.add(Profile.fromJson(profileData));

  //     print(profileData['name']);
  //   }

  //   return profiles;
  //   // return responseData;
  // }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignInController());
    final formkey = GlobalKey<FormState>();
    // final _formkey = GlobalKey<FormState>;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          elevation: 0.0,
          title: const Text('Register User'),
          automaticallyImplyLeading: false,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TextFormField(
                  //   controller: controller.id,
                  //   decoration: const InputDecoration(
                  //       label: Text(tid),
                  //       prefixIcon: Icon(Icons.person_outline_rounded)),
                  // ),
                  // const SizedBox(height: 20),
                  TextFormField(
                    controller: controller.mobile,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        label: Text(tmobile),
                        prefixIcon: Icon(Icons.phone_android_rounded)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        // SignInController.instance.registerUser(id, mobile)
                        var fcmToken =
                            await FirebaseMessaging.instance.getToken();
                        // var fcmToken ;
                        final user = UserModel(
                          id: fcmToken,
                          mobile: controller.mobile.text.trim(),
                        );
                        Widget okButton = TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        );
                        AlertDialog successAlert = AlertDialog(
                          title: const Text("Success"),
                          content: const Text("User Registered Successfully"),
                          actions: [
                            okButton,
                          ],
                        );
                        AlertDialog failureAlert = AlertDialog(
                          // title: const Text("Warning"),
                          title: const Icon(Icons.warning_amber_outlined),
                          content: const Text("User is already Registered!!"),
                          actions: [
                            okButton,
                          ],
                        );
                        AlertDialog tryAgainAlert = AlertDialog(
                          // title: const Text("Warning"),
                          title: const Icon(Icons.warning_amber_outlined),
                          content: const Text("Too many attempts.\nTry Again!"),
                          actions: [
                            okButton,
                          ],
                        );

                        bool checkUser = await UserRepository.instance
                            .checkUserExists(controller.mobile.text.trim());
                        // String? getdetails = await UserRepository.instance
                        //     .getUserDetails(controller.mobile.text.trim());
                        // if (kDebugMode) {
                        //   print(getdetails);
                        // }
                        if (!checkUser) {
                          bool isAuthenticated =
                              await Authentication.authenticateWithBiometrics();
                          // bool isAuthenticated =
                          // await BiometricHelper().authenticate();
                          if (isAuthenticated) {
                            SignInController.instance.createUser(user);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return successAlert;
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return tryAgainAlert;
                              },
                            );
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return failureAlert;
                            },
                          );
                        }
                        controller.mobile.clear();
                        // Navigator.pushNamed(context, '/display');
                        // Future<List<Profile>> temp = getProfiles();
                        // Future<String> temp = getProfiles();
                        // print("temp: $temp.name");/
                        // String tempUser = "initial";
                        // getProfiles().then((value) {
                        //   // print("temp $value");
                        //   for (var p in value) {
                        //     tempUser = p.name;
                        //     break;
                        //     // print(p.name);
                        //   }
                        //   print("finally it's printing $tempUser");
                        // });
                        // SignInController.instance.checkUser(tempUser);
                        // SignInController.instance.checkUser("72728828222");
                        // print("Value is, $temp");
                        // for (var i in temp){

                        // }
                      },
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 20),
                        ),
                        overlayColor: MaterialStateProperty.all(
                          Colors.cyan,
                        ),
                        shadowColor: MaterialStateProperty.all(Colors.yellow),
                        elevation: MaterialStateProperty.all(15),
                      ),
                      child: const Text("Signup"),
                    ),
                  )
                ],
              )),
        ));
  }
}



// child: ElevatedButton(
//           child: const Text('Sign in anonymously'),
//           onPressed: () async {
//             final fcmToken = await FirebaseMessaging.instance.getToken();
//             dynamic result = await _auth.signInAnon();
//             if (result == null) {
//               print("error in signing in");
//             } else {
//               print("signed in");
//               print(result);
//               print(result.uid);
//               print(fcmToken);
//             }
//           },
//         ),