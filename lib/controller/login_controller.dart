// import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:local_auth/local_auth.dart';
import 'package:biometric_storage/biometric_storage.dart';

// import 'package:wallet/util/biometric_storage.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';
import 'package:wallet/view/did_list.dart';

class LoginController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  var onError = false.obs;

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
    log.i('checked if authentication was possible: $response');
    final supportsAuthenticated =
        response == CanAuthenticateResponse.success || response == CanAuthenticateResponse.statusUnknown;
    return supportsAuthenticated;
  }

  biometricLogin() async {
    log.i("LoginController:biometricLogin");
    try {
      final authenticate = await canBiometricAuth();
      if (authenticate) {
        BiometricStorageFile authStorage =
            await BiometricStorage().getStorage('login', options: StorageFileInitOptions());
        // var customPrompt = await BiometricStorage().getStorage('login',
        //     options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30),
        //     promptInfo: const PromptInfo(
        //       androidPromptInfo: AndroidPromptInfo(
        //         title: 'Custom title',
        //         subtitle: 'Custom subtitle',
        //         description: 'Custom description',
        //         negativeButton: 'Nope!',
        //       ),
        //     ));

        // log.i('onInit try to read biometric storage');
        // // var authStorage = BiometricStorage('login');
        // var authStorage = await BiometricStorage().getStorage('login',
        //     options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30, authenticationRequired: true),
        //     promptInfo: const PromptInfo(
        //       androidPromptInfo: AndroidPromptInfo(
        //         title: 'Custom title',
        //         subtitle: 'Custom subtitle',
        //         description: 'Custom description',
        //         negativeButton: 'Nope!',
        //       ),
        //     ));
        log.i('onInit try to read biometric storage 2');
        // log.i('${_noConfirmation.name} ');
        // final password = await _noConfirmation.read();

        String? password = await authStorage.read();
        log.i('password: $password');

        final did = g.didManager.value.getFirstDID();
        log.i('a');
        final pk = await g.didManager.value.getDIDPK(did, password!);
        log.i('a');

        if (pk == "") throw Error();
        log.i('a');

        g.password.value = password;
        log.i('a');
        g.did.value = did;
        log.i('a');
        Get.offAll(DIDList(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 1000));
      }
    } catch (e) {
      log.e(e);
      onError.value = true;
      // await Get.defaultDialog(
      //     title: "incorrectPasswordTitle".tr,
      //     content: Text('incorrectPasswordContent'.tr),
      //     confirm: ElevatedButton(
      //       child: Text('ok'.tr),
      //       style: Get.theme.textButtonTheme.style,
      //       onPressed: () {
      //         Get.back();
      //       },
      //     ));
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
        // var authStorage = BiometricStorage('login');
        var authStorage = await BiometricStorage().getStorage(
          'login',
          options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30, authenticationRequired: true),
          // promptInfo: const PromptInfo(
          //   androidPromptInfo: AndroidPromptInfo(
          //     title: 'Custom title',
          //     subtitle: 'Custom subtitle',
          //     description: 'Custom description',
          //     negativeButton: 'Nope!',
          //   ),
          //)
        );
        authStorage.write(password);
      }

      Get.offAll(DIDList(), transition: Transition.fadeIn, duration: const Duration(milliseconds: 1000));
    } catch (e) {
      log.e(e);
      onError.value = true;
      log.i("$password is not correct password");
      // await Get.defaultDialog(
      //     title: "incorrectPasswordTitle".tr,
      //     content: Text('incorrectPasswordContent'.tr),
      //     confirm: ElevatedButton(
      //       child: Text('ok'.tr),
      //       style: Get.theme.textButtonTheme.style,
      //       onPressed: () {
      //         Get.back();
      //       },
      //     ));
    }
  }
}
