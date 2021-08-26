import 'dart:io';
import 'dart:convert';
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
    var keyPair = await crypto.generateKeyPair();
    var encodedPriv = keyPair[0];
    var encodedPub = keyPair[1];

    final did = 'did:mtm:' + encodedPub;
    g.did.value = did;

    log.i("encodedPriv: $encodedPriv");

    final encrypted = await crypto.encryptPK(encodedPriv, password);

    log.i("encrypted: $encrypted");

    await g.didManager.value.setDID(did, Base58Encode(encrypted), password);

    return did;
  }

  registerDidDocument(did) async {
    log.i("&" * 100);
    try {
      var response = await platform.getDIDDocument(dotenv.env['GET_DID_DOCUMENT']! + did);
    } catch (e) {
      log.i("DID Not Found. Let's Register");

      log.i("&" * 100);

      var response = await platform.setDIDDocument(dotenv.env['REGISTER_DID_DOCUMENT']!, did);
      log.i("&" * 100);
      log.i("set did document response: $response");

      var response2 = await platform.getDIDDocument(dotenv.env['GET_DID_DOCUMENT']! + did);
      log.i(response2);
      if (response2['message'] == "success") {
        log.i("DID Registration Success");
      } else {
        log.i("DID Registration Failed");
      }
    } finally {
      log.i("DID Already Exist");
    }
  }
}
