import 'package:flutter/material.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/widget/background.dart';
import 'package:get/get.dart';

import 'package:wallet/view/receive_password.dart';
import 'package:wallet/widget/gradient_button.dart';
import 'package:wallet/util/logger.dart';

class CreateWallet extends StatelessWidget {
  final GlobalVariable g = Get.find();
  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i('CreateWallet');
    return Background(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Container(
              width: Get.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/benefitAuthIcon.png", width: 45),
                          SizedBox(width: 20),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('모든 인증을 한번에', style: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
                            Container(
                                constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                                child: Text(
                                  '신분증과 티켓을 지갑없이 관리하고 사용할 수 있어요',
                                  style: Get.textTheme.bodyText2,
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                )),
                          ])
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/benefitChainIcon.png", width: 45),
                          SizedBox(width: 20),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('블록체인으로 안전하게', style: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
                            Container(
                                constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                                child: Text(
                                  '당신의 개인정보는 최고의 블록체인 MITUM에 안전하게 저장합니다',
                                  style: Get.textTheme.bodyText2,
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                )),
                          ])
                        ],
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/benefitFilletIcon.png", width: 45),
                          SizedBox(width: 20),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('필요할 때, 필요한 정보만',
                                style: Get.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
                            Container(
                                constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                                child: Text(
                                  'MITUM 블록체인 기술로 필요한 정보만 필요한 시점에 사용할 수 있어요',
                                  style: Get.textTheme.bodyText2,
                                  textAlign: TextAlign.start,
                                  maxLines: 3,
                                )),
                          ])
                        ],
                      ))
                ],
              )),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                width: Get.width * 0.75,
                alignment: Alignment.center,
                child: Column(children: [
                  Text('Mitum Wallet 서비스 이용약관에'),
                  Text(
                    '동의하시면 내 지갑 만들기를 눌러주세요.',
                  )
                ])),
            SizedBox(height: 20),
            GradientButton(
                width: Get.width * 0.75,
                child:
                    Text('내 지갑 만들기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWallet()));
                  Get.to(ReceivePassword());
                }),
          ]),
        ]);
  }
}
