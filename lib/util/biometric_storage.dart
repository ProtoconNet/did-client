import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'package:wallet/util/logger.dart';

class BiometricStorage {
  final log = Log();
  final storage = const FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> canCheckBiometric() async {
    log.i("BiometricStorage:canCheckBiometric");
    return await auth.canCheckBiometrics;
  }

  Future<bool> authenticate() async {
    log.i("BiometricStorage:authenticate");
    return await auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true);
  }

  Future<bool?> write(String key, String value) async {
    log.i("BiometricStorage:write");
    if (await canCheckBiometric() && await authenticate()) {
      await storage.write(key: key, value: value);

      var readValue = await storage.read(key: key);

      if (readValue.runtimeType == String && readValue == value) {
        return true;
      } else {
        return false;
      }
    }

    return null;
  }

  Future<String?> read(String key) async {
    log.i("BiometricStorage:read");
    if (await canCheckBiometric() && await authenticate()) {
      return await storage.read(key: key);
    }
    return null;
  }

  Future<bool?> delete(String key) async {
    log.i("BiometricStorage:delete");
    if (await canCheckBiometric() && await authenticate()) {
      await storage.delete(key: key);
      if (await storage.read(key: key) == null) {
        return true;
      } else {
        return false;
      }
    }

    return null;
  }

  Future<bool?> deleteAll() async {
    log.i("BiometricStorage:deleteAll");
    if (await canCheckBiometric() && await authenticate()) {
      await storage.deleteAll();
    }

    return null;
  }

  Future<Map<String, String>?> readAll() async {
    log.i("BiometricStorage:readAll");
    if (await canCheckBiometric() && await authenticate()) {
      Map<String, String> allValues = await storage.readAll();

      return allValues;
    }
    return null;
  }
}
