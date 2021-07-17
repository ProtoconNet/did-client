// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:test/test.dart';

import 'package:wallet/providers/issuer.dart';
import 'package:wallet/providers/platform.dart';

void main() {
  test('Counter increments smoke test', () async {
    var issuer = Issuer();
    var response =
        await issuer.getSchemaLocation(Uri.parse('http://mtm.securekim.com:3333/VCScheme?scheme=driverLicense'));

    print("*" * 150);
    print(response.body);
    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
  });
}
