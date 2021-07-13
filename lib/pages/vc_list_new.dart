import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animations/animations.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/pages/schema.dart';
import 'package:wallet/pages/vp.dart';
import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/widgets/did_card.dart';
import 'package:wallet/widgets/vc_card.dart';
import 'package:wallet/pages/did_list.dart';

class VCListNew extends StatelessWidget {
  VCListNew({key, @required this.did}) : super(key: key);
  final String did;

  final g = Get.put(GlobalVariable());
  final c = Get.put(VCListControllerNew());

  @override
  Widget build(BuildContext context) {
    g.log.i("VCList build:", did);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DIDCard(did: did, children: [
          FutureBuilder(
              future: c.getVCList(did),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.hasError) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    var vcViewList = <Widget>[];

                    for (var vc in snapshot.data) {
                      print(vc["name"]);
                      print(vc["icon"]);
                      print(vc["VC"]);
                      print(vc["JWT"]);
                      if (vc["VC"] == "") {
                        if (vc["JWT"] == "") {
                          // g.log.i('1');
                          vcViewList.add(Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: InkWell(
                                  onTap: () async {
                                    await Get.to(Schema(
                                      name: vc['name'],
                                      requestSchema: vc['schemaRequest'],
                                    ));
                                    Navigator.pushReplacement(
                                        context, MaterialPageRoute(builder: (BuildContext context) => DIDList()));
                                  },
                                  child: VerifiableCredentialCard(
                                      icon: IconData(vc['icon'], fontFamily: 'MaterialIcons'),
                                      name: vc['name'],
                                      status: "noVC"))));
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
                          //         child: VerifiableCredentialCard(
                          //             icon: IconData(vc['icon'], fontFamily: 'MaterialIcons'),
                          //             name: vc['name'],
                          //             status: "noVC"));
                          //     //run: () => openContainer());
                          //   }));
                          // g.log.i(vcViewList);
                        } else {
                          vcViewList.add(VerifiableCredentialCard(
                              icon: IconData(vc['icon'], fontFamily: 'MaterialIcons'),
                              name: vc['name'],
                              status: "wait"));
                        }
                      } else {
                        // make onPress to Open VC as VP
                        // g.log.i('2');
                        vcViewList.add(Padding(
                            padding: EdgeInsets.only(bottom: 20.0),
                            child: OpenContainer(
                                openBuilder: (context, closedContainer) {
                                  // g.log.i("VC openBuilder: ${vc['name']}");
                                  return VP(name: vc['name']);
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
                                      child: VerifiableCredentialCard(
                                          icon: IconData(vc['icon'], fontFamily: 'MaterialIcons'),
                                          name: vc['name'],
                                          status: "VC"));
                                })));
                      }
                    }
                    return Column(children: vcViewList);
                  }
                }
              })
        ])
      ],
    );
  }
}
