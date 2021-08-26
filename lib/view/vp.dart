import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/vp_controller.dart';

class VP extends StatelessWidget {
  VP({key, required this.did, required this.name, required this.vc}) : super(key: key);

  final VPController c = Get.put(VPController());

  final Map<String, dynamic> vc;
  final String did;
  final String name;
  final String thirdPartyName = "SK 렌터카";

  List<Widget> credentialSubjectList(Map<String, dynamic> credentialSubject) {
    List<Widget> ret = [];
    for (var key in credentialSubject.keys) {
      ret.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(key.toUpperCase(), style: Get.textTheme.subtitle2!.copyWith(color: Get.theme.accentColor)),
        Text("${credentialSubject[key]}",
            style: Get.textTheme.headline5!.copyWith(fontWeight: FontWeight.w600), maxLines: 3)
      ]));
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          title: Text(name),
        ),
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 20),
            width: Get.width * 0.75,
            child: Card(
              color: Get.theme.cardColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.grey,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...credentialSubjectList(vc['credentialSubject']),
                      // FutureBuilder(
                      //     future: c.getVP([vc]),
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      // return
                      SizedBox(height: 18),
                      Center(child: QrImage(data: did, version: QrVersions.auto, size: 160.0))
                      //   }
                      //   return CircularProgressIndicator();
                      // })
                    ],
                  )),
            ),
          ),
          name == "제주패스" || name == "jejupass"
              ? InkWell(
                  onTap: () {
                    Get.defaultDialog(
                      backgroundColor: Colors.grey.shade200,
                      title: "",
                      titleStyle: TextStyle(fontSize: 0),
                      // title: "인증 요청",
                      // titleStyle: Get.textTheme.subtitle2!.copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                      content: Column(children: [
                        Row(
                          children: [
                            Text('인증요청'),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {},
                            )
                          ],
                        ),
                        Text(thirdPartyName,
                            style: Get.textTheme.headline6!.copyWith(color: Colors.black, fontWeight: FontWeight.w700)),
                        SizedBox(height: 27),
                        Text('제주패스 회원 10% 할인', style: Get.textTheme.subtitle1!.copyWith(color: Get.theme.accentColor)),
                        SizedBox(height: 20),
                        Text('$thirdPartyName에서 아래 정보를 요청합니다.', style: Get.textTheme.subtitle1),
                        SizedBox(height: 12),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: Get.width * 0.90,
                          child: Card(
                            color: Get.theme.cardColor,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(10), child: Icon(FontAwesomeIcons.addressCard)),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text('  운전면허 정보', style: Get.textTheme.bodyText1),
                                          Text('  성명, 생년월일, 운전면허번호', style: Get.textTheme.bodyText2)
                                        ])
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          width: Get.width * 0.90,
                          child: Card(
                            color: Get.theme.cardColor,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(10), child: Icon(FontAwesomeIcons.ticketAlt)),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text('  제주패스 정보', style: Get.textTheme.bodyText1),
                                          Text('  성명, 예약번호, 유효기간', style: Get.textTheme.bodyText2)
                                        ])
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      ]),
                      confirm: ElevatedButton(
                        child: Text('인증하기'),
                        style: Get.theme.textButtonTheme.style,
                        onPressed: () async {
                          var vpResult = await c.testVP([vc]);
                          print("#######################$vpResult########################");
                          if ((vpResult / 100).floor() == 2) {
                            await Get.defaultDialog(
                                title: "인증 완료",
                                content: Text("인증이 성공적으로 완료 되었습니다."),
                                confirm: ElevatedButton(
                                  child: Text('ok'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ));
                          } else {
                            await Get.defaultDialog(
                                title: "VP 인증 실패",
                                content: Text("인증이 실패 하였습니다."),
                                confirm: ElevatedButton(
                                  child: Text('ok'),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ));
                          }
                          Get.back();
                        },
                      ),
                      cancel: ElevatedButton(
                        child: Text('취소'),
                        style: Get.theme.textButtonTheme.style,
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    );
                  },
                  child: Container(
                      margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 20),
                      width: Get.width * 0.75,
                      child: Stack(children: [
                        Image.asset('assets/images/car_box.png', width: 300),
                        Image.asset('assets/images/sk_rentacar_logo.png', width: 50)
                      ])),
                )
              : SizedBox(height: 0, width: 0)
        ]);
  }
}
