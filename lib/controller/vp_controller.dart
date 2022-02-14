import 'dart:convert';
import 'package:get/get.dart';

import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/provider/platform.dart';
import 'package:wallet/provider/issuer.dart';
import 'package:wallet/provider/verifier.dart';
import 'package:wallet/model/vp.dart';
import 'package:wallet/model/vc.dart';
import 'package:wallet/util/logger.dart';

class VPController extends GetxController {
  VPController(this.did, this.urls);

  final String did;
  final String urls;
  var schemaList = [].obs;

  final GlobalVariable g = Get.find();
  final log = Log();

  final VCListController vcListController = Get.find();

  Future<bool?> getUrls(String schema) async {
    log.i("VPController:getSchema(schema:$schema)");
    final issuer = Issuer(schema);
    final platform = Platform();
    try {
      var locations = await issuer.getUrls();

      var response = await platform.getSchema(locations['schema']);
      if (response.data.containsKey('error')) {
        return null;
      }

      schemaList.value = json.decode(response.data);
    } catch (e) {
      log.e(e);
    }

    return true;
  }

  getVPList() async {
    log.i("VPController:getVPList");
    VCListController vcListController = Get.find();
    // await vcListController.setVCList(did);
    await vcListController.vpManager.loadVP();
  }

  Future<bool>? vpActiveCheck(String name, VPModel vp, List<VCModel> vcs) async {
    var vpMatching = false;
    var matchingCnt = 0;

    final verifier = Verifier(vp.endPoint);

    final VCListController vcListController = Get.find();

    // final privateKey = await g.didManager.value.getDIDPK(did, g.password.value);

    // final token = await verifier.didAuthentication(did, privateKey);

    try {
      final res = await verifier.presentationProposal(did); //, privateKey, token);

      final requestAttribute = json.decode(res!)['requestAttribute'];

      for (var reqAttr in requestAttribute) {
        for (var vc in vcListController.vcManager.vcs) {
          log.i("${reqAttr['name']}, ${vc.name}, ${vc.vc}");
          if (reqAttr['name'] == vc.name && vc.vc.containsKey('id')) {
            matchingCnt++;
          }
        }
      }

      if (matchingCnt == requestAttribute.length) {
        vpMatching = true;
      }
    } catch (e) {
      log.e(e);
    }

    return vpMatching;
    // for (var vc in vp.vc) {
    //   if (vc['name'] == name) {
    //     vpMatching = true;
    //     break;
    //   }
    // }
    // if (vpMatching == false) {
    //   return null;
    // }

    // var vcHoldCount = 0;

    // for (var vc in vcListController.vcManager.vcs) {
    //   for (var requiredVC in vp.vc) {
    //     if (requiredVC['name'] == vc.name && vc.vc.isNotEmpty) {
    //       vcHoldCount++;
    //       break;
    //     }
    //   }
    // }
    // log.i(vcHoldCount);

    // if (vp.vc.length == vcHoldCount) {
    //   return true;
    // } else {
    //   return false;
    // }
  }
}
