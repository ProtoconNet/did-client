import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/providers/platform.dart';
import 'package:wallet/utils/logger.dart';

class CreateDIDController extends GetxController {
  final storage = FlutterSecureStorage();
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

  Future<String> createDID(String password) async {
    final passwordBytes = utf8.encode(password);

    var keyPair = await generateKeyPair();
    var encodedPriv = keyPair[0];
    var encodedPub = keyPair[1];

    final did = 'did:mtm:' + encodedPub;
    g.inputDID(did);

    final sink = Sha256().newHashSink();
    sink.add(passwordBytes);
    sink.close();
    final passwordHash = await sink.hash();

    final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromLength(16);

    final encrypted = encrypter.encrypt(encodedPriv, iv: iv);

    writeDID(did, encrypted.bytes);

    return did;
  }

  writeDID(did, encryptedPK) async {
    if (!await storage.containsKey(key: 'DIDList')) {
      await storage.write(key: 'DIDList', value: '{}');
    }
    var didListStr = await storage.read(key: 'DIDList') as String;
    var didList = json.decode(didListStr);
    didList[did] = Base58Encode(encryptedPK);
    await storage.write(key: 'DIDList', value: json.encode(didList));
    // await storage.write(key: did, value: Base58Encode(encrypted.bytes));
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
