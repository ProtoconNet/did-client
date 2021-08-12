import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/receive_password_controller.dart';
import 'package:wallet/view/create_did.dart';
import 'package:wallet/util/logger.dart';

class ReceivePassword extends StatelessWidget {
  final GlobalVariable g = Get.put(GlobalVariable());
  final ReceivePasswordController c = Get.put(ReceivePasswordController());
  final log = Log();

  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log.i('ReceivePasswordPage');
    final node = FocusScope.of(context);
    return Background(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon(Icons.account_balance_wallet_rounded, size: 40, color: Colors.deepPurple),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('비밀번호 설정', style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)))
            ],
          ),
          Column(children: [
            Icon(Icons.error_outline, size: 40, color: Get.theme.errorColor),
            SizedBox(height: 20),
            Center(child: Text('지금 설정한 PIN을 꼭 기억하세요!', style: Get.textTheme.headline5?.copyWith(color: Colors.red))),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  width: Get.width * 0.7,
                  child: Text('설정한 PIN은 어떤 서버에도 저장되지 않으며, 잊어버리면, 모든 DID를 재발급 해야합니다',
                      style: Get.textTheme.bodyText2?.copyWith(color: Colors.grey)))
            ]),
          ]),
          SizedBox(
            width: Get.width * 0.8,
            child: Form(
              key: c.formKey.value,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                        autofocus: true,
                        controller: pass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: '비밀번호 입력(영문, 숫자, 특수기호 조합 8자리 이상)'), //, labelText: 'Password'),
                        validator: (value) {
                          if (value != confirmPass.text) return ' ';
                          return null;
                        },
                        onChanged: (value) {
                          c.status.value = (value.isNotEmpty && pass.text == confirmPass.text);
                        },
                        onEditingComplete: () => node.nextFocus()),
                    TextFormField(
                        controller: confirmPass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: '비밀번호 확인'), //, labelText: 'Confirm'),
                        validator: (value) {
                          if (value != pass.text) return 'Error: Password and confirm password have to same';
                          return null;
                        },
                        onChanged: (value) {
                          c.formKey.value.currentState!.validate();
                          c.status.value = (value.isNotEmpty && pass.text == confirmPass.text);
                        },
                        onEditingComplete: () => node.nextFocus(),
                        onFieldSubmitted: (test) async {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
                        }),
                    Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: c.status.value
                                ? () async {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
                                  }
                                : null,
                            child: c.status.value ? Text('submit'.tr) : Text('check password'))))
                  ]),
            ),
          )
        ]);
  }
}
