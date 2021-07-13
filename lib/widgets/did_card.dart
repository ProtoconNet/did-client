import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';

import 'package:wallet/pages/qr_viewer.dart';
import 'package:wallet/providers/global_variable.dart';

class DIDCard extends StatelessWidget {
  DIDCard({Key key, this.did, this.children}) : super(key: key);
  final g = Get.put(GlobalVariable());
  final String did;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    g.log.i("DIDCard build");
    return Card(
        margin: EdgeInsets.all(0),
        elevation: 1.0,
        child: InkWell(
            onTap: () => g.log.i('DID tap'),
            child: Container(
                padding: EdgeInsets.all(15.0),
                child: Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Container(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Icon(Icons.account_circle_rounded, color: Get.theme.buttonColor)),
                        Text(
                          did.length < 25 ? did : did.substring(0, 25) + '...',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          overflow: TextOverflow.fade,
                        )
                      ]),
                    ])),
                    OpenContainer(
                        openBuilder: (context, closedContainer) {
                          // g.log.i("QRViewer openBuilder");
                          return QRViewer(data: did);
                        },
                        openColor: Get.theme.cardColor,
                        onClosed: (success) {
                          g.log.i("onClose:${success.toString()}");
                        },
                        transitionDuration: Duration(milliseconds: 500),
                        closedShape: CircleBorder(),
                        closedColor: Get.theme.cardColor,
                        closedElevation: 6,
                        closedBuilder: (context, openContainer) {
                          return InkWell(
                              onTap: () {
                                // g.log.i("QRViewer closedBuilder");
                                openContainer();
                              },
                              child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Get.theme.splashColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.qr_code, color: Get.theme.cardColor)));
                        })
                  ]),
                  SizedBox(height: 20.0),
                  ...children
                ]))));
  }
}
