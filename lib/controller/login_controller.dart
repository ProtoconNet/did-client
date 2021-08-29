import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:biometric_storage/biometric_storage.dart';

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
    final response = await BiometricStorage().canAuthenticate();
    return response == CanAuthenticateResponse.success;
  }

  Future<CanAuthenticateResponse> _checkAuthenticate() async {
    final response = await BiometricStorage().canAuthenticate();
    log.i('checked if authentication was possible: $response');
    return response;
  }

  biometricLogin() async {
    try {
      final authenticate = await _checkAuthenticate();
      if (authenticate == CanAuthenticateResponse.unsupported) {
        log.e('Unable to use authenticate. Unable to get storage.');
        return;
      }
      final supportsAuthenticated =
          authenticate == CanAuthenticateResponse.success || authenticate == CanAuthenticateResponse.statusUnknown;
      if (supportsAuthenticated) {
        log.i('onInit try to read biometric storage');
        var bio = BiometricStorage();
        var _noConfirmation = await bio.getStorage(
          'login',
          options: StorageFileInitOptions(),
        );
        log.i('onInit try to read biometric storage 2');
        log.i('${_noConfirmation.name} ');
        var password = await _noConfirmation.read();
        if (password == null) {
          log.e('password is null!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
        } else {
          log.i("pass: $password");

          log.i('a');
          final did = g.didManager.value.getFirstDID();
          log.i('get did');
          final pk = await g.didManager.value.getDIDPK(did, password);
          log.i('get pk using password');

          if (pk == "") throw Error();

          g.password.value = password;
          g.did.value = did;

          Get.offAll(DIDList(), transition: Transition.fadeIn, duration: Duration(milliseconds: 1000));
        }
      }
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

  passwordLogin(password) async {
    try {
      log.i('a');
      final did = g.didManager.value.getFirstDID();
      log.i('get did');
      final pk = await g.didManager.value.getDIDPK(did, password);
      log.i('get pk using password');

      if (pk == "") throw Error();

      g.password.value = password;
      g.did.value = did;

      if (g.biometric.value) {
        var _noConfirmation = await BiometricStorage().getStorage(
          'login',
          options: StorageFileInitOptions(),
        );
        _noConfirmation.write(password);
      }

      Get.offAll(DIDList(), transition: Transition.fadeIn, duration: Duration(milliseconds: 1000));
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
