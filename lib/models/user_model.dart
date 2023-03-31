// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? mobile;
  bool? notify;

  UserModel({
    this.id,
    this.mobile,
    // ignore: non_constant_identifier_names
    this.notify,
  });

  @override
  String toString() {
    return 'User details: {id: ${id}, Mobile: ${mobile}, Notify: ${notify}}';
  }

  toJson() {
    return {
      "id": id,
      "Mobile": mobile,
      "Notify": false,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        id: data["id"], mobile: data["Mobile"], notify: data["Notify"]);
  }
}

//Map user fetched from firebasaae to UserModel


