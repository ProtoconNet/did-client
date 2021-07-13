import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/providers/global_variable.dart';

class VCListController extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final issuer = Issuer();

  getVCList() async {
    g.log.i("getVCList");
    if (!(await storage.containsKey(key: "VCList"))) {
      final staticVCList = json.decode(dotenv.env['STATIC_VC_LIST']);
      await storage.write(key: "VCList", value: json.encode(staticVCList));
    }

    g.log.i(await storage.read(key: "VCList"));

    var vcList = json.decode(await storage.read(key: "VCList"));

    var retVCList = [];
    for (var vc in vcList) {
      if (vc['VC'] == "" && vc['JWT'] != "") {
        // g.log.i("getVC from issuer");
        // g.log.i(vc['VC']);
        // g.log.i(vc['JWT']);
        var response = issuer.getVC(Uri.parse(vc['getVC']), vc['JWT']);

        if (json.decode(response.body).containsKey('error')) {
          // return;
          break;
        }

        // g.log.i(response.body);
        var data = json.decode(response.body)['VC'];
        // g.log.i(data);
        // if (data.containedKey("VC")) {
        vc['VC'] = data;
        await VCManager().setByName(vc['name'], 'VC', data);
        await VCManager().setByName(vc['name'], 'JWT', "");
        //}
      }
      retVCList.add(vc);
    }
    return retVCList;
  }
}

class VCListControllerNew extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final issuer = Issuer();

  getVCList(did) async {
    g.log.i("getVCList");
    if (!(await storage.containsKey(key: did))) {
      final staticVCList = json.decode(dotenv.env['STATIC_VC_LIST']);
      g.log.i('staticVCList', staticVCList);
      await storage.write(key: did, value: json.encode(staticVCList));
    }

    g.log.i("vc list:", await storage.read(key: did));

    var vcList = json.decode(await storage.read(key: did));

    var retVCList = [];
    for (var vc in vcList) {
      if (vc['VC'] == "" && vc['JWT'] != "") {
        // g.log.i("getVC from issuer");
        // g.log.i(vc['VC']);
        // g.log.i(vc['JWT']);
        var response = issuer.getVC(Uri.parse(vc['getVC']), vc['JWT']);

        if (json.decode(response.body).containsKey('error')) {
          // return;
          break;
        }

        // g.log.i(response.body);
        var data = json.decode(response.body)['VC'];
        // g.log.i(data);
        // if (data.containedKey("VC")) {
        vc['VC'] = data;
        await VCManager().setByName(vc['name'], 'VC', data);
        await VCManager().setByName(vc['name'], 'JWT', "");
        //}
      }
      retVCList.add(vc);
    }
    return retVCList;
  }
}
