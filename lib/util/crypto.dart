import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';

class Crypto {
  final log = Log();
  final storage = FlutterSecureStorage();

  Future<List<String>> generateKeyPair() async {
    final seeds = encrypt.SecureRandom(32).bytes;

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(seeds);

    var encodedPriv = Base58Encode(await keyPair.extractPrivateKeyBytes());
    var encodedPub = Base58Encode((await keyPair.extractPublicKey()).bytes);

    return [encodedPriv, encodedPub];
  }

  Future<List<int>> sign(List<int> payload, String pk) async {
    final clearText = Base58Decode(pk);

    final algorithm = Ed25519();
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);

    final signature = await algorithm.sign(payload, keyPair: keyPair);

    return signature.bytes;
  }

  Future<bool> verify(List<int> payload, List<int> signature, List<int> pubKey) async {
    final algorithm = Ed25519();

    final result = await algorithm.verify(payload,
        signature: Signature(signature, publicKey: SimplePublicKey(pubKey, type: KeyPairType.ed25519)));

    return result;
  }

  Future<List<int>> encryptPK(String encodedPriv, String password) async {
    final passwordBytes = utf8.encode(password);

    final sink = Sha256().newHashSink();
    sink.add(passwordBytes);
    sink.close();
    final passwordHash = await sink.hash();

    final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final iv = encrypt.IV.fromLength(16);

    final encrypted = encrypter.encrypt("WIGGLER" + encodedPriv, iv: iv);

    return encrypted.bytes;
  }

  Future<String> decryptPK(String encryptedPk, String password) async {
    try {
      final passwordBytes = utf8.encode(password);
      // Generate a random secret key.
      final sink = Sha256().newHashSink();
      sink.add(passwordBytes);
      sink.close();
      final passwordHash = await sink.hash();

      final encrypted = encrypt.Encrypted.fromBase64(base64Encode(Base58Decode(encryptedPk)));

      final key = encrypt.Key.fromBase64(base64Encode(passwordHash.bytes));
      final encrypter = encrypt.Encrypter(encrypt.AES(key));

      final iv = encrypt.IV.fromLength(16);
      var decrypted = encrypter.decrypt(encrypted, iv: iv);

      if (decrypted.substring(0, 7) != "WIGGLER") {
        throw Error();
      }

      return decrypted.substring(7);
    } catch (e) {
      log.e(e);
      return "";
    }
  }
}
