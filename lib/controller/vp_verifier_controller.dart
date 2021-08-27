import 'package:get/get.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  final storage = FlutterSecureStorage();

  getVPSchema() async {
    final List<Map<String, dynamic>> vcs = [];

    VCListController vcListController = Get.find();

    for (var vcItem in vpModel.vc) {
      var vc = vcListController.vcManager.getVC(vcItem['name']);
      if (vc == false) {
        vcs.add(vc);
      }
    }

    final didDocument = DIDDocument();

    final pk = g.didManager.value.getDIDPK(did, g.password.value);
    log.i(vcs);

    log.i("pk: $pk");
    var vp = await didDocument.createVP(did, did, did, vcs, [...Base58Decode(pk), ...Base58Decode(did.substring(8))]);
    log.i(vp);

    return vp;
  }

  postVP(vp) async {
    final verifier = Verifier(did);

    final privateKey = g.didManager.value.getDIDPK(did, g.password.value);
    final vp = getVPSchema();

    var response = await verifier.postVP({"did": did, "vp": vp}, privateKey);

    return response;
  }
}
