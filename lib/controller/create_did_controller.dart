import 'package:get/get.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/provider/platform.dart';
import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

class CreateDIDController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();
  final platform = Platform();
  final crypto = Crypto();

  String publicKey = "";

  Future<String> createDID(String password) async {
    log.i("CreateDIDController:createDID(password:$password)");
    final List<String> keyPair = await crypto.generateKeyPair(Algorithm.ed25519);
    final String encodedPriv = keyPair[0];
    final String encodedPub = keyPair[1];

    final String did = 'did:mtm:' + encodedPub;
    g.did.value = did;

    final List<int> encrypted = await crypto.encryptPK(encodedPriv, password);

    await g.didManager.value.setDID(did, Base58Encode(encrypted), password);

    return did;
  }

  Future<bool> registerDidDocument(String did) async {
    log.i("CreateDIDController:registerDidDocument(did:$did)");
    try {
      await platform.getDIDDocument(dotenv.env['GET_DID_DOCUMENT']! + did);
    } catch (e) {
      log.i("DID Not Found. Let's Register");

      var response = await platform.setDIDDocument(dotenv.env['REGISTER_DID_DOCUMENT']!, did);
      log.i("set did document response: $response");

      var response2 = await platform.getDIDDocument(dotenv.env['GET_DID_DOCUMENT']! + did);
      log.i("response2: $response2");
      if (response2.data['message'] == "success") {
        log.i("DID Registration Success");
        return true;
      } else {
        log.i("DID Registration Failed");
        return false;
      }
    } finally {
      log.i("DID register done");
    }
    return false;
  }
}
