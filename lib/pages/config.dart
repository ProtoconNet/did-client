import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallet/widgets/background.dart';

import 'package:wallet/controller/config_controller.dart';

import 'package:wallet/providers/vp_test.dart';

class Config extends StatelessWidget {
  final ConfigController c = Get.put(ConfigController());

  @override
  Widget build(BuildContext context) {
    return Background(children: [
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
          Obx(() => Text(c.text.value)),
        ]),
      ),
    ]);
  }
}
