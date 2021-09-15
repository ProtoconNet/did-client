import 'dart:convert';
import 'package:wallet/util/secure_storage.dart';

import 'package:wallet/util/crypto.dart';
import 'package:wallet/util/logger.dart';

class DIDManager {
  final log = Log();
  final crypto = Crypto();
  final storage = FlutterSecureStorage();

  Map<String, dynamic> dids = {};
  bool uninitialized = true;

  init() async {
    log.i("DIDManager:init");
    if (await storage.containsKey(key: 'DIDList') == false) {
      await storage.write(key: 'DIDList', value: '{}');
    }
    if (uninitialized) {
      var didListStr = await storage.read(key: "DIDList");
      log.i("didListStr: $didListStr");
      dids = json.decode(didListStr!);
    }
    uninitialized = false;
  }

  setDID(String did, String encodedPriv, String password) async {
    log.i("DIDManager:setDID(did:$did, encodedPriv:$encodedPriv, password:$password)");
    log.i("$did : $encodedPriv : $password");
    dids[did] = encodedPriv;

    await storage.write(key: 'DIDList', value: json.encode(dids));
  }

  String getFirstDID() {
    log.i("DIDManager:getFirstDID");
    return dids.keys.first;
  }

  Future<String> getDIDPK(String did, String password) async {
    log.i("DIDManager:getDIDPK(did:$did, password:$password)");
    return await crypto.decryptPK(dids[did], password);
  }
}
