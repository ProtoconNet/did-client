import 'dart:convert';
import 'package:get/get.dart';

import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/provider/platform.dart';
import 'package:wallet/provider/issuer.dart';
import 'package:wallet/util/logger.dart';

class VPController extends GetxController {
  VPController(this.did, this.schemaRequest);

  final String did;
  final String schemaRequest;
  var schemaList = [].obs;

  final GlobalVariable g = Get.find();
  final log = Log();

  getSchema(schema) async {
    log.i('getSchema:: $schemaRequest :: $schema');
    log.i('*' * 200);
    final issuer = Issuer(schema);
    final platform = Platform();
    var locations = await issuer.getSchemaLocation();

    var response = await platform.getSchema(locations['schema']);
    log.i("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!$response");
    log.i(response.runtimeType);
    if (response.containsKey('error')) {
      return;
    }

    log.i("schema: ${response['data']}, ${response['data'].runtimeType}");

    schemaList.value = json.decode(response['data']);

    log.i("schemaList: $schemaList");

    return true;
  }

  getVPList() async {
    VCListController vcListController = Get.find();
    // await vcListController.setVCList(did);
    await vcListController.vpManager.readVP();
  }
}
