import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class VCCard extends StatelessWidget {
  VCCard(
      {key,
      required this.name,
      required this.description,
      required this.type,
      required this.icon,
      required this.status})
      : super(key: key);
  final GlobalVariable g = Get.find();
  final log = Log();

  final String name;
  final String description;
  final String type;
  final IconData icon;
  final String status;

  Widget getLogoByName(String name) {
    const double height = 20;
    if (name == "drivers license" || name == "운전면허증") {
      return Image.asset('assets/images/drivers_license_logo.png', height: height);
    } else if (name == "jejupass" || name == "제주패스") {
      return Image.asset('assets/images/jejupass_logo.png', height: height);
    } else {
      return Image.asset('assets/icons/flutter.png', height: height);
    }
  }

  Widget getCardByName(String name) {
    const double height = 200;

    if (name == "drivers license" || name == "운전면허증") {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset('assets/images/drivers_license.png', height: height));
    } else if (name == "jejupass" || name == "제주패스") {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15), child: Image.asset('assets/images/jejupass.png', height: height));
    } else {
      return ClipRRect(
          borderRadius: BorderRadius.circular(15), child: Image.asset('assets/icons/flutter.png', height: height));
    }
  }

  Widget getWaitImageByName(String name) {
    const double height = 50;
    if (name == "drivers license" || name == "운전면허증") {
      return Image.asset('assets/images/drivers_license_template.png', height: height);
    } else if (name == "jejupass" || name == "제주패스") {
      return Image.asset('assets/images/drivers_license_template.png', height: height);
    } else {
      return Image.asset('assets/icons/flutter.png', height: height);
    }
  }

  Widget contentByStatus(String name, String status) {
    if (status == "noVC") {
      return Padding(
          padding: EdgeInsets.all(20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [getLogoByName(name)]),
            Text(description, style: Get.textTheme.bodyText1),
            Text(name + ' 추가하기', style: Get.textTheme.button!.copyWith(color: Get.theme.primaryColor)),
          ]));
    } else if (status == "VC") {
      return getCardByName(name);
    } else {
      // wait
      return Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [getLogoByName(name)]),
        getWaitImageByName(name),
        Text('담당자 확인 후 $name 이(가) 발급됩니다.')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    log.i("VCCard build");

    return Container(
        margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, top: 18, bottom: 18),
        height: 200,
        width: Get.width * 0.75,
        child: Stack(children: [
          Card(
            color: Colors.red, //Get.theme.cardColor,
            elevation: 1,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.grey,
                width: 0.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.grey.shade200])),
                child: contentByStatus(name, status)),
          ),
          Opacity(
              opacity: 0.3,
              child: Image.asset(
                'assets/images/cardGlow.png',
                height: 200,
                width: Get.width * 0.75,
              )),
        ]));
  }
}
