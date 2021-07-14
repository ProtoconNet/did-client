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

  getVCList(did) async {
    g.log.i("getVCList");
    if (!(await storage.containsKey(key: did))) {
      final staticVCList = json.decode(dotenv.env['STATIC_VC_LIST'] as String);
      g.log.i('staticVCList', staticVCList);
      await storage.write(key: did, value: json.encode(staticVCList));
    }

    g.log.i("vc list: ${await storage.read(key: did) as String}");

    var vcList = json.decode(await storage.read(key: did) as String);

    List<Map<String, dynamic>> retVCList = [];
    for (var vc in vcList) {
      if (vc['VC'].isEmpty && vc['JWT'] != "") {
        g.log.i("getVC from issuer");
        // g.log.i(vc['VC']);
        // g.log.i(vc['JWT']);
        var response = await issuer.getVC(Uri.parse(vc['getVC']), vc['JWT']);

        if (json.decode(response.body).containsKey('error')) {
          // return;
          break;
        }

        // g.log.i(response.body);
        var data = json.decode(response.body)['VC'];
        // g.log.i(data);
        // if (data.containedKey("VC")) {
        vc['VC'] = data;
        await DIDManager(did: did).setVCFieldByName(vc['name'], 'VC', data);
        await DIDManager(did: did).setVCFieldByName(vc['name'], 'JWT', "");
        //}
      }
      retVCList.add(vc);
    }
    print(retVCList.runtimeType);
    return retVCList;
  }
}
