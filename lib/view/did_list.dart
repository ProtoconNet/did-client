import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:animations/animations.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/controller/did_list_controller.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/view/vc_list.dart';
import 'package:wallet/util/logger.dart';

class DIDList extends StatelessWidget {
  final g = Get.put(GlobalVariable());
  final log = Log();
  final c = Get.put(DIDListController());

  @override
  Widget build(BuildContext context) {
    log.i("DIDList build");
    return Background(
        mainAxisAlignment: MainAxisAlignment.start,
        appBar: AppBar(
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: Icon(Icons.account_balance_wallet_rounded, color: Get.theme.primaryColor),
            // automaticallyImplyLeading: false,
            title: Text('내 지갑', style: TextStyle(color: Get.theme.primaryColor)),
            // Center(
            //     child: Text('Mitum DID',
            //         style: GoogleFonts.kaushanScript(
            //             textStyle: Get.theme.textTheme.headline5?.copyWith(color: Colors.white)))),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.add, color: Get.theme.primaryColor)),
              IconButton(onPressed: () {}, icon: Icon(Icons.more_vert, color: Get.theme.primaryColor))
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