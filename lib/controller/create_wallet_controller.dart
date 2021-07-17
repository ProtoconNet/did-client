import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateWalletController extends GetxController {
  final storage = FlutterSecureStorage();
  var formKey = GlobalKey<FormState>().obs;
  var status = false.obs;

  setStatus(val) {
    status.value = val;
  }
}
