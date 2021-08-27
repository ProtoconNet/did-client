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
import 'package:dio/dio.dart';
// import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
// import 'package:fast_base58/fast_base58.dart';
// import 'package:wallet/provider/global_variable.dart';

import 'package:wallet/provider/issuer.dart';
// import 'package:wallet/util/crypto.dart';
// import 'package:wallet/provider/platform.dart';

void main() async {
  test('Get Schema Location Test', () async {
    var issuer = Issuer('http://mtm.securekim.com:3333/VCSchema?schema=driverLicense');
    var response = await issuer.getSchemaLocation();
    print(response['VCPost']);

    var response2 = await Dio()
        .post(
      response['VCPost'],
      data: json.encode({
        "did": "did:mtm:BiR6eQyNQdRZm84GVstLPeRrcKzUoM6mcAHmUEbCxH2w",
        "schema": "vc2",
        "credentialSubject": {"buyID": "123"}
      }),
      options: Options(headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      }), //contentType: Headers.jsonContentType),
    )
        .catchError((e) {
      print(e);
    });

    print(response2);
  });
}
