import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/pages/schema.dart';
import 'package:wallet/pages/did_list.dart';
import 'package:wallet/pages/vp.dart';
import 'package:wallet/widgets/vc_card.dart';
import 'package:wallet/utils/logger.dart';

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
  final g = Get.put(GlobalVariable());
  final log = Log();

  final String did;
  final int icon;
  final String name;
  final String description;
  final String type;
  final String schemaRequest;
  final Map<String, dynamic> vc;
  final String jwt;

  @override
  Widget build(BuildContext context) {
    log.i("VCCard build");

    if (vc.isEmpty) {
      if (jwt == "") {
        log.i('1');
        return Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: InkWell(
                onTap: () async {
                  await Get.to(Schema(
                    did: did,
                    name: name,
                    requestSchema: schemaRequest,
                  ));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => DIDList()));
                },
                child: VCCard(
                    name: name,
                    description: description,
                    type: type,
                    icon: IconData(icon, fontFamily: 'MaterialIcons'),
                    status: "noVC")));
      } else {
        log.i('2');
        return Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: VCCard(
                name: name,
                description: description,
                type: type,
                icon: IconData(icon, fontFamily: 'MaterialIcons'),
                status: "wait"));
      }
    } else {
      // make onPress to Open VC as VP
      log.i('3');
      return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: OpenContainer(
              openBuilder: (context, closedContainer) {
                log.i("VC openBuilder: $vc");
                return VP(name: name, vc: vc);
              },
              openColor: Get.theme.cardColor,
              onClosed: (success) {
                log.i("VC onClose:${success.toString()}");
              },
              transitionDuration: Duration(milliseconds: 500),
              closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              closedColor: Get.theme.cardColor,
              closedElevation: 1,
              closedBuilder: (context, openContainer) {
                return InkWell(
                    onTap: () {
                      // log.i("VC closedBuilder: ${vc['name']}");
                      openContainer();
                    },
                    child: VCCard(
                        name: name,
                        description: description,
                        type: type,
                        icon: IconData(icon, fontFamily: 'MaterialIcons'),
                        status: "VC"));
              }));
    }
  }
}
