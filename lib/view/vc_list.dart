import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/controller/vc_list_controller.dart';
// import 'package:wallet/widgets/did_card.dart';
import 'package:wallet/model/vc.dart';
import 'package:wallet/widget/vc.dart';
import 'package:wallet/util/logger.dart';

class VCList extends StatelessWidget {
  VCList({key, required this.did}) : super(key: key);
  final String did;

  final log = Log();
  final g = Get.put(GlobalVariable());
  // final c = Get.putAsync(VCListController(did));
  // final c = Get.put(VCListController());

  @override
  Widget build(BuildContext context) {
    final c = Get.put(VCListController(did));

    log.i("VCList build: $did");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
            future: c.getVCList(did),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final vcs = snapshot.data as List<VCModel>;
                  log.i("vcs:${vcs.map((vc) => vc.name)}");

                  return Column(
                      children: vcs.map((vc) {
                    return VC(
                        did: did,
                        icon: vc.icon,
                        name: vc.name,
                        description: vc.description,
                        type: vc.type,
                        schemaRequest: vc.schemaRequest,
                        vc: vc.vc,
                        jwt: vc.jwt);
                  }).toList());
                }
              }
            })
      ],
    );
  }
}
