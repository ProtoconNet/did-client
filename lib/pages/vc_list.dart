import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/controller/vc_list_controller.dart';
// import 'package:wallet/widgets/did_card.dart';
import 'package:wallet/models/vc.dart';
import 'package:wallet/pages/vc.dart';
import 'package:wallet/utils/logger.dart';

class VCList extends StatelessWidget {
  VCList({key, required this.did}) : super(key: key);
  final String did;

  final log = Log();
  final g = Get.put(GlobalVariable());
  // final c = Get.putAsync(VCListController(did));
  // final c = Get.put(VCListController());

  @override
  Widget build(BuildContext context) {
    log.i('test');
    final c = Get.put(VCListController(did));

    log.i("VCList build: $did && $c");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FutureBuilder(
            future: c.getVCList(did),
            builder: (context, snapshot) {
              log.i(snapshot);
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  log.i("vcs:${snapshot.data}");
                  final vcs = snapshot.data as List<VCModel>;

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
