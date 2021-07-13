import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/widgets/background.dart';
import 'package:wallet/controller/login_controller.dart';

class Login extends StatelessWidget {
  final LoginController c = Get.put(LoginController());
  final g = Get.put(GlobalVariable());
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Form(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text('login'.tr, style: Get.theme.textTheme.headline4),
        Text('inputPassword'.tr, style: Get.theme.textTheme.bodyText1),
        TextFormField(
          autofocus: true,
          controller: _pass,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          onFieldSubmitted: (test) async {
            g.log.i("submit with $test");
            await c.login(_pass.text);
          },
        ),
        ElevatedButton(
            onPressed: () async {
              await c.login(_pass.text);
            },
            child: Text('enter'.tr),
            style: Get.theme.elevatedButtonTheme.style),
      ])),
    );
  }
}
