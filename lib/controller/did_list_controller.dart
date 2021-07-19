import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/utils/logger.dart';

class DIDListController extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();
  final issuer = Issuer();

  getDIDList() async {
    log.i("getDIDList");

    var didListStr = await storage.read(key: "DIDList") as String;

    log.i(didListStr);

    var didList = json.decode(didListStr);

    log.i(didList);
    return didList;
  }
}
