import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
// import 'package:wallet/widget/gradient_icon.dart';
import 'package:wallet/controller/login_controller.dart';
import 'package:wallet/util/logger.dart';

class Login extends StatelessWidget {
  final LoginController c = Get.put(LoginController());
  final GlobalVariable g = Get.find();
  final log = Log();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Background(children: [
      Form(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Hero(tag: "Wallet", child: Image.asset("assets/icons/walletIcon.png", width: 100, height: 100)),
        SizedBox(height: 30),
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
            child: SizedBox(
                height: 30,
                width: Get.width * 0.8, // <-- match_parent
                child: Row(children: [
                  Obx(
                    () => Checkbox(
                        checkColor: Colors.white,
                        activeColor: Get.theme.primaryColor,
                        value: g.biometric.value,
                        onChanged: (value) {
                          g.biometric.value = value!;
                        },
                        shape: CircleBorder()),
                  ),
                  Text("다음부터 생체인식 사용하기")
                ]))),
      ])),
    ]);
  }
}
