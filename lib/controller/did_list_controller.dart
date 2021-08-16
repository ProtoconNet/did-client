import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class DIDListController extends GetxController {
  final GlobalVariable g = Get.find();
  final log = Log();

  getDIDList() async {
    log.i("getDIDList");

    var didList = g.didManager.value.dids;

    log.i("didList: $didList");

    return didList;
  }
}
