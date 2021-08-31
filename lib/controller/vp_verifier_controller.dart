import 'package:get/get.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';
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

  Future<Map<String, dynamic>> getVPSchema() async {
    log.i("getVPSchema");
    List<Map<String, dynamic>> vcs = [];

    VCListController vcListController = Get.find();

    for (var vcItem in vpModel.vc) {
      log.i("vcItem['name']: ${vcItem['name']}");
      var vc = vcListController.vcManager.getVC(vcItem['name']);
      if (vc != false) {
        vcs.add(vc.toJson()['vc']);
      }
    }

    final didDocument = DIDDocument();

    final pk = await g.didManager.value.getDIDPK(did, g.password.value);

    // final clearText = Base58Decode(pk);
    // log.i(vcs);

    // final algorithm = Ed25519();
    // final keyPair = await algorithm.newKeyPairFromSeed(clearText);
    // final pubKey = await keyPair.extractPublicKey();
    // // final did = 'did:mtm:' + Base58Encode(pubKey.bytes);
    // log.i(vcs);
    // log.i("pk: ${Base58Encode(await keyPair.extractPrivateKeyBytes())}");
    // var vp =
    //     await didDocument.createVP(did, did, did, vcs, [...(await keyPair.extractPrivateKeyBytes()), ...pubKey.bytes]);

    // log.i("pk: $pk");
    var vp = await didDocument.createVP(did, did, did, vcs, [...Base58Decode(pk), ...Base58Decode(did.substring(8))]);
    log.i("my vp: $vp");
    // log.i("my vp2: $vp2");

    return vp;
  }

  Future<String> postVP() async {
    log.i('postVP');
    final verifier = Verifier(vpModel.schemaRequest);
    log.i('v');

    final privateKey = await g.didManager.value.getDIDPK(did, g.password.value);
    log.i('privateKey:$privateKey');
    final vp = await getVPSchema();
    log.i('vp:$vp');

    var response = await verifier.postVP({"did": did, "vp": vp}, privateKey);
    log.i('v');

    return response;
  }
}
