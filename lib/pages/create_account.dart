import 'package:flutter/material.dart';
import 'package:wallet/widgets/background.dart';
import 'package:get/get.dart';

import 'package:wallet/controller/create_account_controller.dart';

class CreateAccount extends StatelessWidget {
  CreateAccount({Key key, this.password}) : super(key: key);

  final String password;
  final CreateAccountController c = Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    return Background(
      child: FutureBuilder<String>(
          future: c.createWallet(password),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: [
                Text('account'.tr, style: Get.theme.textTheme.headline6),
                Card(
                    margin: EdgeInsets.all(10.0),
                    child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(snapshot.data.toString(), style: Get.theme.textTheme.bodyText1))),
                ElevatedButton(
                    onPressed: () async {
                      await c.registerDidDocument(snapshot.data);
                      Get.offAllNamed('/');
                    },
                    child: Text('goToHome'.tr))
              ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
