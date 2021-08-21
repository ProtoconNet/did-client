import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:wallet/model/did_manager.dart';
import 'package:wallet/config/translations.dart';

const themeModeList = {"system": ThemeMode.system, "light": ThemeMode.light, "dark": ThemeMode.dark};

class GlobalVariable extends GetxController {
  final box = GetStorage();
  var password = ''.obs;
  var did = ''.obs;
  var biometric = false.obs;

  var tabController = PersistentTabController(initialIndex: 0).obs;

  var didManager = DIDManager().obs;

  @override
  onInit() {
    super.onInit();
    didManager.value.init();

    if (!box.hasData('themeMode')) {
      theme = 'system';
    }

    if (!box.hasData('language')) {
      language = 'system';
    }

    if (!box.hasData('biometric')) {
      box.write('biometric', false);
      biometric.value = false;
    } else {
      biometric.value = box.read('biometric');
    }

    ever(biometric, (val) {
      box.write('biometric', val);
    });

    box.listenKey('themeMode', (value) {
      Get.changeThemeMode(themeMode(value));
    });

    box.listenKey('language', (value) {
      Get.updateLocale(languageMode(value));
    });
  }

  String get theme => box.read('themeMode');

  set theme(String val) {
    if (themeModeList.containsKey(val)) box.write('themeMode', val);
  }

  ThemeMode themeMode(val) {
    return themeModeList[val]!;
  }

  String get language => box.read('language');

  set language(String val) {
    if (languageModeList.containsKey(val)) box.write('language', val);
  }

  Locale languageMode(val) {
    return languageModeList[val]!;
  }

  // bool get biometric => box.read('biometric');
  // set biometric(bool val) => box.write('biometric', val);

  void setPage(i) {
    tabController.value.jumpToTab(i);
  }
}
