// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:test/test.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/platform.dart';

void main() async {
  group('platform test', () {
    final did = "did:mtm:A5KirmUHQPbm1m7nPob35k3p6gxPxFE64cogoq1Tv5c8";

    test('Create DID Document Test', () async {
      final platform = Platform();

      final didDocument = platform.createDIDDocument(did);

      print(didDocument);

      // expect((response.statusCode / 100).floor(), 2);

      // final Map<String, dynamic> result = json.decode(response.body);

      // expect(result.containsKey('schema'), true);
    });

    test('Set DID Document Test', () async {
      final platform = Platform();

      // expect((response.statusCode / 100).floor(), 2);

      // final Map<String, dynamic> result = json.decode(response.body);

      // expect(result.containsKey('schema'), true);
    });

    test('Get DID Document Test', () async {
      final platform = Platform();

      // expect((response.statusCode / 100).floor(), 2);

      // final Map<String, dynamic> result = json.decode(response.body);

      // expect(result.containsKey('schema'), true);
    });

    test('Get Schema Test', () async {
      final issuer = Issuer();
      final platform = Platform();
      var response =
          await issuer.getSchemaLocation(Uri.parse('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense'));

      expect((response.statusCode / 100).floor(), 2);

      Map<String, dynamic> result = json.decode(response.body);

      expect(result.containsKey('schema'), true);
      response = await platform.getSchema(Uri.parse(result['schema']));

      expect((response.statusCode / 100).floor(), 2);

      result = json.decode(response.body);

      expect(result['message'], 'success');
    });
  });
}
