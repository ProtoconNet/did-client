import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/utils/logger.dart';

class DIDListController extends GetxController {
  final storage = FlutterSecureStorage();
  final log = Log();

  getDIDList() async {
    log.i("getDIDList");

    var didListStr = await storage.read(key: "DIDList") as String;
    var didList = json.decode(didListStr);

    log.i("didList: $didList");

    return didList;
  }
}
