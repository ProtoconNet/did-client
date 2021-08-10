import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/models/vc.dart';
import 'package:wallet/utils/logger.dart';

class DIDManager {
  final log = Log();
  final storage = FlutterSecureStorage();

  Map<String, dynamic> dids = {};
  bool uninitialized = true;

  init() async {
    if (!await storage.containsKey(key: 'DIDList')) {
      await storage.write(key: 'DIDList', value: '{}');
    }
    if (uninitialized) {
      var didListStr = await storage.read(key: "DIDList") as String;
      dids = json.decode(didListStr);
    }
    uninitialized = false;
  }

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

  setDID(did, encodedPriv, password) async {
    await init();

    final encryptedPK = encryptPK(password, encodedPriv);

    dids[did] = Base58Encode(encryptedPK);
    await storage.write(key: 'DIDList', value: json.encode(dids));
  }

  getDIDPK(did, password) async {
    await init();

    try {
      final passwordBytes = utf8.encode(password);
      // Generate a random secret key.
      final sink = Sha256().newHashSink();
      sink.add(passwordBytes);
      sink.close();
      final passwordHash = await sink.hash();

      final encrypted = encrypt.Encrypted.fromBase64(base64Encode(Base58Decode(dids[did])));

      final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final iv = encrypt.IV.fromLength(16);
      var decrypted = encrypter.decrypt(encrypted, iv: iv);

      if (decrypted.substring(0, 7) != "WIGGLER") {
        throw Error();
      }

      decrypted = decrypted.substring(7);

      return decrypted;
    } catch (e) {
      log.e(e);
    }
  }
}

class VCManager {
  VCManager(this.did);
  final log = Log();
  final storage = FlutterSecureStorage();

  final String did;
  List<VCModel> vcs = [];
  bool uninitialized = true;

  init() async {
    if (uninitialized && await storage.containsKey(key: did)) {
      final vcList = json.decode(await storage.read(key: did) as String);

      for (var vc in vcList) {
        vcs.add(VCModel.fromJson(vc));
      }
    }
    uninitialized = false;
  }

  setVC(String value) async {
    await init();

    final newVC = VCModel.fromJson(json.decode(value));

    var flag = true;
    for (var vc in vcs) {
      if (vc.name == newVC.name) {
        flag = false;
      }
    }

    if (flag) {
      vcs.add(newVC);
    } else {
      log.w("Same VC exist");
    }

    await storage.write(key: did, value: json.encode(vcs.map((e) => e.toJson()).toList()));

    return flag;
  }

  getVC(String name) async {
    await init();
    for (var vc in vcs) {
      if (vc.name == name) {
        return vc;
      }
    }
  }

  setByName(String name, String field, dynamic value) async {
    await init();
    for (var vc in vcs) {
      if (vc.name == name) {
        vc.setField(field, value);
      }
    }
    await storage.write(key: did, value: json.encode(vcs.map((e) => e.toJson()).toList()));
  }

  getByName(String name, String field) async {
    await init();
    for (var vc in vcs) {
      if (vc.name == name) {
        return vc.getField(field);
      }
    }
  }
}
