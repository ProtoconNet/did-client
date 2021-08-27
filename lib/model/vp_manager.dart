import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/model/vp.dart';
import 'package:wallet/util/logger.dart';

class VPManager {
  VPManager(this.did);
  final String did;

  final log = Log();
  final storage = FlutterSecureStorage();

  RxList<VPModel> vps = <VPModel>[].obs;
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
            "http://mtm.securekim.com:3082/VPSchema?schema=rentCar", [
          {
            "name": "운전면허증",
            "required": ["성명", "생년월일"]
          },
          {
            "name": "제주패스",
            "required": ["성명", "구매번호"]
          },
        ]).toJson()));
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

  readVP() async {
    final vpList = json.decode(await storage.read(key: did + ":vp") as String);
    log.i("vcList: $vpList");
    vps.value = [];

    for (var vp in vpList) {
      vps.add(VPModel.fromJson(vp));
    }
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
