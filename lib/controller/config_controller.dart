import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:camera/camera.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/view/create_wallet.dart';
import 'package:wallet/util/logger.dart';

class ConfigController extends GetxController {
  final box = GetStorage();
  final storage = FlutterSecureStorage();
  final GlobalVariable g = Get.find();
  final log = Log();

  final cameras = [].obs;

  final controller = CameraController(
          CameraDescription(name: 'test', lensDirection: CameraLensDirection.front, sensorOrientation: 0),
          ResolutionPreset.max)
      .obs;

  var theme = 'system'.obs;
  var language = 'system'.obs;

  var controllerCenter = ConfettiController(duration: const Duration(seconds: 10)).obs;

  @override
  onInit() {
    super.onInit();

    language.value = g.language;
    theme.value = g.theme;

    // WidgetsFlutterBinding.ensureInitialized();
    availableCameras().then((ca) {
      cameras.value = ca;
      controller.value = CameraController(cameras[0], ResolutionPreset.max);
    });
  }

  setTheme(val) {
    theme.value = val;
    g.theme = val;
  }

  setLanguage(val) {
    language.value = val;
    g.language = val;
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

  test() {}

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

    Get.offAll(CreateWallet());
  }
}
