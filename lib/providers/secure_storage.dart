import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wallet/providers/global_variable.dart';

class VC {
  final g = Get.put(GlobalVariable());
  String name;
  int icon;
  String schemaRequest;
  String requestVC;
  String getVC;
  String jwt;
  String vc;
  String jsonStr;

  VC(this.name, this.icon, this.schemaRequest, this.requestVC, this.getVC, this.jwt, this.vc);

  VC.fromJson(Map<String, dynamic> json)
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
    // g.log.i("vcList:${await storage.read(key: "VCList")}");
    final vcList = json.decode(await storage.read(key: "VCList"));

    var restoreVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == name) {
        vc[field] = value;
      }
      restoreVCList.add(vc);
    }
    await storage.write(key: "VCList", value: json.encode(restoreVCList));
    // g.log.i("vcList2:${await storage.read(key: "VCList")}");
  }

  addClaim(String value) async {
    final vcList = json.decode(await storage.read(key: "VCList"));
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
    // g.log.i("vcList ${await storage.read(key: "VCList")}");
    // g.log.i(name);
    final vcList = json.decode(await storage.read(key: "VCList"));

    for (var vc in vcList) {
      if (vc['name'] == name) {
        return vc[field];
      }
    }
  }
}

class DID {
  DID(key, this.did);
  final String did;
  final g = Get.put(GlobalVariable());
  final storage = FlutterSecureStorage();

  var vcList = [];

  onInit() async {
    var _vcList = json.decode(await storage.read(key: did));
    for (var item in _vcList) {
      vcList.add(VC.fromJson(item));
    }
  }

  addVCClaim(String value) async {
    final vcList = json.decode(await storage.read(key: did));
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
    final vcList = json.decode(await storage.read(key: did));

    // TODO: value validation
    var restoreVCList = [];
    for (var vc in vcList) {
      if (vc['name'] == name) {
        vc = value;
      }
      restoreVCList.add(vc);
    }
    await storage.write(key: did, value: json.encode(restoreVCList));
    // g.log.i("vcList2:${await storage.read(key: "VCList")}");
  }

  getVCByName(String name) async {
    final vcList = json.decode(await storage.read(key: did));

    for (var vc in vcList) {
      if (vc['name'] == name) {
        return vc;
      }
    }
  }

  setVCFieldByName(String name, String field, dynamic value) async {
    final vcList = json.decode(await storage.read(key: did));

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
    final vc = getVCByName(name);
    return vc[field];
  }
}
