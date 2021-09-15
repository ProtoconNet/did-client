import 'dart:convert';
import 'package:get/get.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/provider/issuer.dart';
import 'package:wallet/model/vc_manager.dart';
import 'package:wallet/model/vp_manager.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class VCListController extends GetxController {
  VCListController(this.did)
      : vcManager = VCManager(did),
        vpManager = VPManager(did);

  final String did;
  VCManager vcManager;
  VPManager vpManager;

  final GlobalVariable g = Get.find();
  final log = Log();

  @override
  onInit() async {
    super.onInit();

    await vcManager.init();
    await vpManager.init();
  }

  setVCList(String did) async {
    log.i("VCListController:setVCList(did:$did)");

    for (var vc in vcManager.vcs) {
      log.i("vc:${vc.name}:${vc.vc}:${vc.jwt}");
      if (vc.vc.isEmpty && vc.jwt != "") {
        log.i("getVC from issuer");

        final issuer = Issuer(vc.schemaRequest);
        var response = await issuer.getVC(vc.jwt);

        // catchup denied
        if (json.decode(response.data).containsKey('error')) {
          await vcManager.setByName(vc.name, 'jwt', "denied");
        } else {
          var data = json.decode(response.data)['VC'];

          await vcManager.setByName(vc.name, 'vc', data);
          await vcManager.setByName(vc.name, 'jwt', "");
        }
      }
    }
  }
}
