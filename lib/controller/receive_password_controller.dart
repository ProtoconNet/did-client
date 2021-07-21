import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ReceivePasswordController extends GetxController {
  final storage = FlutterSecureStorage();
  var formKey = GlobalKey<FormState>().obs;
  var status = false.obs;
  var password = ''.obs;

  setStatus(val) {
    status.value = val;
  }

  setPassword(val) {
    password.value = val;
  }
}
