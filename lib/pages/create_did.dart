import 'package:flutter/material.dart';
import 'package:wallet/widgets/background.dart';
import 'package:get/get.dart';

import 'package:wallet/controller/create_did_controller.dart';

class CreateDID extends StatelessWidget {
  CreateDID({key, required this.password}) : super(key: key);

  final String password;
  final CreateDIDController c = Get.put(CreateDIDController());

  @override
  Widget build(BuildContext context) {
    print("in createdid : $password");
    return Background(children: [
      FutureBuilder<String>(
          future: c.createDID(password),
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
    ]);
  }
}
