import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/model/vc.dart';
import 'package:wallet/util/logger.dart';

class VCManager {
  VCManager(this.did);
  final log = Log();
  final storage = FlutterSecureStorage();

  final String did;
  List<VCModel> vcs = [];
  bool uninitialized = true;

  init() async {
    if (uninitialized) {
      uninitialized = false;
      if (await storage.containsKey(key: did)) {
        final vcList = json.decode(await storage.read(key: did) as String);

        for (var vc in vcList) {
          vcs.add(VCModel.fromJson(vc));
        }
      } else if (vcs.isEmpty) {
        setVC(json.encode(VCModel("운전면허증", "모바일 운전면허증을 등록하면 다양한 인증을 간편하게 처리할 수 있고 오프라인에서도 신분증처럼 사용할 수 있어요", "신분증",
            57815, "http://mtm.securekim.com:3333/VCSchema?schema=driverLicense", "", {}).toJson()));
        setVC(json.encode(VCModel("제주패스", "렌터카, 맛집, 숙소 등 제주여행에 필요한 다양한 서비스의 혜택을 받아보세요", "멤버십", 59004,
            "http://mtm.securekim.com:3333/VCSchema?schema=jejuPass", "", {}).toJson()));
      }
    }
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
