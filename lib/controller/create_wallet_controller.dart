import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateWalletController extends GetxController {
  var formKey = GlobalKey<FormState>().obs;
  var status = false.obs;

  setStatus(val) {
    status.value = val;
  }
}
