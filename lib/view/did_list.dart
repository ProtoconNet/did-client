import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:animations/animations.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:wallet/controller/did_list_controller.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/view/vc_list.dart';
import 'package:wallet/util/logger.dart';

class DIDList extends StatelessWidget {
  final GlobalVariable g = Get.find();
  final log = Log();
  final c = Get.put(DIDListController());
  final storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    log.i("DIDList build");
    return Background(
        mainAxisAlignment: MainAxisAlignment.start,
        appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: Hero(tag: "Wallet", child: Image.asset("assets/icons/walletIcon.png", width: 20, height: 20)),
            // Icon(Icons.account_balance_wallet_rounded, color: Get.theme.primaryColor, size: 30)
            // leading: Image.asset("assets/icons/walletIcon.png", width: 20, height: 20),
            // automaticallyImplyLeading: false,
            title: Text('MITUM Wallet', style: Get.textTheme.headline6),
            actions: [
              IconButton(
                icon: Icon(Icons.delete, color: Get.theme.primaryColor),
                onPressed: () async {
                  // box.remove('themeMode');
                  // box.remove('language');
                  if (await storage.containsKey(key: "DIDList")) {
                    String didList = await storage.read(key: "DIDList") as String;

                    log.i("erase ${json.decode(didList)}");

                    for (var did in json.decode(didList).keys.toList()) {
                      //var didVC = storage.read(key: did) as String;
                      if (await storage.containsKey(key: did)) {
                        await storage.delete(key: did);
                      }
                    }
                    await storage.delete(key: "DIDList");
                  }
                  g.biometric.value = false;

                  // await deleteCacheDir();
                  // await deleteAppDir();
                },
              ),
            ]),
        children: [
          FutureBuilder(
              future: c.getDIDList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    log.i("DID : ${json.encode(snapshot.data)}");
                    final dids = snapshot.data as Map<String, dynamic>;

                    log.i("dids: ${dids.keys}");

                    return Column(children: dids.keys.map((did) => VCList(did: did)).toList());
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ]);
  }
}
