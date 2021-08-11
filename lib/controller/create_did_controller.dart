import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/providers/platform.dart';
import 'package:wallet/utils/logger.dart';

class CreateDIDController extends GetxController {
  final g = Get.put(GlobalVariable());
  final log = Log();
  final platform = Platform();
  String publicKey = "";

  generateKeyPair() async {
    final seeds = encrypt.SecureRandom(32).bytes;

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(seeds);

    var encodedPriv = Base58Encode(await keyPair.extractPrivateKeyBytes());
    var encodedPub = Base58Encode((await keyPair.extractPublicKey()).bytes);

    return [encodedPriv, encodedPub];
  }

  encryptPK(password, encodedPriv) async {
    final passwordBytes = utf8.encode(password);

    final sink = Sha256().newHashSink();
    sink.add(passwordBytes);
    sink.close();
    final passwordHash = await sink.hash();

    final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromLength(16);

    final encrypted = encrypter.encrypt("WIGGLER" + encodedPriv, iv: iv);

    return encrypted.bytes;
  }

  Future<String> createDID(String password) async {
    var keyPair = await generateKeyPair();
    var encodedPriv = keyPair[0];
    var encodedPub = keyPair[1];

    final did = 'did:mtm:' + encodedPub;
    g.inputDID(did);

    log.i("@encodedPriv: $encodedPriv");

    final encrypted = await encryptPK(password, encodedPriv);

    log.i("@encrypted: $encrypted");

    await g.didManager.value.setDID(did, Base58Encode(encrypted), password);

    log.i("aa");

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
