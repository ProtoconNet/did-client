import 'dart:io';
import 'dart:convert';
// import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:wallet/provider/issuer.dart';
import 'package:wallet/provider/platform.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';
import 'package:wallet/controller/vc_list_controller.dart';

class SchemaController extends GetxController {
  SchemaController(
      {required this.did,
      required this.name,
      required this.urls,
      required this.schemaID,
      required this.credentialDefinitionID,
      required this.schema});
//      : issuer = Issuer(requestSchema);

  final String did;
  final String name;
  final String urls;
  final String schemaID;
  final String credentialDefinitionID;
  final String schema;

  final GlobalVariable g = Get.find();
  final log = Log();
  // final Issuer issuer;
  final platform = Platform();

  var inputControllerList = [];

  var dateList = [].obs;
  var timeList = [].obs;
  var imageList = [].obs;
  var date = DateTime.now().obs;
  var time = DateTime.now().obs;
  var image = ''.obs;
  File? imageFile;

  RxList<dynamic> schemaList = [].obs;
  // var schema = ''.obs;

  RxList<Widget> widgets = <Widget>[].obs;

  @override
  onInit() {
    super.onInit();

    init(schema);
  }

  init(String schema) {
    log.i("SchemaController:init(schema:$schema)");
    inputControllerList = [];

    dateList.value = [];
    timeList.value = [];
    imageList.value = [];

    return schemaList.value = json.decode(schema);
  }

  _setImageFile(File _new) {
    log.i("SchemaController:setImageFile");
    imageFile = _new;
    update();
  }

  // _getDateTime() {
  //   return DateTime(
  //       date.value.year, date.value.month, date.value.day, time.value.hour, time.value.minute, time.value.second);
  // }

  _getDateTimeAt(int i) {
    return DateTime(
        dateList[i].year, dateList[i].month, dateList[i].day, timeList[i].hour, timeList[i].minute, timeList[i].second);
  }

  addDateTimeField() {
    log.i("SchemaController:addDateTimeField");
    dateList.add(DateTime.now());
    timeList.add(DateTime.now());
  }

  Future<String?> takeImage(int index) async {
    log.i("SchemaController:takeImage(index:$index)");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _setImageFile(File(pickedFile.path));

      var imageBytes = await File(pickedFile.path).readAsBytes();
      var imageBase64 = base64Encode(imageBytes);

      imageList[index] = imageBase64;

      return pickedFile.path;
    } else {
      log.i('No image selected.');
      return null;
    }
  }

  Future<String?> getImage(int index) async {
    log.i("SchemaController:getImage(index:$index)");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _setImageFile(File(pickedFile.path));

      var isHEIC = pickedFile.path.substring(pickedFile.path.length - 4, pickedFile.path.length);

      log.i("isHEIC: $isHEIC");

      var imageBytes = await pickedFile.readAsBytes();
      // var imageBase64 = base64Encode(imageBytes);

      // long 320
      var imageTemp = img.decodeImage(imageBytes) as img.Image;
      img.Image resizedImg;
      if (imageTemp.height > imageTemp.width) {
        resizedImg = img.copyResize(imageTemp, height: 320);
      } else {
        resizedImg = img.copyResize(imageTemp, width: 320);
      }

      var jpg = img.encodeJpg(resizedImg, quality: 95);
      var jpgBase64 = base64Encode(jpg);

      imageList[index] = jpgBase64;

      return pickedFile.path;
    } else {
      log.i('No image selected.');
    }
  }

  submit(String schema, String name, List<dynamic> data) async {
    log.i("SchemaController:submit(schema:$schema, name:$name, data:$data)");
    Map<String, dynamic> credentialSubject = {};

    int imageI = 0;
    int datetimeI = 0;
    int j = 0;

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      switch (item['type']) {
        case 'string':
          // log.i(inputControllerList[j].text.toString());
          credentialSubject[item['name']] = inputControllerList[j].text.toString();
          j++;
          break;
        case 'number':
          // log.i(inputControllerList[j].text.toString());
          credentialSubject[item['name']] = inputControllerList[j].text.toString();
          j++;
          break;
        case 'image':
          // log.i(imageList.value[imageI]);
          credentialSubject[item['name']] = imageList[imageI];
          imageI++;
          break;
        case 'datetime':
          final DateTime datetime = _getDateTimeAt(datetimeI);
          // log.i(datetime);
          credentialSubject[item['name']] = datetime.toIso8601String();
          datetimeI++;
          break;
      }
    }

    final pk = await g.didManager.value.getDIDPK(g.did.value, g.password.value);

    final issuer = Issuer(urls);

    final token = await issuer.didAuthentication(did, pk);

    VCListController c = Get.find();
    await c.vcManager.setByName(name, 'jwt', token);

    var response = await issuer.credentialProposal(did, schemaID, credentialDefinitionID, pk, token);

    // log.i("postVC Response: $response");

    if (response != null) {
      await c.vcManager.setByName(name, 'jwt', response);
      // await c.vcManager.setByName(name, 'VC', json.encode(response2));
      // await c.vcManager.value.setByName(name, 'jwt', response);
      // c.vcManager.update((t) {});
    } else {
      await Get.dialog(AlertDialog(
          content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text('VC Proposal Failed'),
          const SizedBox(
            width: 5,
          ),
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () => Get.back(),
          ),
        ],
      )));
    }
  }
}
