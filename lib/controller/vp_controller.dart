import 'dart:convert';
import 'package:get/get.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/model/vc_manager.dart';
import 'package:wallet/util/logger.dart';

class VPController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  final storage = FlutterSecureStorage();

  createVP(String did, String keyLocation, String audience, List<Map<String, dynamic>> payload, List<int> pk) async {
    // payload is vc list
    var now = DateTime.now();
    log.i('a');

    var expire = now.add(Duration(minutes: 1));
    log.i('a');
    var vp = {
      "@context": ["https://www.w3.org/2018/credentials/v1", "https://www.w3.org/2018/credentials/examples/v1"],
      "id": did,
      "type": ["VerifiablePresentation"],
      "issuer": did,
      "issuanceDate": now.toIso8601String(),
      "expirationDate": expire.toIso8601String(),
      "verifiableCredential": payload,
    };
    log.i('a');

    // Create a json web token
    final jwt = JWT(vp); //, issuer: did, audience: audience, jwtId: "test");
    log.i('a');

    print(pk);
    var token = jwt.sign(EdDSAPrivateKey(pk),
        algorithm: JWTAlgorithm.EdDSA,
        noIssueAt: true); //, expiresIn: Duration(minutes: 1), notBefore: Duration(seconds: 0));
    log.i('a');

    var splitToken = token.split('.');
    log.i('a');
    var noPayloadToken = splitToken[0] + ".." + splitToken[2];
    print('no payload token: $token\n');

    final jwt2 = JWT.verify(token, EdDSAPublicKey(pk.sublist(32)));
    log.i('a');

    // printWrapped('Payload: ${json.encode(jwt2.payload)}');

    var proof = [
      {
        "type": "Ed25519Signature2018",
        "expire": expire.toIso8601String(),
        "created": now.toIso8601String(),
        "proofPurpose": "authentication",
        "verificationMethod": keyLocation,
        // "challenge": "c0ae1c8e-c7e7-469f-b252-86e6a0e7387e", // random
        // "domain": "test.org", // submit vp domain
        "jws": noPayloadToken // token
      }
    ];
    log.i('a');
    vp['proof'] = proof;
    printWrapped('vp:$vp');

    return vp;
  }

  printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  getVP(vc) async {
    var password = g.password.value;
    var vpSchemaUri = Uri.parse("http://mtm.securekim.com:3082/VPSchema?schema=rentCar");
    http.Response response = await http.get(vpSchemaUri);
    print(response.body);

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
    var decrypted = encrypter.decrypt(encrypted, iv: iv);

    if (decrypted.substring(0, 7) != "WIGGLER") {
      throw Error();
    }

    decrypted = decrypted.substring(7);

    final clearText = Base58Decode(decrypted);

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);
    final pubKey = await keyPair.extractPublicKey();
    final did = 'did:mtm:' + Base58Encode(pubKey.bytes);

    log.i(vc);
    log.i("pk: ${Base58Encode(await keyPair.extractPrivateKeyBytes())}");
    var vp = await createVP(did, did, did, [vc], [...(await keyPair.extractPrivateKeyBytes()), ...pubKey.bytes]);
    log.i(vp);

    return vp;
  }

  testVP() async {
    var password = g.password.value;
    var vpSchemaUri = Uri.parse("http://mtm.securekim.com:3082/VPSchema?schema=rentCar");
    http.Response response = await http.get(vpSchemaUri);
    print(response.body);

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
    var decrypted = encrypter.decrypt(encrypted, iv: iv);

    if (decrypted.substring(0, 7) != "WIGGLER") {
      throw Error();
    }

    decrypted = decrypted.substring(7);

    final clearText = Base58Decode(decrypted);

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);
    final pubKey = await keyPair.extractPublicKey();
    final did = 'did:mtm:' + Base58Encode(pubKey.bytes);

    final vc = await VCManager(did).getByName("Driver's License", "vc");

    log.i(vc);
    log.i("pk: ${Base58Encode(await keyPair.extractPrivateKeyBytes())}");
    var vp = await createVP(did, did, did, [vc], [...(await keyPair.extractPrivateKeyBytes()), ...pubKey.bytes]);

    var vp1SchemaUri = Uri.parse("http://mtm.securekim.com:3082/vp1");
    response = await http.post(
      vp1SchemaUri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: json.encode({"did": did, "vp": vp}),
    );

    log.i("body: ${response.body}");
    log.i("status Code: ${response.statusCode}");

    // JsonEncoder encoder = JsonEncoder.withIndent('  ');
    // String prettyPrint = encoder.convert(vp);

    // printWrapped(prettyPrint);
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
