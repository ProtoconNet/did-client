import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:biometric_storage/biometric_storage.dart';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class LoginController extends GetxController {
  final g = Get.put(GlobalVariable());
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
      final pk = await g.didManager.value.getDIDPK(g.didManager.value.getFirstDID(), password);

      final algorithm = Ed25519();
      final keyPair = await algorithm.newKeyPairFromSeed(Base58Decode(pk));
      final pubKey = await keyPair.extractPublicKey();
      final did = 'did:mtm:' + Base58Encode(pubKey.bytes);
      g.inputPassword(password);
      g.inputDID(did);

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
          title: "incorrectPassword".tr,
          content: Text('incorrectPassword'.tr),
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
