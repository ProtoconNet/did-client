import 'dart:convert';
import 'package:get/get.dart';

import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/provider/platform.dart';
import 'package:wallet/provider/issuer.dart';
import 'package:wallet/model/vp.dart';
import 'package:wallet/model/vc.dart';
import 'package:wallet/util/logger.dart';

class VPController extends GetxController {
  VPController(this.did, this.schemaRequest);

  final String did;
  final String schemaRequest;
  var schemaList = [].obs;

  final GlobalVariable g = Get.find();
  final log = Log();

  final VCListController vcListController = Get.find();

  Future<bool?> getSchema(String schema) async {
    log.i("VPController:getSchema(schema:$schema)");
    log.i('getSchema:: $schemaRequest :: $schema');
    final issuer = Issuer(schema);
    final platform = Platform();
    var locations = await issuer.getSchemaLocation();

    var response = await platform.getSchema(locations['schema']);
    log.i("response: $response");
    if (response.data.containsKey('error')) {
      return null;
    }

    log.i("schema: ${response.data}, ${response.data.runtimeType}");

    schemaList.value = json.decode(response.data);

    log.i("schemaList: $schemaList");

    return true;
  }

  getVPList() async {
    log.i("VPController:getVPList");
    VCListController vcListController = Get.find();
    // await vcListController.setVCList(did);
    await vcListController.vpManager.loadVP();
  }

  bool? vpActiveCheck(String name, VPModel vp, List<VCModel> vcs) {
    var vpMatching = false;
    for (var vc in vp.vc) {
      if (vc['name'] == name) {
        vpMatching = true;
        break;
      }
    }
    if (vpMatching == false) {
      return null;
    }

    var vcHoldCount = 0;

    for (var vc in vcListController.vcManager.vcs) {
      for (var requiredVC in vp.vc) {
        if (requiredVC['name'] == vc.name && vc.vc.isNotEmpty) {
          vcHoldCount++;
          break;
        }
      }
    }
    log.i(vcHoldCount);

    if (vp.vc.length == vcHoldCount) {
      return true;
    } else {
      return false;
    }
  }
}
