import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/providers/global_variable.dart';

class VCModel {
  final g = Get.put(GlobalVariable());
  String name = "";
  int icon = 0;
  String schemaRequest = "";
  String requestVC = "";
  String getVC = "";
  String jwt = "";
  String vc = "";
  String jsonStr = "";

  VCModel(this.name, this.icon, this.schemaRequest, this.requestVC, this.getVC, this.jwt, this.vc);

  VCModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        icon = json['icon'],
        schemaRequest = json['schemaRequest'],
        requestVC = json['requestVC'],
        getVC = json['getVC'],
        jwt = json['JWT'],
        vc = json['VC'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'icon': icon,
        'schemaRequest': schemaRequest,
        'requestVC': requestVC,
        'getVC': getVC,
        'JWT': jwt,
        'VC': vc
      };
}

class VCManager {
  final g = Get.put(GlobalVariable());
  final storage = FlutterSecureStorage();

  setByName(String name, String field, dynamic value) async {
    // g.log.i("vcList:${await storage.read(key: "VCList") as String}");
    final vcList = json.decode(await storage.read(key: "VCList") as String);

    var restoreVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == name) {
        vc[field] = value;
      }
      restoreVCList.add(vc);
    }
    await storage.write(key: "VCList", value: json.encode(restoreVCList));
    // g.log.i("vcList2:${await storage.read(key: "VCList") as String}");
  }

  addClaim(String value) async {
    final vcList = json.decode(await storage.read(key: "VCList") as String);
    final newVC = json.decode(value);
    var flag = true;
    for (var vc in vcList) {
      if (vc['name'] == newVC['name']) {
        flag = false;
      }
    }
    if (flag) {
      vcList.add(newVC);
    } else {
      g.log.i("Same VC exist");
    }

    await storage.write(key: "VCList", value: json.encode(vcList));

    return flag;
  }

  getByName(String name, String field) async {
    // g.log.i("vcList ${await storage.read(key: "VCList") as String}");
    // g.log.i(name);
    final vcList = json.decode(await storage.read(key: "VCList") as String);

    for (var vc in vcList) {
      if (vc['name'] == name) {
        return vc[field];
      }
    }
  }
}

class DIDManager {
  DIDManager({required this.did});
  final String did;
  final g = Get.put(GlobalVariable());
  final storage = FlutterSecureStorage();

  var vcList = [];

  onInit() async {
    var _vcList = json.decode(await storage.read(key: did) as String);
    for (var item in _vcList) {
      vcList.add(VCModel.fromJson(item));
    }
  }

  addVCClaim(String value) async {
    final vcList = json.decode(await storage.read(key: did) as String);
    // TODO: validate value
    final newVC = json.decode(value);

    var newVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == newVC['name']) {
        newVCList.add(newVC);
      } else {
        newVCList.add(vc);
      }
    }

    await storage.write(key: did, value: json.encode(vcList));
  }

  setVCByName(String name, dynamic value) async {
    final vcList = json.decode(await storage.read(key: did) as String);

    // TODO: value validation
    var restoreVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == name) {
        vc = value;
      }
      restoreVCList.add(vc);
    }
    await storage.write(key: did, value: json.encode(restoreVCList));
    // g.log.i("vcList2:${await storage.read(key: "VCList") as String}");
  }

  getVCByName(String name) async {
    final vcList = json.decode(await storage.read(key: did) as String);

    for (var vc in vcList) {
      if (vc['name'] == name) {
        return vc;
      }
    }
  }

  setVCFieldByName(String name, String field, dynamic value) async {
    final vcList = json.decode(await storage.read(key: did) as String);

    // TODO: value validation
    var restoreVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == name) {
        vc[field] = value;
      }
      restoreVCList.add(vc);
    }
    await storage.write(key: did, value: json.encode(restoreVCList));
  }

  getVCFieldByName(String name, String field) async {
    final vc = await getVCByName(name);
    g.log.i("getVCFieldByName: $vc");
    return vc[field];
  }
}
