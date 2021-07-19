import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/widgets/did_card.dart';
import 'package:wallet/pages/vc.dart';
import 'package:wallet/utils/logger.dart';

class VCList extends StatelessWidget {
  VCList({key, required this.did}) : super(key: key);
  final String did;

  final g = Get.put(GlobalVariable());
  final log = Log();
  final c = Get.put(VCListController());

  @override
  Widget build(BuildContext context) {
    log.i("VCList build: $did");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DIDCard(did: did, children: [
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
                    final vcs = snapshot.data as List<Map<String, dynamic>>;

                    return Column(
                        children: vcs.map((vc) {
                      return VC(
                          did: did,
                          icon: vc['icon'],
                          name: vc['name'],
                          schemaRequest: vc['schemaRequest'],
                          vc: vc['VC'],
                          jwt: vc['JWT']);
                    }).toList());
                  }
                }
              })
        ])
      ],
    );
  }
}
