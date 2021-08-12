import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/view/schema.dart';
import 'package:wallet/provider/secure_storage.dart';
import 'package:wallet/util/logger.dart';

class ScanQRController extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;

  var result = "".obs;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      var val = json.decode(scanData.code);
      switch (val['type']) {
        case "issue":
          // add claim to secure storage
          final saveResult = await VCManager(g.did.value).setVC(json.encode(val['claim']));
          // execute schema page
          if (saveResult) {
            await Get.to(Schema(
              did: '',
              name: val['claim']['name'],
              requestSchema: val['claim']['schemaRequest'],
            ));
            g.setPage(0);
          } else {
            result.value = "Same VC Exists";
            log.i(scanData.code);
          }
          break;
        default:
          result.value = scanData.code;
          break;
      }
    });
  }

  @override
  onClose() {
    controller!.dispose();
  }
}
