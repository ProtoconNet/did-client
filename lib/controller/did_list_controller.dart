import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/global_variable.dart';

class DIDListController extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final issuer = Issuer();

  getDIDList() async {
    g.log.i("getDIDList");

    var didListStr = await storage.read(key: "DIDList");

    var didList = json.decode(didListStr);

    return didList;
  }
}
