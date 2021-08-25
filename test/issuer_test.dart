// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:get/get.dart';
import 'package:test/test.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:fast_base58/fast_base58.dart';
// import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/provider/issuer.dart';
import 'package:wallet/util/crypto.dart';
import 'package:wallet/provider/platform.dart';

void main() async {
  // Get.put(GlobalVariable(), permanent: true);

  group('issuer test', () {
    test('Get Schema Location Test', () async {
      var issuer = Issuer('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense');
      var response = await issuer.getSchemaLocation();

      expect(response.containsKey('schema'), true);
      expect(response.containsKey('VCPost'), true);
      expect(response.containsKey('VCGet'), true);
    });

    test('Challenge Response Test', () async {
      var issuer = Issuer('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense');
      var crypto = Crypto();
      final platform = Platform();

      var key = await crypto.generateKeyPair();

      String did = "did:mtm:" + key[1];

      var response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response)['message'], isNot(equals("success")));

      response = await platform.setDIDDocument("http://49.50.164.195:8080/v1/DIDDocument", did);
      expect(response.statusCode, equals(200));

      response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response)['message'], equals("success"));

      var token = await issuer.postVC(
          json.encode({
            "did": did,
            "schema": "vc1",
            "credentialSubject": {
              "name": "asdf",
              "license number": "123",
              "license": "",
              "expire": "2021-08-17T10:47:38.000"
            }
          }),
          key[0]);
      expect(token, isNot(equals(false)));

      response = await issuer.getVC(token);

      expect(json.decode(response)['Response'], equals(true));
    });
  });
}
