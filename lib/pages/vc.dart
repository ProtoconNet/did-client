import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/pages/schema.dart';
import 'package:wallet/pages/did_list.dart';
import 'package:wallet/pages/vp.dart';
import 'package:wallet/widgets/vc_card.dart';

class VC extends StatelessWidget {
  VC(
      {key,
      required this.did,
      required this.icon,
      required this.name,
      required this.schemaRequest,
      required this.vc,
      required this.jwt})
      : super(key: key);
  final g = Get.put(GlobalVariable());

  final String did;
  final int icon;
  final String name;
  final String schemaRequest;
  final Map<String, dynamic> vc;
  final String jwt;

  @override
  Widget build(BuildContext context) {
    g.log.i("VCCard build");

    if (vc.isEmpty) {
      if (jwt == "") {
        // g.log.i('1');
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
                child: VCCard(icon: IconData(icon, fontFamily: 'MaterialIcons'), name: name, status: "noVC")));
        // OpenContainer(
        //   openBuilder: (context, closedContainer) {
        //     g.log.i("noVC openBuilder: ${vc['name']}");
        //     g.log.i(closedContainer);
        //     return Schema(
        //       name: vc['name'],
        //       requestSchema: vc['schemaRequest'],
        //     );
        //   },
        //   openColor: Get.theme.cardColor,
        //   onClosed: (success) {
        //     g.log.i("noVC onClose:${success.toString()}");
        //     Navigator.pushReplacement(
        //         context, MaterialPageRoute(builder: (BuildContext context) => VCList()));
        //   },
        //   transitionDuration: Duration(milliseconds: 500),
        //   closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        //   closedColor: Get.theme.cardColor,
        //   closedElevation: 0,
        //   closedBuilder: (context, openContainer) {
        //     g.log.i("noVC closeBuilder: ${vc['name']}");
        //     return InkWell(
        //         onTap: () => openContainer(),
        //         child: VCCard(
        //             icon: IconData(vc['icon'], fontFamily: 'MaterialIcons'),
        //             name: vc['name'],
        //             status: "noVC"));
        //     //run: () => openContainer());
        //   }));
        // g.log.i(vcViewList);
      } else {
        return Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: VCCard(icon: IconData(icon, fontFamily: 'MaterialIcons'), name: name, status: "wait"));
      }
    } else {
      // make onPress to Open VC as VP
      // g.log.i('2');
      return Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: OpenContainer(
              openBuilder: (context, closedContainer) {
                // g.log.i("VC openBuilder: ${vc['name']}");
                return VP(name: name);
              },
              openColor: Get.theme.cardColor,
              onClosed: (success) {
                g.log.i("VC onClose:${success.toString()}");
              },
              transitionDuration: Duration(milliseconds: 500),
              closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              closedColor: Get.theme.cardColor,
              closedElevation: 1,
              closedBuilder: (context, openContainer) {
                return InkWell(
                    onTap: () {
                      // g.log.i("VC closedBuilder: ${vc['name']}");
                      openContainer();
                    },
                    child: VCCard(icon: IconData(icon, fontFamily: 'MaterialIcons'), name: name, status: "VC"));
              }));
    }
  }
}
