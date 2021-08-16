import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:biometric_storage/biometric_storage.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class LoginController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  @override
  onInit() async {
    super.onInit();

    log.i("biometric: ${g.biometric}");
    if (g.biometric) {
      var _noConfirmation = await BiometricStorage().getStorage('login',
          options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30),
          androidPromptInfo: const AndroidPromptInfo(
            confirmationRequired: false,
          ));
      var pass = await _noConfirmation.read();
      log.i("pass: $pass");

      await login(pass);
    }
  }

  login(password) async {
    try {
      final did = g.didManager.value.getFirstDID();
      await g.didManager.value.getDIDPK(did, password);

      g.password.value = password;
      g.did.value = did;

      if (g.biometric) {
        var _noConfirmation = await BiometricStorage().getStorage('login',
            options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30),
            androidPromptInfo: const AndroidPromptInfo(
              confirmationRequired: false,
            ));
        _noConfirmation.write(password);
      }

      Get.offAllNamed('/');
    } catch (e) {
      log.e(e);
      // log.i("${password} is not correct password");
      await Get.defaultDialog(
          title: "incorrectPasswordTitle".tr,
          content: Text('incorrectPasswordContent'.tr),
          confirm: ElevatedButton(
            child: Text('ok'.tr),
            style: Get.theme.textButtonTheme.style,
            onPressed: () {
              Get.back();
            },
          ));
    }
  }
}
