import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/util/secure_storage.dart';

import 'package:wallet/controller/did_list_controller.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/view/vc_list.dart';
import 'package:wallet/view/create_wallet.dart';
import 'package:wallet/util/logger.dart';

import 'package:wallet/view/step.dart';

class DIDList extends StatelessWidget {
  DIDList({Key? key}) : super(key: key);
  final GlobalVariable g = Get.find();
  final log = Log();

  final storage = FlutterSecureStorage();

  final c = DIDListController();

  @override
  Widget build(BuildContext context) {
    log.i("DIDList:build");

    return Background(
        mainAxisAlignment: MainAxisAlignment.start,
        appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: Hero(tag: "Wallet", child: Image.asset("assets/images/wallet.png", scale: 4)),
            title: Text('Protocon Wallet', style: Get.textTheme.headline6),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PopupMenuButton(
                    child: Icon(Icons.more_vert, color: Get.theme.primaryColor, size: 32),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: TextButton(
                              child: const Text('Erase All Data'),
                              onPressed: () async {
                                await c.eraseAll();

                                Get.offAll(CreateWallet());
                              },
                            ),
                          ),
                        ]),
              ),
            ]),
        children: g.didManager.value.dids.keys.map((did) => VCList(did: did)).toList());
  }
}
