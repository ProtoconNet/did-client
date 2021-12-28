import 'package:flutter/material.dart';
import 'package:wallet/widget/background.dart';
import 'package:get/get.dart';

import 'package:wallet/widget/gradient_button.dart';
import 'package:wallet/controller/create_did_controller.dart';
import 'package:wallet/view/login.dart';

import 'package:wallet/util/logger.dart';

class CreateDID extends StatelessWidget {
  CreateDID({key, required this.password}) : super(key: key);

  final String password;
  final CreateDIDController c = Get.put(CreateDIDController());

  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i("CreateDID:build");
    return Background(children: [
      FutureBuilder<String>(
          future: c.createDID(password),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                  width: Get.width * 0.75,
                  height: Get.height - Get.statusBarHeight - Get.bottomBarHeight,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Hero(tag: "Wallet", child: Image.asset("assets/images/wallet.png", width: 60, height: 60)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("지갑을 만들었어요!",
                              style: Get.theme.textTheme.headline5
                                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("안전하게 보관하고,", style: Get.theme.textTheme.bodyText1),
                          Text("공인 인증 기관이 필요없는 인증.", style: Get.theme.textTheme.bodyText1),
                          Text("내가 정보의 주체가 되는", style: Get.theme.textTheme.bodyText1),
                          Text("새로운 경험이 시작됩니다.", style: Get.theme.textTheme.bodyText1),
                        ]),
                        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                          Text("이제 다양한 기능을 사용해 보세요!", style: Get.theme.textTheme.caption),
                          const SizedBox(
                            height: 20,
                          ),
                          GradientButton(
                              gradient: const LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                              onPressed: () async {
                                await c.registerDidDocument(snapshot.data!);
                                Get.offAll(Login());
                              },
                              child: Text('goToHome'.tr,
                                  style:
                                      const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)))
                        ]),
                      ]));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    ]);
  }
}
