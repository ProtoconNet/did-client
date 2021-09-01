import 'dart:convert';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class DIDListController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  final storage = FlutterSecureStorage();

  _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  _deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  eraseAll() async {
    log.i("DIDListController:eraseAll");
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
    g.biometric.value = false;

    g.didManager.value.dids = {};

    await _deleteAppDir();
    await _deleteCacheDir();
  }
}
