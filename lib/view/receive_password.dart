import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/receive_password_controller.dart';
import 'package:wallet/view/create_did.dart';
import 'package:wallet/util/logger.dart';

class ReceivePassword extends StatelessWidget {
  ReceivePassword({Key? key}) : super(key: key);
  final ReceivePasswordController c = Get.put(ReceivePasswordController());

  final GlobalVariable g = Get.find();
  final log = Log();

  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  String _passwordValidate(String value) {
    RegExp regExp = RegExp(r"[a-zA-Z]");
    if (!regExp.hasMatch(value)) return '알파벳 소문자가 포함되어 있어야 합니다.';
    regExp = RegExp(r"[0-9]");
    if (!regExp.hasMatch(value)) return '숫자가 포함되어 있어야 합니다.';
    regExp = RegExp(r"\W");
    if (!regExp.hasMatch(value)) return '특수 문자가 포함되어 있어야 합니다.';
    if (value.length < 8) return '8자리 이상이어야 합니다.';

    return '';
  }

  @override
  Widget build(BuildContext context) {
    log.i('ReceivePassword:build');
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
                  padding: const EdgeInsets.all(10),
                  child: Text('비밀번호 설정', style: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.w700)))
            ],
          ),
          Column(children: [
            Icon(Icons.error_outline, size: 35, color: Get.theme.colorScheme.secondary),
            const SizedBox(height: 3),
            Center(
                child: Text('지금 설정한 PIN을 꼭 기억하세요!',
                    style: Get.textTheme.subtitle1?.copyWith(color: Get.theme.colorScheme.secondary))),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  width: Get.width * 0.8,
                  child: Column(children: [
                    Text('설정한 PIN은 어떤 서버에도 저장되지 않으며,', style: Get.textTheme.bodyText2),
                    Text('잊어버리면, 모든 DID를 재발급 해야합니다', style: Get.textTheme.bodyText2)
                  ]))
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
                          border: const OutlineInputBorder(),
                          hintText: '비밀번호 입력(영문, 숫자, 특수기호 조합 8자리 이상)',
                          suffixIcon: IconButton(
                            onPressed: () {
                              pass.clear();
                              confirmPass.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ), //, labelText: 'Password'),
                        validator: (value) {
                          final validateError = _passwordValidate(value!);
                          if (validateError == '') {
                            return null;
                          }
                          return validateError;
                        },
                        onChanged: (value) {
                          final isValid = c.formKey.value.currentState!.validate();
                          c.status.value = (value.isNotEmpty && pass.text == confirmPass.text && isValid);
                        },
                        onEditingComplete: () => node.nextFocus()),
                    TextFormField(
                        controller: confirmPass,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: '비밀번호 확인',
                          suffixIcon: IconButton(
                            onPressed: () {
                              pass.clear();
                              confirmPass.clear();
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ), //, labelText: 'Confirm'),
                        validator: (value) {
                          if (value != pass.text) return '비밀번호가 일치하지 않습니다.';
                          return null;
                        },
                        onChanged: (value) {
                          final isValid = c.formKey.value.currentState!.validate();
                          c.status.value = (value.isNotEmpty && pass.text == confirmPass.text && isValid);
                        },
                        onEditingComplete: () => node.nextFocus(),
                        onFieldSubmitted: (test) async {
                          Get.to(CreateDID(password: confirmPass.text));
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
                        }),
                    const SizedBox(height: 10),
                    Obx(() => SizedBox(
                          height: 48,
                          width: double.maxFinite,
                          child: ElevatedButton(
                            child: c.status.value
                                ? Text('submit'.tr, style: Get.textTheme.button!.copyWith(color: Colors.white))
                                : Text('submit'.tr),
                            onPressed: c.status.value
                                ? () async {
                                    Get.to(CreateDID(password: confirmPass.text));
                                    // Navigator.push(context,
                                    //     MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
                                  }
                                : null,
                          ),
                        )),
                  ]),
            ),
          )
        ]);
  }
}
