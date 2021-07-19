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
// import 'package:wallet/providers/platform.dart';

void main() async {
  group('issuer test', () {
    test('Get Schema Location Test', () async {
      var issuer = Issuer();
      var response =
          await issuer.getSchemaLocation(Uri.parse('http://mtm.securekim.com:3333/VCScheme?scheme=driverLicense'));

      expect((response.statusCode / 100).floor(), 2);

      final Map<String, dynamic> result = json.decode(response.body);

      expect(result.containsKey('scheme'), true);
      expect(result.containsKey('VCPost'), true);
      expect(result.containsKey('VCGet'), true);
    });

    // test('Challenge Response Test', () async {
    //   var issuer = Issuer();
    //   var response = await issuer.responseChallenge(challengeUri, signature, token);

    //   expect((response.statusCode / 100).floor(), 2);

    //   final Map<String, dynamic> result = json.decode(response.body);

    //   // expect(result.containsKey('scheme'), true);
    // });
  });
}
