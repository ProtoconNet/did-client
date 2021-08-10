import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/models/vc.dart';
import 'package:wallet/utils/logger.dart';

class VCListController extends GetxController {
  VCListController(this.did);

  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();

  final issuer = Issuer();

  final String did;

  VCManager? vcManager;

  @override
  onInit() async {
    super.onInit();

    vcManager = VCManager(did);
    if (vcManager!.vcs.isEmpty) {
      vcManager!.setVC(json.encode(VCModel("운전면허증", "모바일 운전면허증을 등록하면 다양한 인증을 간편하게 처리할 수 있고 오프라인에서도 신분증처럼 사용할 수 있어요",
          "신분증", 57815, "http://mtm.securekim.com:3333/VCSchema?schema=driverLicense", "", {}).toJson()));
      vcManager!.setVC(json.encode(VCModel("제주패스", "렌터카, 맛집, 숙소 등 제주여행에 필요한 다양한 서비스의 혜택을 받아보세요", "멤버십", 59004,
          "http://mtm.securekim.com:3333/VCSchema?schema=jejuPass", "", {}).toJson()));
    }
  }

  getVCList(did) async {
    log.i("getVCList");

    for (var vc in vcManager!.vcs) {
      if (vc.vc.isEmpty && vc.jwt != "") {
        log.i("getVC from issuer");

        var response = await issuer.getVC(Uri.parse(await getGetVC(vc.schemaRequest)), vc.jwt);

        if (json.decode(response.body).containsKey('error')) {
          continue;
        }

        var data = json.decode(response.body)['vc'];

        vc.vc = data;
        await VCManager(did).setByName(vc.name, 'vc', data);
        await VCManager(did).setByName(vc.name, 'jwt', "");
      }
    }
    return vcManager!.vcs;
  }

  getGetVC(String requestSchema) async {
    var response = await issuer.getSchemaLocation(Uri.parse(requestSchema));

    log.i("response.body:${response.body}");

    var endpoints = json.decode(response.body);

    return endpoints['VCGet'];
  }
}
