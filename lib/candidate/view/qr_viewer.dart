import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:wallet/widget/background.dart';

class QRViewer extends StatelessWidget {
  QRViewer({key, required this.data}) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading:
                TextButton(onPressed: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: Colors.white)),
            backgroundColor: Get.theme.appBarTheme.backgroundColor),
        body: Background(children: [
          Container(
              child: Column(children: [
            Text(data, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
            Container(
                color: Colors.white,
                child: QrImage(
                  data: data,
                  version: QrVersions.auto,
                  size: 200.0,
                )),
          ]))
        ]));
  }
}
