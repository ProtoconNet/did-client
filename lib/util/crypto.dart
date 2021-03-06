import 'dart:convert';
import 'package:wallet/util/secure_storage.dart';
import 'package:cryptography/cryptography.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';

enum Algorithm {
  ed25519,
  rsaSsaPkcs1v15Sha256,
  ecdsaSecp256k1,
}

getAlgorithm(Algorithm algorithm) {
  switch (algorithm) {
    // Ed25519VerificationKey2018
    case Algorithm.ed25519:
      return Ed25519();
    // RsaVerificationKey2018
    case Algorithm.rsaSsaPkcs1v15Sha256:
      return RsaSsaPkcs1v15(Sha256());
    // EcdsaSecp256k1VerificationKey2019
    case Algorithm.ecdsaSecp256k1:
      return Ecdsa.p256(Sha256());
    // EcdsaSecp256k1RecoveryMethod2020
    // JsonWebKey2020
    // Bls12381G1Key2020
    // Bls12381G2Key2020
    // PgpVerificationKey2021
    // X25519KeyAgreementKey2019
    // SchnorrSecp256k1VerificationKey2019
    // VerifiableCondition2021
    default:
      return null;
  }
}

getKeyPairType(Algorithm algorithm) {
  switch (algorithm) {
    // Ed25519VerificationKey2018
    case Algorithm.ed25519:
      return KeyPairType.ed25519;
    // RsaVerificationKey2018
    case Algorithm.rsaSsaPkcs1v15Sha256:
      return KeyPairType.rsa;
    // EcdsaSecp256k1VerificationKey2019
    case Algorithm.ecdsaSecp256k1:
      return KeyPairType.p256;
    // JsonWebKey2020
    // Bls12381G1Key2020
    // Bls12381G2Key2020
    // PgpVerificationKey2021
    // X25519KeyAgreementKey2019
    // SchnorrSecp256k1VerificationKey2019
    // EcdsaSecp256k1RecoveryMethod2020
    // VerifiableCondition2021
    default:
      return null;
  }
}

class Crypto {
  final log = Log();
  final storage = FlutterSecureStorage();

  Future<List<String>> generateKeyPair(Algorithm signAlgorithm) async {
    log.i("Crypto:generateKeyPair");
    final seeds = encrypt.SecureRandom(32).bytes;

    final algorithm = getAlgorithm(signAlgorithm);
    final keyPair = await algorithm!.newKeyPairFromSeed(seeds);

    var encodedPriv = Base58Encode(await keyPair.extractPrivateKeyBytes());
    var encodedPub = Base58Encode((await keyPair.extractPublicKey()).bytes);

    return [encodedPriv, encodedPub];
  }

  Future<List<int>> sign(Algorithm signAlgorithm, List<int> payload, String pk) async {
    log.i("Crypto:sign");
    final clearText = Base58Decode(pk);

    final algorithm = getAlgorithm(signAlgorithm);
    final keyPair = await algorithm.newKeyPairFromSeed(clearText);

    final signature = await algorithm.sign(payload, keyPair: keyPair);

    return signature.bytes;
  }

  Future<bool> verify(Algorithm signAlgorithm, List<int> payload, List<int> signature, List<int> pubKey) async {
    log.i("Crypto:verify");
    final algorithm = getAlgorithm(signAlgorithm);
    final keyPairType = getKeyPairType(signAlgorithm);

    final result = await algorithm.verify(payload,
        signature: Signature(signature, publicKey: SimplePublicKey(pubKey, type: keyPairType)));

    return result;
  }

  Future<List<int>> encryptPK(String encodedPriv, String password) async {
    log.i("Crypto:encryptPK");
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
    log.i("Crypto:decryptPK");
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
