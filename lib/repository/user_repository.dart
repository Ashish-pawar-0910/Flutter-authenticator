import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

//User repository tio perform database operations

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(UserModel user) async {
    // print("Entered create user");
    await _db
        .collection("Users")
        .add(user.toJson())
        .whenComplete(() => Get.snackbar(
              "Success",
              "User is registered",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green,
            ))
        .catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
      // ignore: avoid_print
      print(error.toString());
    });
  }

  Future<String?> getUserDetails(String mobile) async {
    final snapshot =
        await _db.collection("Users").where("Mobile", isEqualTo: mobile).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    // print(userData);

    return userData.id;
  }

  // Future<UserModel> getUserId(String id) async {
  //   final snapshot =
  //       await _db.collection("Users").where("id", isEqualTo: id).get();
  //   final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

  //   if (kDebugMode) {
  //     print(userData);
  //   }
  //   return userData;
  // }

  Future<bool> checkUserExists(String mobile) async {
    final snapshot =
        await _db.collection("Users").where("Mobile", isEqualTo: mobile).get();
    if (snapshot.size > 0) {
      return true;
    }
    return false;
  }
}
