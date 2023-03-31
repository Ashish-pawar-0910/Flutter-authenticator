import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_biometric/Screens/logout.dart';
import 'package:flutter_biometric/repository/user_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/sign_in_controller.dart';
import '../authentication.dart';
import 'homepage.dart';

class LogApp extends StatelessWidget {
  const LogApp({Key? key}) : super(key: key);

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
      home: MyHomePage(title: 'Login page'),
    );
  }
}

/* This class is similar to MyApp instead it
returns Scaffold Widget */
class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  TextEditingController countryController = TextEditingController();

  final String title;
  static String phone = '';
  final controller = Get.put(SignInController());
  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        // Sets the content to the
        // center of the application page
        body: Container(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                            String documentID = "";
                            var sharedPref =
                                await SharedPreferences.getInstance();
                            sharedPref.setBool(HomePageState.KEYLOGIN, true);
                            final FirebaseFirestore firestore =
                                FirebaseFirestore.instance;

// Create a query to search for documents with the given mobile number
                            final QuerySnapshot querySnapshot = await firestore
                                .collection("Users")
                                .where("Mobile", isEqualTo: phone)
                                .get();

                            // Check if there is a document with the given mobile number

                            // Future<String?> check =
                            //     UserRepository.instance.getUserDetails(phone);
                            // String? message = await check;
                            // if (kDebugMode) {
                            //   print(message);
                            // }

                            // var collection = FirebaseFirestore.instance
                            //     .collection('Users');
                            // var querySnapshots = await collection.get();
                            // for (var snapshot in querySnapshots.docs) {
                            //   documentID = snapshot.id; // <-- Document ID
                            // }
                            if (await Authentication
                                .authenticateWithBiometrics()) {
                              //  await  _db
                              //       .collection("Users")
                              //       .doc(documentID)
                              //       .update({"Notify": true});
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
                                      builder: (context) => const LogOut()));
                            } else {
                              QuickAlert.show(
                                context: context,
                                type: QuickAlertType.warning,
                                title: 'Value not set',
                                text: 'Try again next time!!!',
                                confirmBtnText: "Ok",
                              );
                            }

                            // QuickAlert.show(
                            //   context: context,
                            //   type: QuickAlertType.success,
                            //   confirmBtnText: "Ok",
                            //   onConfirmBtnTap: () async => {

                            //   },
                            //   title: 'Login session',
                            //   text: 'Value set',
                            // );
                          },
                          //
                          child: Text("Set Login Value")),
                    )
                  ],
                ),
              ),
            ),
          ),
          //   child: Center(
          //     child: ElevatedButton(
          //         onPressed: () async {
          //           var sharedPref = await SharedPreferences.getInstance();
          //           sharedPref.setBool(HomePageState.KEYLOGIN, true);

          //           QuickAlert.show(
          //             context: context,
          //             type: QuickAlertType.success,
          //             confirmBtnText: "Ok",
          //             onConfirmBtnTap: () => {
          //               Navigator.pushReplacement(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const LogOut()))
          //             },
          //             title: 'Login session',
          //             text: 'Value set',
          //           );
          //         },
          //         style: ButtonStyle(
          //           minimumSize: MaterialStateProperty.all(const Size(150, 30)),
          //           textStyle: MaterialStateProperty.all(
          //             const TextStyle(fontSize: 25),
          //           ),
          //           overlayColor: MaterialStateProperty.all(
          //             Colors.cyan,
          //           ),
          //           shadowColor: MaterialStateProperty.all(Colors.yellow),
          //           elevation: MaterialStateProperty.all(15),
          //           padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          //         ),
          //         // child: const Text('Scan QR')),
          //         child: const Text('Set login value')),
          //   ),
        ));
  }
}
