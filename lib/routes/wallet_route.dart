import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wallet/pages/introduction.dart';
import 'package:wallet/pages/login.dart';
import 'package:wallet/pages/home.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/utils/logger.dart';

class WalletRoute extends StatelessWidget {
  final g = Get.put(GlobalVariable());
  final log = Log();

  init() async {
    await Permission.camera.request();
    return g.didManager.value.dids;
  }

  @override
  Widget build(BuildContext context) {
    log.i("WalletRoute build");
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          log.i('snapshot: ${snapshot.data}');
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if ((snapshot.data as Map<String, dynamic>).keys.isEmpty) {
            return OnBoarding();
          } else {
            if (g.password.value == "") {
              return Login();
            }
            return Home(tabController: g.tabController.value);
          }
        });
  }
}
