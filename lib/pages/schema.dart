import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:wallet/providers/global_variable.dart';

import 'package:wallet/widgets/background.dart';
import 'package:wallet/controller/schema_controller.dart';
import 'package:wallet/utils/logger.dart';

class Schema extends StatelessWidget {
  Schema({key, required this.did, required this.name, required this.requestSchema}) : super(key: key);
  final g = Get.put(GlobalVariable());
  final log = Log();
  final String did;
  final String name;
  final String requestSchema;

  builder(context, name) {
    final SchemaController c = Get.put(SchemaController(did: did, name: name, requestSchema: requestSchema));

    log.i('Schema Builder');
    log.i(c.schema.value);
    if (c.schema.value != "") {
      final schemaList = json.decode(c.schema.value);
      var datetimeIndex = 0;
      var imageIndex = 0;

      for (var item in schemaList) {
        switch (item['type']) {
          case 'string':
            final TextEditingController ctrl = TextEditingController();
            c.inputControllerList.add(ctrl);
            c.inputs.add(TextFormField(
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
            c.inputs.add(Column(children: [
              Obx(() => c.imageList.length > idx && c.imageList[idx] != ""
                  ? Image.memory(base64Decode(c.imageList[idx]), height: shortSide / 2)
                  : Text('image')),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        // log.i('put image in ${idx.toString()}');
                        await c.takeImage(idx);
                      },
                      child: Text('takePicture'.tr)),
                  Text(' '),
                  ElevatedButton(
                      onPressed: () async {
                        // log.i('put image in ${idx.toString()}');
                        await c.getImage(idx);
                      },
                      child: Text('pickGallery'.tr)),
                ],
              )
            ]));
            c.addImageField();
            imageIndex++;
            break;
          case 'number':
            final TextEditingController ctrl = TextEditingController();
            c.inputControllerList.add(ctrl);
            c.inputs.add(TextFormField(
              decoration: InputDecoration(hintText: item['name']),
              controller: ctrl,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.number,
            ));
            break;
          case 'datetime':
            final idx = datetimeIndex;
            c.inputs.add(Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(item['name'].toString().toUpperCase() + " : "),
              TextButton(onPressed: () {
                DatePicker.showDatePicker(Get.context!, showTitleActions: true, onConfirm: (date) {
                  c.setDateAt(date, idx);
                }, currentTime: c.date.value, locale: LocaleType.ko);
              }, child: Obx(() {
                var formatter = DateFormat('yyyy-MM-dd');
                String formattedDate = formatter.format(c.date.value);
                return Text(
                  formattedDate,
                  style: TextStyle(color: Colors.blue),
                );
              })),
              TextButton(onPressed: () {
                DatePicker.showTimePicker(Get.context!, showTitleActions: true, onConfirm: (time) {
                  c.setTimeAt(time, idx);
                }, currentTime: c.time.value, locale: LocaleType.ko);
              }, child: Obx(() {
                var formatter = DateFormat('HH:mm:ss');
                String formattedTime = formatter.format(c.time.value);
                return Text(
                  formattedTime,
                  style: TextStyle(color: Colors.blue),
                );
              }))
            ]));
            c.addDateTimeField();
            datetimeIndex++;
            break;
        }
      }

      return ListView(shrinkWrap: true, children: [
        Column(children: [
          ...c.inputs,
          ElevatedButton(
              child: Text('Submit'),
              onPressed: () async {
                await c.submit(name, schemaList);
                Navigator.pop(context);
              })
        ])
      ]);
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final SchemaController c = Get.put(SchemaController(did: did, name: name, requestSchema: requestSchema));
    // log.i("Schema build");
    return Background(
        appBar: AppBar(
            title: Text(name,
                style: GoogleFonts.roboto(
                    textStyle: Get.theme.textTheme.headline5?.copyWith(fontWeight: FontWeight.bold)))),
        children: [
          // FutureBuilder(
          //     future: c.dynamicFields(name, requestSchema),
          //     builder: (context, snapshot) {
          // return builder(context, snapshot, name);
          Obx(() => builder(context, name))
          //     }),
        ]);
  }
}
