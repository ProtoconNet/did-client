import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/model/vp.dart';
import 'package:wallet/util/logger.dart';

class VPManager {
  VPManager(this.did);
  final log = Log();
  final storage = FlutterSecureStorage();

  final String did;
  List<VPModel> vps = [];
  bool uninitialized = true;

  init() async {
    if (uninitialized) {
      uninitialized = false;
      if (await storage.containsKey(key: did + ":vp")) {
        final vpList = json.decode(await storage.read(key: did + ":vp") as String);

        for (var vp in vpList) {
          vps.add(VPModel.fromJson(vp));
        }
      } else if (vps.isEmpty) {
        setVP(json.encode(VPModel("SK 렌터카", "모바일 운전면허증과 제주패스가 있으면 렌터카 할인을 받을 수 있어요", "할인", 57815,
            "http://mtm.securekim.com:3333/VPSchema?schema=driverLicense", ['jejupass', 'drivers license']).toJson()));
      }
    }
  }

  setVP(String value) async {
    await init();

    final newVP = VPModel.fromJson(json.decode(value));

    var flag = true;
    for (var vp in vps) {
      if (vp.name == newVP.name) {
        flag = false;
      }
    }

    if (flag) {
      vps.add(newVP);
    } else {
      log.w("Same VP exist");
    }

    await storage.write(key: did + ":vp", value: json.encode(vps.map((e) => e.toJson()).toList()));

    return flag;
  }

  getVP(String name) async {
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        return vp;
      }
    }
  }

  setByName(String name, String field, dynamic value) async {
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        vp.setField(field, value);
      }
    }
    await storage.write(key: did + ":vp", value: json.encode(vps.map((e) => e.toJson()).toList()));
  }

  getByName(String name, String field) async {
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        return vp.getField(field);
      }
    }
  }
}
