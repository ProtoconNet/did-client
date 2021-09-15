import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/vp_controller.dart';
import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/view/vp_verifier.dart';
import 'package:wallet/util/logger.dart';

class VP extends StatelessWidget {
  VP({key, required this.did, required this.name, required this.vc, required this.schemaRequest})
      : c = Get.put(VPController(did, schemaRequest)),
        super(key: key);

  final VPController c;

  final log = Log();

  final VCListController vcListController = Get.find();

  final Map<String, dynamic> vc;
  final String did;
  final String name;
  final String schemaRequest;

  List<Widget> _credentialSubjectList(Map<String, dynamic> credentialSubject) {
    // await c.getSchema(c.schemaRequest);
    List<Widget> ret = [];
    for (var key in credentialSubject.keys) {
      ret.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(key.toUpperCase(), style: Get.textTheme.subtitle2!.copyWith(color: Get.theme.colorScheme.secondary)),
        Text("${credentialSubject[key]}",
            style: Get.textTheme.headline5!.copyWith(fontWeight: FontWeight.w600), maxLines: 3)
      ]));
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    log.i("VP:build");
    log.i(vcListController.vpManager.vps[0].name);
    return Background(
        appBar: AppBar(
          title: Text(name),
        ),
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 20),
            width: Get.width * 0.75,
            child: Card(
              color: Get.theme.cardColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ..._credentialSubjectList(vc['credentialSubject']),
                      const SizedBox(height: 18),
                      Center(child: QrImage(data: did, version: QrVersions.auto, size: 160.0))
                    ],
                  )),
            ),
          ),
          Obx(() => Column(
                  children: (vcListController.vpManager.vps.map((vp) {
                final active = c.vpActiveCheck(name, vp, vcListController.vcManager.vcs);

                if (active == null) {
                  return const SizedBox();
                } else if (active) {
                  return VPVerifier(did: did, vp: vp, enable: true);
                } else {
                  return VPVerifier(did: did, vp: vp, enable: false);
                }
              }).toList()))),
        ]);
  }
}
