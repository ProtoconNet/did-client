import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:blinking_text/blinking_text.dart';

import 'package:wallet/controller/step_controller.dart';
import 'package:wallet/widget/background.dart';
import 'package:wallet/util/logger.dart';

enum Step { ready, doing, done }

class OneStep extends StatelessWidget {
  OneStep({key, required this.comment, required this.enable}) : super(key: key);

  final Step enable;
  final String comment;

  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i("Step:build");
    if (enable == Step.ready) {
      return Row(children: [
        Checkbox(
            checkColor: Colors.white,
            activeColor: Get.theme.primaryColor,
            value: false,
            onChanged: (value) {},
            shape: const CircleBorder()),
        Text(comment, style: Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600, color: Colors.grey))
      ]);
    } else if (enable == Step.doing) {
      return Row(children: [
        Checkbox(
            checkColor: Colors.white,
            activeColor: Get.theme.primaryColor,
            value: false,
            onChanged: (value) {},
            shape: const CircleBorder()),
        BlinkText(comment,
            style: Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600),
            beginColor: Colors.black,
            endColor: Colors.orange,
            duration: const Duration(seconds: 1))
      ]);
    } else {
      return Row(children: [
        Checkbox(
            checkColor: Colors.white,
            activeColor: Get.theme.primaryColor,
            value: true,
            onChanged: (value) {},
            shape: const CircleBorder()),
        Text(comment, style: Get.textTheme.bodyText2!.copyWith(fontWeight: FontWeight.w600))
      ]);
    }
  }
}

class Steps extends StatelessWidget {
  const Steps({Key? key, required this.name, required this.step}) : super(key: key);

  final String name;
  final int step;

  @override
  Widget build(BuildContext context) {
    if (step == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneStep(comment: 'DID를 생성합니다.', enable: Step.doing),
          OneStep(comment: 'DID를 Protocon 블록체인에 등록합니다.', enable: Step.ready),
          OneStep(comment: 'DID와 $name을 확인합니다.', enable: Step.ready),
          OneStep(comment: 'DID 정보를 발급처에 전송합니다.', enable: Step.ready),
          Center(
              child: SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.grey, enableFeedback: false))))
        ],
      );
    } else if (step == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneStep(comment: 'DID를 생성합니다.', enable: Step.done),
          OneStep(comment: 'DID를 Protocon 블록체인에 등록합니다.', enable: Step.doing),
          OneStep(comment: 'DID와 $name을 확인합니다.', enable: Step.ready),
          OneStep(comment: 'DID 정보를 발급처에 전송합니다.', enable: Step.ready),
          Center(
              child: SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.grey, enableFeedback: false))))
        ],
      );
    } else if (step == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneStep(comment: 'DID를 생성합니다.', enable: Step.done),
          OneStep(comment: 'DID를 Protocon 블록체인에 등록합니다.', enable: Step.done),
          OneStep(comment: 'DID와 $name을 확인합니다.', enable: Step.doing),
          OneStep(comment: 'DID 정보를 발급처에 전송합니다.', enable: Step.ready),
          Center(
              child: SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.grey, enableFeedback: false))))
        ],
      );
    } else if (step == 3) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneStep(comment: 'DID를 생성합니다.', enable: Step.done),
          OneStep(comment: 'DID를 Protocon 블록체인에 등록합니다.', enable: Step.done),
          OneStep(comment: 'DID와 $name을 확인합니다.', enable: Step.done),
          OneStep(comment: 'DID 정보를 발급처에 전송합니다.', enable: Step.doing),
          Center(
              child: SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                      style: ElevatedButton.styleFrom(primary: Colors.grey, enableFeedback: false))))
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OneStep(comment: 'DID를 생성합니다.', enable: Step.done),
          OneStep(comment: 'DID를 Protocon 블록체인에 등록합니다.', enable: Step.done),
          OneStep(comment: 'DID와 $name을 확인합니다.', enable: Step.done),
          OneStep(comment: 'DID 정보를 발급처에 전송합니다.', enable: Step.done),
          Center(
              child: SizedBox(
                  width: Get.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('OK', style: Get.textTheme.button!.copyWith(color: Colors.white)),
                  )))
        ],
      );
    }
  }
}

class MyStep extends StatelessWidget {
  MyStep({key, required this.did, required this.name})
      : c = Get.put(MyStepController(did, name)),
        super(key: key);

  final String did;
  final String name;

  final MyStepController c;

  final log = Log();

  @override
  Widget build(BuildContext context) {
    log.i("VP:build");
    c.step.value = 0;

    c.count();
    return Background(
        appBar: AppBar(
          title: Text(name, style: Get.textTheme.headline5!.copyWith(fontWeight: FontWeight.w600, color: Colors.white)),
        ),
        children: [
          Container(
            margin: EdgeInsets.only(left: Get.width * 0.125, right: Get.width * 0.125, bottom: 20),
            width: Get.width * 0.75,
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
                  padding: const EdgeInsets.all(10),
                  child: Obx(() {
                    return Steps(name: name, step: c.step.value);
                  })),
            ),
          ),
        ]);
  }
}
