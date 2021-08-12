import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

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
