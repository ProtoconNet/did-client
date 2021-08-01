import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as Img;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/platform.dart';
import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/providers/secure_storage.dart';
import 'package:wallet/utils/logger.dart';

class SchemaController extends GetxController {
  SchemaController({required this.did, required this.name, required this.requestSchema});

  final String did;
  final String name;
  final String requestSchema;

  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());
  final log = Log();
  final issuer = Issuer();
  final platform = Platform();

  var inputControllerList = <TextEditingController>[];
  var inputs = <Widget>[];

  var dateList = [].obs;
  var timeList = [].obs;
  var imageList = [].obs;
  var date = DateTime.now().obs;
  var time = DateTime.now().obs;
  var image = ''.obs;
  File? imageFile;

  var schema = ''.obs;

  onInit() async {
    inputControllerList = <TextEditingController>[];
    inputs = <Widget>[];

    dateList.value = [];
    timeList.value = [];
    imageList.value = [];

    await dynamicFields(name, requestSchema);
  }

  setImageFile(File _new) {
    imageFile = _new;
    update();
  }

  setDate(val) {
    date.value = val;
  }

  setTime(val) {
    time.value = val;
  }

  setImage(val) {
    image.value = val;
  }

  getDateTime() {
    return DateTime(
        date.value.year, date.value.month, date.value.day, time.value.hour, time.value.minute, time.value.second);
  }

  addDateTimeField() {
    dateList.add(DateTime.now());
    timeList.add(DateTime.now());
  }

  addImageField() {
    imageList.add('');
  }

  setDateAt(val, index) {
    dateList.add(val);
  }

  setTimeAt(val, index) {
    timeList[index] = val;
  }

  setImageAt(val, index) {
    imageList[index] = val;
  }

  getDateTimeAt(i) {
    return DateTime(
        dateList[i].year, dateList[i].month, dateList[i].day, timeList[i].hour, timeList[i].minute, timeList[i].second);
  }

  dynamicFields(String name, String requestSchema) async {
    log.i('dynamicFields: $name : $requestSchema');
    log.i('*' * 200);
    var response = await issuer.getSchemaLocation(Uri.parse(requestSchema));

    log.i("response.body:${response.body}");

    var endpoints = json.decode(response.body);

    await DIDManager(did: did).setVCFieldByName(name, 'requestVC', endpoints['VCPost']);
    await DIDManager(did: did).setVCFieldByName(name, 'getVC', endpoints['VCGet']);

    response = await platform.getSchema(Uri.parse(endpoints['schema']));
    if (json.decode(response.body).containsKey('error')) {
      return;
    }

    schema.value = json.decode(response.body)['data'];
    // final schemaList = json.decode(json.decode(response.body)['data']);

    // return schemaList;
    // } else {
    //   final schemaList = json.decode(schema.value);

    //   return schemaList;
    // }
  }

  Future takeImage(index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setImageFile(File(pickedFile.path));

      var imageBytes = await File(pickedFile.path).readAsBytes();
      var imageBase64 = base64Encode(imageBytes);
      setImageAt(imageBase64, index);
      return pickedFile.path;
    } else {
      log.i('No image selected.');
    }
  }

  Future getImage(index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setImageFile(File(pickedFile.path));

      var isHEIC = '${pickedFile.path.substring(pickedFile.path.length - 4, pickedFile.path.length)}';

      log.i(isHEIC);

      var imageBytes = await pickedFile.readAsBytes();
      var imageBase64 = base64Encode(imageBytes);

      // long 320
      var imageTemp = Img.decodeImage(imageBytes) as Img.Image;
      var resizedImg;
      if (imageTemp.height > imageTemp.width) {
        resizedImg = Img.copyResize(imageTemp, height: 320);
      } else {
        resizedImg = Img.copyResize(imageTemp, width: 320);
      }

      log.i("Org : height:${imageTemp.height}, width:${imageTemp.width}");
      log.i("reSized : height:${resizedImg.height}, width:${resizedImg.width}");

      var jpg = Img.encodeJpg(resizedImg, quality: 95);
      var jpgBase64 = base64Encode(jpg);
      log.i("jpgBase64:${jpgBase64.length}, $jpgBase64");

      log.i("org Size: ${imageBase64.length}");
      log.i("resized : ${jpgBase64.length}");

      setImageAt(jpgBase64, index);
      return pickedFile.path;
    } else {
      log.i('No image selected.');
    }
  }

  didAuth(payload, endPoint, token) async {
    log.i('did Auth');
    final passwordBytes = utf8.encode(g.password.value);
    // Generate a random secret key.
    final sink = Sha256().newHashSink();
    sink.add(passwordBytes);
    sink.close();
    final passwordHash = await sink.hash();

    final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final privateKey = await storage.read(key: 'privateKey') as String;
    final encrypted = encrypt.Encrypted.fromBase64(base64Encode(Base58Decode(privateKey)));

    final iv = encrypt.IV.fromLength(16);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);

    final clearText = Base58Decode(decrypted);

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);
    // final pubKey = await keyPair.extractPublicKey();
    // final did = 'did:mtm:' + Base58Encode(pubKey.bytes);

    final challengeBytes = utf8.encode(payload);

    final signature = await algorithm.sign(challengeBytes, keyPair: keyPair);

    final response2 = await issuer.responseChallenge(Uri.parse(endPoint), Base58Encode(signature.bytes), token);
    if (response2 == "") {
      log.le("Challenge Failed");
    }
  }

  submit(name, data) async {
    log.i("submit");
    var credentialSubject = {};

    var imageI = 0;
    var datetimeI = 0;
    var j = 0;

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
          final DateTime datetime = getDateTimeAt(datetimeI);
          // log.i(datetime);
          credentialSubject[item['name']] = datetime.toIso8601String();
          datetimeI++;
          break;
      }
    }

    // log.i(credentialSubject);
    var body = {"did": g.did.value, "schema": "vc1", "credentialSubject": credentialSubject};

    log.i("body:${json.encode(body)}");

    log.i("uri:${await DIDManager(did: did).getVCFieldByName(name, "requestVC")}");

    var response = await issuer.requestVC(
        Uri.parse(await DIDManager(did: did).getVCFieldByName(name, "requestVC")), json.encode(body));
    log.i("result of request VC: ${response.body}");

    if (response.body == 'Error' || json.decode(response.body).containsKey('error')) {
      await Get.dialog(AlertDialog(
          content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('VC Proposal Failed'),
          SizedBox(
            width: 5,
          ),
          ElevatedButton(
            child: Text('OK'),
            onPressed: () => Get.back(),
          ),
        ],
      )));
      return;
    }

    await DIDManager(did: did).setVCFieldByName(name, 'JWT', response.headers['authorization']);

    final challenge = jsonDecode(response.body);

    if (challenge.containsKey('payload')) {
      didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization']);
    }
  }
}
