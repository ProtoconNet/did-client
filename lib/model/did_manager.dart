import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/util/crypto.dart';
import 'package:wallet/util/logger.dart';

class DIDManager {
  final log = Log();
  final crypto = Crypto();
  final storage = FlutterSecureStorage();

  Map<String, dynamic> dids = {};
  bool uninitialized = true;

  init() async {
    if (!await storage.containsKey(key: 'DIDList')) {
      await storage.write(key: 'DIDList', value: '{}');
    }
    if (uninitialized) {
      var didListStr = await storage.read(key: "DIDList") as String;
      log.i("didListStr: $didListStr");
      dids = json.decode(didListStr);
    }
    uninitialized = false;
  }

  setDID(did, encodedPriv, password) async {
    log.i("$did : $encodedPriv : $password");
    dids[did] = encodedPriv;

    await storage.write(key: 'DIDList', value: json.encode(dids));
  }

  getFirstDID() {
    return dids.keys.first;
  }

  getDIDPK(String did, String password) async {
    return crypto.decryptPK(dids[did], password);
  }
}
