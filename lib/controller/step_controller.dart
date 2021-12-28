import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

import 'package:qr_flutter/qr_flutter.dart';

Future delay(int milliseconds) {
  return Future.delayed(Duration(milliseconds: milliseconds));
}

class MyStepController extends GetxController {
  MyStepController(this.did, this.name);

  final String did;
  final String name;
  var step = 0.obs;
  var time = 0;
  var _timer;

  final GlobalVariable g = Get.find();
  final log = Log();

  void count() {
    log.i('StepController:onInit');

    step.value = 0;
    var hold = false;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        // log.i('test${step.value}');
        if (step.value > 4) {
          timer.cancel();
        } else if (hold == false) {
          step.value++;
        }

        if (hold == false && step.value == 2) {
          hold = true;
          await Get.dialog(AlertDialog(
            title: const Center(child: Text('QR코드를 담당자에게 보여주세요')),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  SizedBox(
                      width: 400,
                      height: 400,
                      child: Center(child: QrImage(data: did, version: QrVersions.auto, size: 200.0))),
                  Center(
                      child: SizedBox(
                          width: Get.width * 0.8,
                          child: ElevatedButton(
                            child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                            onPressed: () {
                              Get.back();
                            },
                          ))),
                ],
              ),
            ),
          ));
          hold = false;
        }
      },
    );
  }
}
