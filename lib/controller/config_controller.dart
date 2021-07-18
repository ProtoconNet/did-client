import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/pages/select_join.dart';
import 'package:wallet/utils/logger.dart';

class ConfigController extends GetxController {
  final box = GetStorage();
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();

  var theme = 'system'.obs;
  var language = 'system'.obs;

  @override
  onInit() {
    language.value = g.language;

    theme.value = g.theme;
    super.onInit();
  }

  setTheme(val) {
    theme.value = val;
    g.changeTheme(val);
  }

  setLanguage(val) {
    language.value = val;
    g.changeLanguage(val);
  }

  var text = "".obs;

  void setText(val) {
    text.value = val;
  }

  String getAccount() {
    return g.did.value;
  }

  jsonldTest() async {}

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  eraseAll() async {
    // box.remove('themeMode');
    // box.remove('language');
    if (await storage.containsKey(key: "DIDList")) {
      String didList = await storage.read(key: "DIDList") as String;

      log.i("erase ${json.decode(didList)}");

      for (var did in json.decode(didList).keys.toList()) {
        //var didVC = storage.read(key: did) as String;
        if (await storage.containsKey(key: did)) {
          await storage.delete(key: did);
        }
      }
      await storage.delete(key: "DIDList");
    }

    // await deleteCacheDir();
    // await deleteAppDir();

    Get.offAll(SelectJoin());
  }
}
