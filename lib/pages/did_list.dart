import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:animations/animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/controller/did_list_controller.dart';
import 'package:wallet/widgets/background.dart';
import 'package:wallet/pages/vc_list_new.dart';

class DIDList extends StatelessWidget {
  final g = Get.put(GlobalVariable());
  final c = Get.put(DIDListController());

  @override
  Widget build(BuildContext context) {
    g.log.i("DIDList build");
    return Background(
        mainAxisAlignment: MainAxisAlignment.start,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
              child: Text('Mitum DID',
                  style: GoogleFonts.kaushanScript(
                      textStyle: Get.theme.textTheme.headline5.copyWith(color: Colors.white)))),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                  future: c.getDIDList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        g.log.i("DID : ${json.encode(snapshot.data)}");
                        print(snapshot.data);

                        List<Widget> didList = [];
                        for (var did in snapshot.data) {
                          g.log.i(did.runtimeType);
                          g.log.i("DID : $did");
                          print(did);
                          didList.add(VCListNew(did: did));
                        }
                        return Column(children: didList);
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  })
            ]));
  }
}
