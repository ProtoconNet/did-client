// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:test/test.dart';
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/crypto.dart';

void main() async {
  test('Generate KeyPair Test', () async {
    var crypto = Crypto();

    var key1 = await crypto.generateKeyPair();
    var key2 = await crypto.generateKeyPair();

    expect(key1[0], isNot(equals(key2[0])));
    expect(key1[1], isNot(equals(key2[1])));
  });

  test('decrypt encrypted text', () async {
    var crypto = Crypto();

    // var key = crypto.generateKeyPair();

    var plainText = "raynear_Work-In.Wiggler?";

    var encrypted = await crypto.encryptPK(plainText, 'password');
    var decrypted = await crypto.decryptPK(Base58Encode(encrypted), 'password');

    expect(plainText, equals(decrypted));
  });
}
