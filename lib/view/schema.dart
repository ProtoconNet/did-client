import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/widget/background.dart';
import 'package:wallet/controller/schema_controller.dart';
import 'package:wallet/util/logger.dart';

class Schema extends StatelessWidget {
  Schema(
      {key,
      required this.did,
      required this.name,
      required this.urls,
      required this.schemaID,
      required this.credentialDefinitionID,
      required this.schema})
      : c = Get.put(SchemaController(
            did: did,
            name: name,
            urls: urls,
            schemaID: schemaID,
            credentialDefinitionID: credentialDefinitionID,
            schema: schema)),
        super(key: key);

  final String did;
  final String name;
  final String urls;
  final String schemaID;
  final String credentialDefinitionID;
  final String schema;

  final SchemaController c;

  final GlobalVariable g = Get.find();
  final log = Log();

  _builder(name) {
    log.i('Schema:builder');

    final schemaList = c.schemaList;
    var inputs = [];

    var datetimeIndex = 0;
    var imageIndex = 0;

    for (var item in schemaList) {
      switch (item['type']) {
        case 'string':
          final TextEditingController ctrl = TextEditingController();
          c.inputControllerList.add(ctrl);
          inputs.add(TextFormField(
            decoration: InputDecoration(hintText: item['name']),
            controller: ctrl,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
          ));
          break;
        case 'image':
          final idx = imageIndex;
          // log.i("imageList idx:${c.imageList.length.toString()}");
          // log.i("image idx:${idx.toString()}");
          var shortSide = Get.height < Get.width ? Get.height : Get.width;
          inputs.add(Column(children: [
            Obx(() => c.imageList.length > idx && c.imageList[idx] != ""
                ? Image.memory(base64Decode(c.imageList[idx]), height: shortSide / 2)
                : Image.asset('assets/images/visualAid.png')),
            const SizedBox(height: 30),
            SizedBox(
                width: Get.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Get.width * 0.39,
                        child: ElevatedButton(
                            onPressed: () async {
                              await c.takeImage(idx);
                            },
                            child: Text('takePicture'.tr, style: Get.textTheme.button!.copyWith(color: Colors.white)))),
                    const Text(' '),
                    SizedBox(
                        width: Get.width * 0.39,
                        child: ElevatedButton(
                            onPressed: () async {
                              await c.getImage(idx);
                            },
                            child: Text('pickGallery'.tr, style: Get.textTheme.button!.copyWith(color: Colors.white)))),
                  ],
                ))
          ]));
          c.imageList.add('');
          imageIndex++;
          break;
        case 'number':
          final TextEditingController ctrl = TextEditingController();
          c.inputControllerList.add(ctrl);
          inputs.add(TextFormField(
            decoration: InputDecoration(hintText: item['name']),
            controller: ctrl,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.number,
          ));
          break;
        case 'datetime':
          final idx = datetimeIndex;
          inputs.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(item['name'].toString().toUpperCase() + " : "),
            TextButton(onPressed: () {
              DatePicker.showDatePicker(Get.context!, showTitleActions: true, onConfirm: (date) {
                c.dateList[idx] = date;
              }, currentTime: c.date.value, locale: LocaleType.ko);
            }, child: Obx(() {
              var formatter = DateFormat('yyyy-MM-dd');
              String formattedDate = formatter.format(c.date.value);
              return Text(
                formattedDate,
                style: const TextStyle(color: Colors.blue),
              );
            })),
            TextButton(onPressed: () {
              DatePicker.showTimePicker(Get.context!, showTitleActions: true, onConfirm: (time) {
                c.timeList[idx] = time;
              }, currentTime: c.time.value, locale: LocaleType.ko);
            }, child: Obx(() {
              var formatter = DateFormat('HH:mm:ss');
              String formattedTime = formatter.format(c.time.value);
              return Text(
                formattedTime,
                style: const TextStyle(color: Colors.blue),
              );
            }))
          ]));
          c.addDateTimeField();
          datetimeIndex++;
          break;
      }
    }

    c.widgets.value = [
      // SizedBox(
      //     height: Get.height - Get.statusBarHeight - Get.bottomBarHeight - 82,
      //     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      //       ...inputs,
      //     ])),
      SizedBox(
          height: Get.height - Get.statusBarHeight - Get.bottomBarHeight - 50 - 32,
          child: ListView(children: [
            ...inputs,
          ])),

      SizedBox(
          width: Get.width * 0.8,
          height: 50,
          child: ElevatedButton(
              child: Text('Submit', style: Get.textTheme.button!.copyWith(color: Colors.white)),
              onPressed: () async {
                await c.submit(schema, name, schemaList);
                Get.back();
              }))
    ];
    //Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children:

    return true;
  }

  init(schema) {
    c.init(schema);
    return _builder(name);
  }

  @override
  Widget build(BuildContext context) {
    log.i('Schema:build');
    init(schema);
    return Background(
        appBar: AppBar(
            backgroundColor: const Color.fromARGB(0xff, 61, 61, 61),
            title: Text(name,
                style: GoogleFonts.roboto(textStyle: Get.theme.textTheme.headline6?.copyWith(color: Colors.white)))),
        children: [
          Container(
              margin: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              height: Get.height - Get.statusBarHeight - Get.bottomBarHeight - 16.0 * 2,
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: c.widgets))
        ]);
  }
}
