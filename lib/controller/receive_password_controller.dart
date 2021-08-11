import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivePasswordController extends GetxController {
  var formKey = GlobalKey<FormState>().obs;
  var status = false.obs;
  var password = ''.obs;
}
