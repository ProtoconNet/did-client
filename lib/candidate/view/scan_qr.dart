import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:wallet/candidate/controller/scan_qr_controller.dart';

class ScanQR extends StatelessWidget {
  final ScanQRController c = Get.put(ScanQRController());

  Widget _buildQrView() {
    var scanArea = (Get.width < 400 || Get.height < 400) ? 150.0 : 300.0;

    return QRView(
      key: c.qrKey,
      onQRViewCreated: c.onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 6, child: _buildQrView()),
          Obx(() => Expanded(flex: 1, child: c.result.value == "" ? Text('reading') : Text(c.result.value))),
        ],
      ),
    );
  }
}
