import 'package:flutter/cupertino.dart';
import 'package:flutter_biometric/models/user_model.dart';
import 'package:flutter_biometric/repository/user_repository.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  static SignInController get instance => Get.find();

  final id = TextEditingController();
  late final mobile = TextEditingController();

  final userRepo = Get.put(UserRepository());

  Future<void> createUser(UserModel user) async {
    await userRepo.createUser(user);
  }

  Future<void> checkUser(String mobile) async {
    await userRepo.getUserDetails(mobile);
    // debugPrint(result);
    // print("${temp.id}.toString()");
  }
}
