import 'package:get/get.dart';

import 'package:wallet/util/logger.dart';

class VCController extends GetxController {
  VCController(this.did, this.icon, this.name, this.description, this.type, this.schemaRequest, this.vc, this.jwt);
  final String did;
  final int icon;
  final String name;
  final String description;
  final String type;
  final String schemaRequest;
  final Map<String, dynamic> vc;
  final String jwt;

  final status = "".obs;
  final log = Log();
}
