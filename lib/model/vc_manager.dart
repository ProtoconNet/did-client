import 'dart:convert';
import 'package:get/get.dart';
import 'package:wallet/util/secure_storage.dart';

import 'package:wallet/model/vc.dart';
import 'package:wallet/util/logger.dart';

class VCManager {
  VCManager(this.did);
  final log = Log();
  final storage = FlutterSecureStorage();

  final String did;
  RxList<VCModel> vcs = <VCModel>[].obs;
  bool uninitialized = true;

  init() async {
    log.i("VCManager:init");
    if (uninitialized) {
      uninitialized = false;
      if ((await storage.containsKey(key: did)) == true) {
        log.i("have vc in did");
        await readVC();
      } else if (vcs.isEmpty) {
        log.i("don't have vc in did");
        setVC(json.encode(VCModel(
            "driverLicense",
            "운전면허증",
            "모바일 운전면허증을 등록하면 다양한 인증을 간편하게 처리할 수 있고 오프라인에서도 신분증처럼 사용할 수 있어요",
            "신분증",
            57815,
            "http://mtm.securekim.com:3333",
            "schemaID1",
            "credentialDefinitionID1",
            "[]",
            "", {}).toJson()));
        setVC(json.encode(VCModel(
            "protoconPass",
            "Protocon Pass",
            "렌터카, 맛집, 숙소 등 여행에 필요한 다양한 서비스의 혜택을 받아보세요",
            "멤버십",
            59004,
            "http://mtm.securekim.com:3333",
            "schemaID2",
            "credentialDefinitionID2",
            '[{"name":"buyId", "type":"string", "required":true, "reason":"protocon pass buy id connect with did"}]',
            "", {}).toJson()));
      }
    }
  }

  readVC() async {
    log.i("VCManager:readVC");
    final vcList = json.decode(await storage.read(key: did) as String);
    vcs.value = [];

    for (var vc in vcList) {
      vcs.add(VCModel.fromJson(vc));
    }
  }

  Future<bool> setVC(String value) async {
    log.i("VCManager:setVC(value:$value)");
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

  VCModel? getVC(String name) {
    log.i("VCManager:getVC(name:$name)");
    for (var vc in vcs) {
      if (vc.name == name) {
        return vc;
      }
    }
    return null;
  }

  setByName(String name, String field, dynamic value) async {
    log.i("VCManager:setByName(name:$name, field:$field, value:$value)");
    for (var vc in vcs) {
      if (vc.name == name) {
        vc.setField(field, value);
      }
    }
    await storage.write(key: did, value: json.encode(vcs.map((e) => e.toJson()).toList()));
  }

  getByName(String name, String field) async {
    log.i("VCManager:getByName(name:$name, field:$field)");
    for (var vc in vcs) {
      if (vc.name == name) {
        return vc.getField(field);
      }
    }
  }
}
