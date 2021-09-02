import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/util/biometric_storage.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';
import 'package:wallet/view/did_list.dart';

class LoginController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  @override
  onInit() async {
    super.onInit();
    // _checkAuthenticate();
    log.i("biometric: ${g.biometric.value}");
    if (g.biometric.value) {
      try {
        await biometricLogin();
      } catch (e) {
        log.e(e);
      }
    }
  }

  Future<bool> canBiometricAuth() async {
    log.i("LoginController:canBiometricAuth");
    return await BiometricStorage().canCheckBiometric();
  }

  biometricLogin() async {
    log.i("LoginController:biometricLogin");
    try {
      final password = await BiometricStorage().read('password');

      if (password != null) {
        final did = g.didManager.value.getFirstDID();
        final pk = await g.didManager.value.getDIDPK(did, password);

        if (pk == "") throw Error();

        g.password.value = password;
        g.did.value = did;
        Get.offAll(DIDList(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 1000));
      }
    } catch (e) {
      log.e(e);
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

  passwordLogin(String password) async {
    log.i("LoginController:passwordLogin(password:$password)");
    try {
      final did = g.didManager.value.getFirstDID();
      log.i('did: $did');
      final pk = await g.didManager.value.getDIDPK(did, password);
      log.i('pk: $pk');

      if (pk == "") throw Error();

      g.password.value = password;
      g.did.value = did;

      if (g.biometric.value) {
        final result = await BiometricStorage().write('password', password);
        if (result == null) {
          log.e("biometric storage write error");
        }
      }

      Get.offAll(DIDList(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 1000));
    } catch (e) {
      log.e(e);
      log.i("$password is not correct password");
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
