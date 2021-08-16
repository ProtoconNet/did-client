import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/vp_controller.dart';

class VP extends StatelessWidget {
  VP({key, required this.name, required this.vc}) : super(key: key);

  final VPController c = Get.put(VPController());

  final Map<String, dynamic> vc;
  final String name;
  final String thirdPartyName = "SK 렌터카";

  List<Widget> credentialSubjectList(Map<String, dynamic> credentialSubject) {
    List<Widget> ret = [];
    for (var key in credentialSubject.keys) {
      ret.add(Text("$key:${credentialSubject[key]}"));
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
                    children: [
                      ...credentialSubjectList(vc['credentialSubject']),
                      FutureBuilder(
                          future: c.getVP(vc),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return QrImage(data: snapshot.data.toString(), version: QrVersions.auto, size: 300.0);
                            }
                            return CircularProgressIndicator();
                          })
                    ],
                  )),
            ),
          ),
          name == "제주패스" || name == "jejupass"
              ? InkWell(
                  onTap: () {
                    Get.defaultDialog(
                      title: thirdPartyName,
                      content: Column(children: [
                        Text('제주패스 회원 10% 할인', style: Get.textTheme.subtitle1!.copyWith(color: Get.theme.accentColor)),
                        Text('$thirdPartyName에서 아래 정보를 요청합니다.', style: Get.textTheme.subtitle1),
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
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(5), child: Icon(Icons.ac_unit)),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text('운전면허 정보', style: Get.textTheme.subtitle2),
                                          Text('성명, 생년월일, 운전면허번호', style: Get.textTheme.caption)
                                        ])
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 5, top: 5),
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
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(padding: EdgeInsets.all(5), child: Icon(Icons.ac_unit)),
                                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                          Text('제주패스 정보', style: Get.textTheme.subtitle2),
                                          Text('성명, 예약번호, 유효기간', style: Get.textTheme.caption)
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
                          await c.testVP();
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
                            children: [Text('SK 렌터카')],
                          )),
                    ),
                  ))
              : SizedBox(height: 0, width: 0)
        ]);
  }
}
