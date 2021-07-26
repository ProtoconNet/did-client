import 'dart:convert';
import 'package:get/get.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/utils/logger.dart';

class VPTest {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();

  createVP(String did, String keyLocation, List<Map<String, dynamic>> payload, List<int> pk) {
    // payload is vc list

    var now = DateTime.now();

    var expire = now.add(Duration(minutes: 1));
    var vp = {
      "@context": ["https://www.w3.org/2018/credentials/v1", "https://www.w3.org/2018/credentials/examples/v1"],
      "id": did,
      "type": ["VerifiablePresentation"],
      "verifiableCredential": payload,
    };

    // Create a json web token
    final jwt = JWT(
      vp,
      // issuer: 'https://github.com/jonasroussel/dart_jsonwebtoken',
    );

    // Sign it (default with HS256 algorithm)
    print(pk);
    var token = jwt.sign(EdDSAPrivateKey(pk), algorithm: JWTAlgorithm.EdDSA);

    print('Signed token: $token\n');

    final jwt2 = JWT.verify(token, EdDSAPublicKey(pk.sublist(32)));

    print('Payload: ${json.encode(jwt2.payload)}');

    var proof = [
      {
        "type": "Ed25519Signature2018",
        "expire": expire.toIso8601String(),
        "created": now.toIso8601String(),
        "proofPurpose": "authentication",
        "verificationMethod": keyLocation, // "did:example:76e12ec21ebhyu1f712ebc6f1z2/keys/2"
        // "challenge": "c0ae1c8e-c7e7-469f-b252-86e6a0e7387e", // random
        // "domain": "test.org", // submit vp domain
        "jws": token
      }
    ];
    vp['proof'] = proof;

    JsonEncoder encoder = JsonEncoder.withIndent('  ');
    String prettyPrint = encoder.convert(vp);

    log.i(prettyPrint.substring(0, 1000));
    log.i(prettyPrint.substring(900, 1900));
    log.i(prettyPrint.substring(1800, 2700));
    log.i(prettyPrint.substring(2600));
  }

  testVP() async {
    var password = g.password.value;
    final passwordBytes = utf8.encode(password);
    // Generate a random secret key.
    final sink = Sha256().newHashSink();
    sink.add(passwordBytes);
    sink.close();
    final passwordHash = await sink.hash();

    final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final didListStr = await storage.read(key: 'DIDList') as String;
    log.i("didListStr: $didListStr");
    final didList = json.decode(didListStr);
    log.i("did first: $didList, ${didList.runtimeType}");
    final privateKey = didList.values.toList()[0];
    final encrypted = encrypt.Encrypted.fromBase64(base64Encode(Base58Decode(privateKey)));

    final iv = encrypt.IV.fromLength(16);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    final clearText = Base58Decode(decrypted);

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);
    final pubKey = await keyPair.extractPublicKey();
    final did = 'did:mtm:' + Base58Encode(pubKey.bytes);

    final vc = await DIDManager(did: did).getVCByName("Driver's License");

    log.i(vc);
    createVP(did, did, [vc['VC']], [...(await keyPair.extractPrivateKeyBytes()), ...pubKey.bytes]);
  }

  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        log.i(response.body);
        return response;
      default:
        log.lw("Response Error $response");
        return response;
      // throw Error();
    }
  }
}
