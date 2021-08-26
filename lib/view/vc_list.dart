import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/controller/vc_list_controller.dart';
// import 'package:wallet/widgets/did_card.dart';
import 'package:wallet/model/vc.dart';
import 'package:wallet/widget/vc.dart';
import 'package:wallet/util/logger.dart';

class VCList extends StatelessWidget {
  VCList({key, required this.did})
      : c = Get.put(VCListController(did)),
        super(key: key);
  final String did;

  final log = Log();
  final GlobalVariable g = Get.find();
  final VCListController c;

  @override
  Widget build(BuildContext context) {
    log.i("VCList build: $did");
    return Container(
        alignment: Alignment.center,
        height: Get.height - Get.statusBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
                future: c.setVCList(did),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      // final vcs = snapshot.data as List<VCModel>;
                      // log.i("vcs:${vcs.map((vc) => vc.name)}");

                      return Obx(() => Column(
                              children: c.vcList.map((vc) {
                            return VC(
                                did: did,
                                icon: vc.icon,
                                name: vc.name,
                                description: vc.description,
                                type: vc.type,
                                schemaRequest: vc.schemaRequest,
                                vc: vc.vc,
                                jwt: vc.jwt);
                          }).toList()));
                    }
                  }
                })
          ],
        ));
  }
}
