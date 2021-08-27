import 'package:get/get.dart';

import 'package:wallet/controller/vc_list_controller.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class VPController extends GetxController {
  VPController(this.did);

  final String did;

  final GlobalVariable g = Get.find();
  final log = Log();

  getVPList() async {
    VCListController vcListController = Get.find();
    // await vcListController.setVCList(did);
    await vcListController.vpManager.readVP();
  }
}
