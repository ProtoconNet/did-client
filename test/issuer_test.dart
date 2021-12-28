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
import 'package:wallet/util/logger.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:fast_base58/fast_base58.dart';
// import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/provider/issuer.dart';
import 'package:wallet/util/crypto.dart';
import 'package:wallet/provider/platform.dart';

void main() async {
  // Get.put(GlobalVariable(), permanent: true);
  final log = Log();

  group('issuer test', () {
    test('Get Schema Location Test', () async {
      var issuer = Issuer('http://mtm.securekim.com:3333');
      log.i('test');
      var response = await issuer.getUrls();
      log.i('test');

      log.i(response);

      expect(response.containsKey('schema'), true);
      expect(response.containsKey('VCPost'), true);
      expect(response.containsKey('VCGet'), true);
    });
/*
    test('VC1 Response Test', () async {
      var issuer = Issuer('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense');
      var crypto = Crypto();
      final platform = Platform();

      var key = await crypto.generateKeyPair(Algorithm.ed25519);

      String did = "did:mtm:" + key[1];

      var response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response.data)['message'], isNot(equals("success")));

      response = await platform.setDIDDocument("http://49.50.164.195:8080/v1/DIDDocument", did);
      expect(response.statusCode, equals(200));

      response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response.data)['message'], equals("success"));

      var token = await issuer.didAuthentication(did, key[0]);
      expect(token, isNotNull);

      var result = await issuer.credentialProposal(did, "schemaID1", "credentialDefinitionID1", key[0], token);
      expect(result, isNotNull);

      var response2 = await issuer.credentialRequest(did, "schemaID1", "credentialDefinitionID1", token);

      expect(json.decode(response2.data).containsKey('error'), equals(false));
    });

    test('VC2 Response Test', () async {
      var issuer = Issuer('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense');
      var crypto = Crypto();
      final platform = Platform();

      var key = await crypto.generateKeyPair(Algorithm.ed25519);

      String did = "did:mtm:" + key[1];

      var response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response.data)['message'], isNot(equals("success")));

      response = await platform.setDIDDocument("http://49.50.164.195:8080/v1/DIDDocument", did);
      expect(response.statusCode, equals(200));

      response = await platform.getDIDDocument("http://49.50.164.195:8080/v1/DIDDocument?did=" + did);
      expect(json.decode(response.data)['message'], equals("success"));

      var token = await issuer.didAuthentication(did, key[0]);
      expect(token, isNotNull);

      var result = await issuer.credentialProposal(did, "schemaID2", "credentialDefinitionID2", key[0], token);
      expect(result, isNotNull);

      var response2 = await issuer.credentialRequest(did, "schemaID2", "credentialDefinitionID2", token);

      expect(json.decode(response2.data).containsKey('error'), equals(false));
    });
  */
  });
}
