import 'dart:convert';
import 'package:get/get.dart';
import 'package:wallet/util/secure_storage.dart';

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
    log.i("VPManager:init");
    if (uninitialized) {
      uninitialized = false;
      if (await storage.containsKey(key: did + ":vp") == true) {
        final vpList = json.decode((await storage.read(key: did + ":vp"))!);

        for (var vp in vpList) {
          vps.add(VPModel.fromJson(vp));
        }
      } else if (vps.isEmpty) {
        setVP(json.encode(
            VPModel("SK 렌터카", "모바일 운전면허증과 제주패스가 있으면 렌터카 할인을 받을 수 있어요", "할인", 57815, "http://mtm.securekim.com:3082")
                .toJson()));
      }
    }
  }

  Future<bool> setVP(String value) async {
    log.i("VPManager:setVP(value:$value)");
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

  loadVP() async {
    log.i("VPManager:readVP");
    final vpList = json.decode((await storage.read(key: did + ":vp"))!);
    log.i("vcList: $vpList");
    vps.value = [];

    for (var vp in vpList) {
      vps.add(VPModel.fromJson(vp));
    }
  }

  Future<VPModel?> getVP(String name) async {
    log.i("VPManager:getVP(name:$name)");
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        return vp;
      }
    }
    return null;
  }

  setByName(String name, String field, dynamic value) async {
    log.i("VPManager:setByName(name:$name, field:$field, value:$value)");
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        vp.setField(field, value);
      }
    }
    await storage.write(key: did + ":vp", value: json.encode(vps.map((e) => e.toJson()).toList()));
  }

  Future<dynamic> getByName(String name, String field) async {
    log.i("VPManager:getByName(name:$name, field:$field)");
    await init();
    for (var vp in vps) {
      if (vp.name == name) {
        return vp.getField(field);
      }
    }
    return null;
  }
}
