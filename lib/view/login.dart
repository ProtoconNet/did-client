import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:biometric_storage/biometric_storage.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/widget/gradient_icon.dart';
import 'package:wallet/controller/login_controller.dart';
import 'package:wallet/util/logger.dart';

class Login extends StatelessWidget {
  final LoginController c = Get.put(LoginController());
  final g = Get.put(GlobalVariable());
  final log = Log();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(children: [
      Form(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        GradientIcon(
          FontAwesomeIcons.wallet,
          80,
          LinearGradient(
            colors: [Get.theme.primaryColor, Get.theme.accentColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        Text('login'.tr, style: Get.theme.textTheme.headline4),
        // Text('inputPassword'.tr, style: Get.theme.textTheme.bodyText1),
        Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
                height: 50,
                width: Get.width * 0.8, // <-- match_parent
                child: TextFormField(
                  autofocus: true,
                  controller: _pass,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  onFieldSubmitted: (test) async {
                    log.i("submit with $test");
                    await c.login(_pass.text);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                    // prefixIcon: Icon(Icons.perm_identity),
                  ),
                ))),
        Padding(
            padding: EdgeInsets.all(8),
            child: SizedBox(
                height: 50,
                width: Get.width * 0.8, // <-- match_parent
                child: ElevatedButton(
                    onPressed: () async {
                      await c.login(_pass.text);
                    },
                    child: Text('enter'.tr),
                    style: Get.theme.elevatedButtonTheme.style))),

        Padding(
            padding: EdgeInsets.all(8),
            child: CheckboxListTile(
              title: Text("다음부터 생체인식 사용하기"),
              value: g.biometric,
              onChanged: (newValue) async {
                g.setBiometric(newValue!);
              },
              controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
            )),
      ])),
    ]);
  }
}
