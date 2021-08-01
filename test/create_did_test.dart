// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:test/test.dart';

import 'package:wallet/controller/create_did_controller.dart';
// import 'package:wallet/providers/issuer.dart';
// import 'package:wallet/providers/platform.dart';

void main() async {
  group('create did test', () {
    test('Create DID Test', () async {
      var createDID = CreateDIDController();

      var key1 = await createDID.createDID('test');
      var key2 = await createDID.createDID('test');

      print("key1:$key1");
      print("key2:$key2");

      expect(key1 == key2, false);
    });
    test('Generate Keypair Test', () async {
      var createDID = CreateDIDController();

      var key1 = await createDID.generateKeyPair();
      var key2 = await createDID.generateKeyPair();

      print("key1:$key1");
      print("key2:$key2");

      expect(key1[0] == key2[0], false);
      expect(key1[1] == key2[1], false);
    });
  });
}
