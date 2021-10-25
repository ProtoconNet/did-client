import 'package:get/get.dart';

import 'package:fast_base58/fast_base58.dart';
import 'package:wallet/controller/vc_list_controller.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/provider/verifier.dart';
import 'package:wallet/model/vp.dart';
import 'package:wallet/util/did_document.dart';
import 'package:wallet/util/logger.dart';

class VPVerifierController extends GetxController {
  VPVerifierController(this.did, this.vpModel);

  final String did;
  final VPModel vpModel;

  final GlobalVariable g = Get.find();
  final log = Log();

  Future<Map<String, dynamic>> getVPSchema() async {
    log.i("VPVerifierController:getVPSchema");
    List<Map<String, dynamic>> vcs = [];

    VCListController vcListController = Get.find();
/*
    for (var vcItem in vpModel.vc) {
      log.i("vcItem['name']: ${vcItem['name']}");
      var vc = vcListController.vcManager.getVC(vcItem['name']);
      if (vc != null) {
        vcs.add(vc.toJson()['vc']);
      }
    }

    final didDocument = DIDDocument();

    final pk = await g.didManager.value.getDIDPK(did, g.password.value);

    var vp = await didDocument.createVP(did, did, did, vcs, [...Base58Decode(pk), ...Base58Decode(did.substring(8))]);
    log.i("my vp: $vp");

    return vp;
    */
    return {};
  }

  Future<String> postVP() async {
    log.i("VPVerifierController:postVP");
    final verifier = Verifier(vpModel.endPoint);

    final privateKey = await g.didManager.value.getDIDPK(did, g.password.value);
    log.i('privateKey:$privateKey');

    final token = await verifier.didAuthentication(did, privateKey);

    verifier.presentationProposal(did, privateKey, token);

    // final vp = await getVPSchema();
    // log.i('vp:$vp');

    // var response = await verifier.postVP({"did": did, "vp": vp}, privateKey);

    // return response;

    return "";
  }
}
