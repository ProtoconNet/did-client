import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/pages/schema.dart';
import 'package:wallet/providers/secure_storage.dart';

class ScanQRController extends GetxController {
  final logger = Logger(printer: PrettyPrinter(methodCount: 1, colors: false));
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final GlobalKey qrKey = GlobalKey();
  QRViewController controller;

  var result = "".obs;

  void onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      var val = json.decode(scanData.code);
      switch (val['type']) {
        case "issue":
          // add claim to secure storage
          final saveResult = await VCManager().addClaim(json.encode(val['claim']));
          // execute schema page
          if (saveResult) {
            await Get.to(Schema(
              name: val['claim']['name'],
              requestSchema: val['claim']['schemaRequest'],
            ));
            g.setPage(0);
          } else {
            result.value = "Same VC Exists";
            g.log.i(scanData.code);
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
    controller.dispose();
  }
}
