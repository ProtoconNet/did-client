// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:get/get.dart';
import 'package:test/test.dart';
// import 'package:flutter_test/flutter_test.dart';

// import 'package:wallet/controller/create_did_controller.dart';
// import 'package:wallet/view/create_did.dart';
// import 'package:wallet/provider/issuer.dart';
import 'package:wallet/util/crypto.dart';

void main() async {
  // group('create did test', () {
  // testWidgets('create did test', (WidgetTester tester) async {
  //   await tester.pumpWidget(GetMaterialApp(home: CreateDID(password: 'test')));
  // });
  // test('Create DID Test', () async {
  //   var createDID = CreateDIDController();

  //   var key1 = await createDID.createDID('test');
  //   var key2 = await createDID.createDID('test');

  //   print("key1:$key1");
  //   print("key2:$key2");

  //   expect(key1 == key2, false);
  // });

  test('asdf', () {
    var string = 'foo,bar,baz';
    expect(string.split(','), equals(['foo', 'bar', 'baz']));
  });

  test('Generate KeyPair Test', () async {
    var crypto = Crypto();

    var key1 = await crypto.generateKeyPair();
    var key2 = await crypto.generateKeyPair();

    print("key1:${key1[0]}");
    print("key2:${key2[0]}");
    // print("match:${key1[0] == key2[0]}");

    // expect(key1[0], notEquals(key2[0]));
    expect(key1[0], equals(key2[0]));
    // expect(key1[1] == key2[1], false);
  });
  // });
}
