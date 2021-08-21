import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReceivePasswordController extends GetxController {
  final formKey = GlobalKey<FormState>().obs;
  final status = false.obs;
  final password = ''.obs;
}
