import 'package:flutter/material.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/widgets/background.dart';
import 'package:get/get.dart';

import 'package:wallet/pages/receive_password.dart';
import 'package:wallet/widgets/gradient_button.dart';
import 'package:wallet/utils/logger.dart';

class CreateWallet extends StatelessWidget {
  final g = Get.put(GlobalVariable());
  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i('SelectCreateAccount');
    return Background(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      SizedBox(height: 30),
      Center(
          child: Container(
              width: Get.width * 0.2,
              height: 40.0,
              decoration:
                  BoxDecoration(gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]), boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.5),
                  blurRadius: 1.5,
                ),
              ]),
              child: Center(
                  child: Text('M I T U M', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))))),
      Center(
          child: Text('Wallet',
              style: Get.textTheme.headline2?.copyWith(color: Colors.black, fontWeight: FontWeight.w900))),
      SizedBox(height: 30),
      Column(
        children: [
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Row(
                children: [
                  Icon(Icons.vpn_key_sharp, color: Colors.deepPurple, size: 30),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                            padding: EdgeInsets.all(3),
                            child: Text('모든 인증을 한번에',
                                style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold))),
                        Container(
                            width: Get.width - 160,
                            child: Text(
                              '신분증과 티켓 디지털 키까지 지갑없이 관리하고 사용할 수 있어요',
                              style: Get.textTheme.subtitle1,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                            )),
                      ]))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Row(
                children: [
                  Icon(Icons.link_outlined, color: Colors.deepPurple, size: 30),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                            padding: EdgeInsets.all(3),
                            child: Text('블록체인으로 안전하게',
                                style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold))),
                        Container(
                            width: Get.width - 160,
                            child: Text(
                              '당신의 개인정보는 최고의 블록체인 MITUM에 안전하게 저장합니다',
                              style: Get.textTheme.subtitle1,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                            )),
                      ]))
                ],
              )),
          Padding(
              padding: EdgeInsets.only(left: 30, right: 30, top: 30),
              child: Row(
                children: [
                  Icon(Icons.filter_alt_sharp, color: Colors.deepPurple, size: 30),
                  Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Padding(
                            padding: EdgeInsets.all(3),
                            child: Text('필요할 때, 필요한 정보만',
                                style: Get.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold))),
                        Container(
                            width: Get.width - 160,
                            child: Text(
                              'MITUM 블록체인 기술로 필요한 정보만 필요한 시점에 사용할 수 있어요',
                              style: Get.textTheme.subtitle1,
                              textAlign: TextAlign.start,
                              maxLines: 3,
                            )),
                      ]))
                ],
              ))
        ],
      ),
      SizedBox(height: 30),
      Column(children: [
        Center(child: Text('소셜인프라테크는 사용자의 개인정보를 수집하지 않습니다.', style: Get.textTheme.caption)),
        SizedBox(height: 30),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          GestureDetector(
            onTap: () {},
            child: Text('Mitum Wallet 서비스 이용약관', style: TextStyle(color: Colors.blue)),
          ),
          Text(
            '에',
          ),
        ]),
        Center(
            child: Text(
          '동의하시면 내 지갑 만들기를 눌러주세요.',
          maxLines: 2,
        )),
        Center(
            child: GradientButton(
                width: Get.width * 0.7,
                child:
                    Text('내 지갑 만들기', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                gradient: LinearGradient(colors: [Colors.purple, Colors.deepPurple]),
                onPressed: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => CreateWallet()));
                  Get.to(ReceivePassword());
                })),
      ]),
      SizedBox(height: 30),
    ]);
  }
}
