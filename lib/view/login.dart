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
        Column(children: [
          Container(
              alignment: Alignment.center,
              width: 100,
              height: 40.0,
              decoration:
                  BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]), boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                ),
              ]),
              child: Text('MITUM', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900))),
          Text('Wallet', style: Get.textTheme.headline2?.copyWith(fontWeight: FontWeight.w900)),
        ]),
        Hero(tag: "Wallet", child: Image.asset("assets/images/wallet.png", width: 180, height: 180)),
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
                    await c.passwordLogin(_pass.text);
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
                      await c.passwordLogin(_pass.text);
                    },
                    child: Text('enter'.tr)))),
        FutureBuilder(
          future: c.canBiometricAuth(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == true) {
              return Padding(
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
                      ])));
            } else {
              return SizedBox();
            }
          },
        )
      ])),
    ]);
  }
}
