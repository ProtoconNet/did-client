import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wallet/widgets/background.dart';
import 'package:confetti/confetti.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:wallet/controller/config_controller.dart';

import 'package:wallet/providers/vp_test.dart';

class Config extends StatelessWidget {
  final ConfigController c = Get.put(ConfigController());

  @override
  Widget build(BuildContext context) {
    return Background(children: [
      Center(
          child: ConfettiWidget(
        confettiController: c.controllerCenter.value,
        blastDirection: -pi / 2,
        maxBlastForce: 10, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 0.1,
        numberOfParticles: 10, // a lot of particles at once
        gravity: 0.1,
      )),
      Center(
        child: Column(children: [
          //ElevatedButton(child: Text('json test'), onPressed: () => c.jsonldTest()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Theme '),
              Obx(() => DropdownButton(
                    value: c.theme.value,
                    onChanged: (newValue) {
                      c.setTheme(newValue);
                    },
                    items: <String>['system', 'light', 'dark'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Language '),
              Obx(() => DropdownButton(
                    value: c.language.value,
                    onChanged: (newValue) {
                      c.setLanguage(newValue);
                    },
                    items: <String>['system', 'korean', 'english'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ],
          ),
          ElevatedButton(child: Text('Erase All Data'), onPressed: () => c.eraseAll()),
          ElevatedButton(child: Text('VP Test'), onPressed: () => VPTest().testVP()),
          ElevatedButton(child: Text('confetti'), onPressed: () => c.controllerCenter.value.play()),
          ElevatedButton(
              child: Text('dialog'),
              onPressed: () {
                var test = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO_REVERSED,
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  width: 280,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'INFO',
                  desc: 'Dialog description here...',
                  showCloseIcon: true,
                  btnCancelOnPress: () {
                    return false;
                  },
                  btnOkOnPress: () {
                    return true;
                  },
                ).show();
                print(test);
              }),
          ElevatedButton(
              child: Text('Auth'),
              onPressed: () async {
                var localAuth = LocalAuthentication();
                bool didAuthenticate =
                    await localAuth.authenticate(localizedReason: 'Please authenticate to show account balance');
                print(didAuthenticate);
              }),
          Obx(() => Text(c.text.value)),
        ]),
      ),
    ]);
  }
}
