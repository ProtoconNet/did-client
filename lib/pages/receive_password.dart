import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/widgets/background.dart';
import 'package:wallet/controller/receive_password_controller.dart';
import 'package:wallet/pages/create_did.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:wallet/utils/logger.dart';

class ReceivePassword extends StatelessWidget {
  final ReceivePasswordController c = Get.put(ReceivePasswordController());
  final GlobalVariable g = Get.put(GlobalVariable());
  final log = Log();
  final StreamController<ErrorAnimationType>? errorController = StreamController<ErrorAnimationType>();
  final TextEditingController textEditingController = TextEditingController();
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
                    // Center(
                    //     child: Obx(() => c.password.value == ""
                    //         ? Text('설정할 PIN을 입력하세요',
                    //             style: Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold))
                    //         : Text('한번 더 입력하세요.',
                    //             style: Get.textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold)))),
                    // Container(
                    //   width: Get.width * 0.7,
                    //   child: PinCodeTextField(
                    //     appContext: context,
                    //     // pastedTextStyle: TextStyle(
                    //     //   color: Colors.green.shade600,
                    //     //   fontWeight: FontWeight.bold,
                    //     // ),
                    //     length: 6,
                    //     obscureText: true,
                    //     // blinkWhenObscuring: true,
                    //     animationType: AnimationType.fade,
                    //     // validator: (v) {
                    //     //   if (v!.length < 3) {
                    //     //     return "I'm from validator";
                    //     //   } else {
                    //     //     return null;
                    //     //   }
                    //     // },
                    //     pinTheme: PinTheme(
                    //       shape: PinCodeFieldShape.box,
                    //       borderRadius: BorderRadius.circular(5),
                    //       fieldHeight: 40,
                    //       fieldWidth: 40,
                    //       activeFillColor: Colors.white,
                    //     ),
                    //     cursorColor: Colors.black,
                    //     animationDuration: Duration(milliseconds: 300),
                    //     enableActiveFill: false,
                    //     errorAnimationController: errorController,
                    //     controller: textEditingController,
                    //     keyboardType: TextInputType.number,
                    //     boxShadows: [
                    //       BoxShadow(
                    //         offset: Offset(0, 1),
                    //         color: Colors.black12,
                    //         blurRadius: 10,
                    //       )
                    //     ],
                    //     onCompleted: (v) {
                    //       print("Completed: $v");
                    //       if (c.password.value == "") {
                    //         c.setPassword(v);
                    //         textEditingController.text = '';
                    //       } else if (v == c.password.value) {
                    //         print(v);
                    //         Get.to(CreateDID(password: v));
                    //       } else {
                    //         Get.defaultDialog(
                    //             title: "incorrectPassword".tr,
                    //             content: Text('incorrectPassword'.tr),
                    //             confirm: ElevatedButton(
                    //               child: Text('ok'.tr),
                    //               style: Get.theme.textButtonTheme.style,
                    //               onPressed: () {
                    //                 Get.back();
                    //               },
                    //             ));
                    //         c.setPassword('');
                    //         textEditingController.text = '';
                    //       }
                    //     },
                    //     // onTap: () {
                    //     //   print("Pressed");
                    //     // },
                    //     onChanged: (value) {
                    //       print(value);
                    //       // setState(() {
                    //       //   currentText = value;
                    //       // });
                    //     },
                    //     beforeTextPaste: (text) {
                    //       print("Allowing to paste $text");
                    //       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //       //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    //       return true;
                    //     },
                    //   ),
                    // ),
                    // Text('createWallet'.tr, style: Get.theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
                    // Text('inputPasswordMsg'.tr),
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
                          c.setStatus(value.isNotEmpty && pass.text == confirmPass.text);
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
                          c.setStatus(value.isNotEmpty && pass.text == confirmPass.text);
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
