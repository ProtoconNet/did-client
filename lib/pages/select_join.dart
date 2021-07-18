import 'package:flutter/material.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/widgets/background.dart';
import 'package:get/get.dart';

import 'package:wallet/pages/create_wallet.dart';
import 'package:wallet/utils/logger.dart';

class SelectJoin extends StatelessWidget {
  final g = Get.put(GlobalVariable());
  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i('SelectCreateAccount');
    return Background(
      child: Form(
//          key: c._formKey.value,
          child: Center(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
              child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Padding(padding: EdgeInsets.all(10.0), child: Icon(Icons.wallet_membership)),
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('DID Wallet',
                            style: Get.theme.textTheme.headline5
                                ?.copyWith(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                        Text('Wiggler Inc.', style: Get.theme.textTheme.subtitle2)
                      ])
                    ],
                  )),
              Image.asset('assets/images/img3.jpeg'),
              Padding(padding: EdgeInsets.all(20.0), child: Text("noAccount".tr, style: Get.theme.textTheme.bodyText1))
            ],
          )),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWallet()));
              },
              child: Text('createAccount'.tr)),
          // ElevatedButton(
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));
          //     },
          //     child: Text('importAccount'.tr))
        ],
      ))),
    );
  }
}
