import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
// import 'package:wallet/widget/gradient_icon.dart';
import 'package:wallet/controller/login_controller.dart';
import 'package:wallet/util/logger.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  final LoginController c = Get.put(LoginController());

  final GlobalVariable g = Get.find();
  final log = Log();

  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log.i("Login:build");
    _pass.addListener(() {
      c.onError.value = false;
    });
    return Background(children: [
      Form(
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(children: [
          Image.asset('assets/images/protocon_logo_horizon.png', width: 130),
          Text('Wallet', style: Get.textTheme.headline2?.copyWith(fontWeight: FontWeight.w900)),
        ]),
        Hero(tag: "Wallet", child: Image.asset("assets/images/wallet.png", width: 180, height: 180)),
        const SizedBox(height: 30),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              Obx(() {
                if (c.onError.value) {
                  return SizedBox(
                      width: Get.width * 0.8,
                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                        Text('비밀번호가 일치하지 않습니다.', style: Get.textTheme.caption!.copyWith(color: Colors.red))
                      ]));
                } else {
                  return const SizedBox(height: 0);
                }
              }),
              SizedBox(
                  height: 50,
                  width: Get.width * 0.8, // <-- match_parent
                  child: Obx(() => TextFormField(
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
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: c.onError.value ? Colors.red : Get.theme.primaryColor, width: 1.0)),
                          hintText: '비밀번호',
                          // prefixIcon: Icon(Icons.perm_identity),
                        ),
                      )))
            ])),
        Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
                height: 50,
                width: Get.width * 0.8, // <-- match_parent
                child: ElevatedButton(
                    onPressed: () async {
                      await c.passwordLogin(_pass.text);
                    },
                    child: Text('enter'.tr, style: Get.textTheme.button!.copyWith(color: Colors.white))))),
        FutureBuilder(
          future: c.canBiometricAuth(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == true) {
              return Padding(
                  padding: const EdgeInsets.all(8),
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
                              shape: const CircleBorder()),
                        ),
                        const Text("다음부터 생체인식 사용하기")
                      ])));
            } else {
              return const SizedBox();
            }
          },
        )
      ])),
    ]);
  }
}
