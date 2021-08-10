import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/config/translations.dart';

class GlobalVariable extends GetxController {
  final box = GetStorage();
  var password = ''.obs;
  var did = ''.obs;
  // var biometric = false.obs;
  var tabController = PersistentTabController(initialIndex: 0).obs;

  var didManager = DIDManager().obs;

  final themeModeList = {"system": ThemeMode.system, "light": ThemeMode.light, "dark": ThemeMode.dark};

  @override
  onInit() {
    if (!box.hasData('themeMode')) {
      changeTheme('system');
    }

    if (!box.hasData('language')) {
      changeLanguage('system');
    }

    if (!box.hasData('biometric')) {
      box.write('biometric', false);
    }

    box.listenKey('themeMode', (value) {
      Get.changeThemeMode(themeMode(value));
    });

    box.listenKey('language', (value) {
      Get.updateLocale(languageMode(value));
    });

    didManager.value.init();

    super.onInit();
  }

  String get theme => box.read('themeMode');

  ThemeMode themeMode(val) {
    return themeModeList[val]!;
  }

  void changeTheme(String val) {
    if (themeModeList.containsKey(val)) box.write('themeMode', val);
  }

  String get language => box.read('language');

  Locale languageMode(val) {
    return languageModeList[val]!;
  }

  void changeLanguage(String val) {
    if (languageModeList.containsKey(val)) box.write('language', val);
  }

  bool get biometric => box.read('biometric');

  void setBiometric(bool val) {
    box.write('biometric', val);
  }

  void inputPassword(String param) {
    password.value = param;
  }

  void inputDID(String param) {
    did.value = param;
  }

  void setPage(i) {
    tabController.value.jumpToTab(i);
  }
}
