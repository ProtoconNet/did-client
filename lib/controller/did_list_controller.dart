import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/utils/logger.dart';

class DIDListController extends GetxController {
  final g = Get.put(GlobalVariable());
  final log = Log();

  getDIDList() async {
    log.i("getDIDList");

    var didList = g.didManager.value.dids;

    log.i("didList: $didList");

    return didList;
  }
}
