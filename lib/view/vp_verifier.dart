import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:wallet/model/vp.dart';
import 'package:wallet/controller/vp_verifier_controller.dart';
import 'package:wallet/util/logger.dart';

class VPVerifier extends StatelessWidget {
  VPVerifier({key, required this.did, required this.vp, required this.enable})
      : c = Get.put(VPVerifierController(did, vp)),
        super(key: key);

  final log = Log();

  final String did;
  final VPModel vp;
  final bool enable;

  final VPVerifierController c;

  Widget _requiredVC(vcName, requestedSubject, iconData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      width: Get.width * 0.90,
      child: Card(
        color: Get.theme.cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.all(10), child: Icon(iconData)),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(vcName, style: Get.textTheme.bodyText1),
                          Text(requestedSubject, style: Get.textTheme.bodyText2)
                        ]))
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    log.i("VPVerifier:build");
    return InkWell(
      child: Container(
          margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 20),
          width: Get.width * 0.75,
          foregroundDecoration: enable
              ? const BoxDecoration()
              : BoxDecoration(
                  color: Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                  borderRadius: BorderRadius.circular(25),
                ),
          child: Stack(children: [
            Image.asset('assets/images/car_box.png', width: Get.width * 0.75),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(vp.name, style: Get.textTheme.headline5!.copyWith(fontWeight: FontWeight.w700))),
            Positioned(
                left: 10,
                top: 70,
                child: Row(children: [
                  Text('63,500원', style: Get.textTheme.headline5!.copyWith(fontWeight: FontWeight.w700)),
                  Text('24시간', style: Get.textTheme.caption)
                ]))
          ])),
      onTap: () {
        if (enable) {
          Get.dialog(
            Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                insetPadding: const EdgeInsets.all(30.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('인증요청', style: Get.textTheme.subtitle2),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Get.back();
                          },
                        )
                      ],
                    ),
                    Text(vp.name,
                        style: Get.textTheme.headline6!.copyWith(color: Colors.black, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 27),
                    Text('제주패스 회원 10% 할인', style: Get.textTheme.subtitle1!.copyWith(color: Get.theme.accentColor)),
                    const SizedBox(height: 20),
                    Text('${vp.name}에서 아래 정보를 요청합니다.', style: Get.textTheme.subtitle1),
                    const SizedBox(height: 12),
                    Column(
                        children: vp.vc
                            .map((vc) =>
                                _requiredVC(vc['name'], vc['required'].join(", "), FontAwesomeIcons.addressCard))
                            .toList()
                        // requiredVC('운전면허 정보', '성명, 생년월일, 운전면허번호', FontAwesomeIcons.addressCard),
                        // requiredVC('제주패스 정보', '성명, 예약번호, 유효기간', FontAwesomeIcons.ticketAlt),
                        ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: const Text('인증하기'),
                          style: Get.theme.textButtonTheme.style,
                          onPressed: () async {
                            try {
                              var vpResult = await c.postVP();
                              log.i("vpResult: $vpResult");
                              await Get.defaultDialog(
                                  title: "인증 완료",
                                  content: const Text("인증이 성공적으로 완료 되었습니다."),
                                  confirm: ElevatedButton(
                                    child: const Text('ok'),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ));
                            } catch (e) {
                              await Get.defaultDialog(
                                  title: "VP 인증 실패",
                                  content: const Text("인증이 실패 하였습니다."),
                                  confirm: ElevatedButton(
                                    child: const Text('ok'),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ));
                            } finally {
                              Get.back();
                            }
                          },
                        ),
                      ],
                    )
                  ]),
                )),
          );
        }
      },
    );
  }
}
