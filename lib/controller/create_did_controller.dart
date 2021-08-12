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
  final g = Get.put(GlobalVariable());
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

    final encrypted = await crypto.encryptPK(password, encodedPriv);

    log.i("encrypted: $encrypted");

    await g.didManager.value.setDID(did, Base58Encode(encrypted), password);

    return did;
  }

  registerDidDocument(did) async {
    var response = await platform.getDIDDocument(Uri.parse(dotenv.env['GET_DID_DOCUMENT']! + did));
    if (json.decode(response.body)['message'] == "success") {
      log.i("DID Already Exist");
      return;
    } else {
      log.i("DID Not Found. Let's Register");
    }

    do {
      response = await platform.setDIDDocument(Uri.parse(dotenv.env['REGISTER_DID_DOCUMENT']!), did);

      if ((response.statusCode / 100).floor() != 2) {
        sleep(Duration(seconds: 10));
      } else {
        var response2 = await platform.getDIDDocument(Uri.parse(dotenv.env['GET_DID_DOCUMENT']! + did));
        if (json.decode(response2.body)['message'] == "success") {
          log.i("DID Registration Success");
        } else {
          log.i("DID Registration Failed");
        }
      }
    } while ((response.statusCode / 100).floor() != 2);
  }
}
