// import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/view/schema.dart';
import 'package:wallet/view/vp.dart';
import 'package:wallet/view/vc_card.dart';
import 'package:wallet/util/logger.dart';

class VC extends StatelessWidget {
  VC(
      {key,
      required this.did,
      required this.icon,
      required this.name,
      required this.description,
      required this.type,
      required this.schemaRequest,
      required this.vc,
      required this.jwt})
      : super(key: key);

  final String did;
  final int icon;
  final String name;
  final String description;
  final String type;
  final String schemaRequest;
  final Map<String, dynamic> vc;
  final String jwt;

  final GlobalVariable g = Get.find();
  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i("VC:build");

    if (vc.isEmpty) {
      log.i('vc empty');
      if (jwt == "") {
        log.i('no VC');
        return InkWell(
            onTap: () async {
              log.i("go to Schema");
              log.i("schemaRequest: $schemaRequest");
              await Get.to(Schema(
                did: did,
                name: name,
                requestSchema: schemaRequest,
              ));
              VCListController vcListController = Get.find();
              await vcListController.setVCList(did);
              await vcListController.vcManager.readVC();
              // vcListController.vcManager.update((t) {});
              Get.back();
              // Get.offAll(DIDList());
            },
            child: VCCard(
                name: name,
                description: description,
                type: type,
                icon: IconData(icon, fontFamily: 'MaterialIcons'),
                status: "noVC"));
      } else {
        log.i('wait VC');
        return VCCard(
            name: name,
            description: description,
            type: type,
            icon: IconData(icon, fontFamily: 'MaterialIcons'),
            status: "wait");
      }
    } else {
      // make onPress to Open VC as VP
      log.i('have VC');
      return InkWell(
        onTap: () {
          // log.i("VC closedBuilder: ${vc['name']}");
          Get.to(VP(did: did, name: name, vc: vc, schemaRequest: schemaRequest));
        },
        child: VCCard(
            name: name,
            description: description,
            type: type,
            icon: IconData(icon, fontFamily: 'MaterialIcons'),
            status: "VC"),
      );
    }
  }
}
