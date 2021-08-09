import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/providers/vc.dart';
import 'package:wallet/utils/logger.dart';

class VCListController extends GetxController {
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();
  final issuer = Issuer();

  getVCList(did) async {
    log.i("getVCList");
    if (!(await storage.containsKey(key: did))) {
      // final staticVCList = json.decode(dotenv.env['STATIC_VC_LIST'] as String);
      // log.i('staticVCList', staticVCList);
      List<VC> staticVCList = [
        VC("운전면허증", "모바일 운전면허증을 등록하면 다양한 인증을 간편하게 처리할 수 있고 오프라인에서도 신분증처럼 사용할 수 있어요", "신분증", 57815,
            "http://mtm.securekim.com:3333/VCSchema?schema=driverLicense", "", {}),
        VC("제주패스", "렌터카, 맛집, 숙소 등 제주여행에 필요한 다양한 서비스의 혜택을 받아보세요", "멤버십", 59004,
            "http://mtm.securekim.com:3333/VCSchema?schema=jejuPass", "", {}),
      ];
      await storage.write(key: did, value: json.encode(staticVCList));
    }

    log.i("vc list: ${await storage.read(key: did) as String}");

    var vcList = json.decode(await storage.read(key: did) as String);

    List<Map<String, dynamic>> retVCList = [];
    for (var vc in vcList) {
      log.i(vc);
      log.i(vc['vc']);
      log.i(vc['jwt']);
      if (vc['vc'].isEmpty && vc['jwt'] != "") {
        log.i("getVC from issuer");
        // log.i(vc['vc']);
        // log.i(vc['jwt']);

        var response = await issuer.getVC(Uri.parse(await getGetVC(vc['requestSchema'])), vc['jwt']);

        if (json.decode(response.body).containsKey('error')) {
          continue;
        }

        // log.i(response.body);
        var data = json.decode(response.body)['vc'];
        // log.i(data);
        // if (data.containedKey("VC")) {
        vc['vc'] = data;
        await DIDManager(did: did).setVCFieldByName(vc['name'], 'vc', data);
        await DIDManager(did: did).setVCFieldByName(vc['name'], 'jwt', "");
        //}
      }
      retVCList.add(vc);
    }
    log.i(retVCList.runtimeType);
    return retVCList;
  }

  getGetVC(String requestSchema) async {
    var response = await issuer.getSchemaLocation(Uri.parse(requestSchema));

    log.i("response.body:${response.body}");

    var endpoints = json.decode(response.body);

    return endpoints['VCGet'];
  }
}
