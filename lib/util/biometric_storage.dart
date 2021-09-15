import 'package:wallet/util/secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'package:wallet/util/logger.dart';

enum CanAuthenticateResponse { success, statusUnknown, failed }

class BiometricStorage {
  BiometricStorage(this.key);

  final log = Log();
  final storage = FlutterSecureStorage();
  final LocalAuthentication auth = LocalAuthentication();
  final String key;

  Future<CanAuthenticateResponse> canAuthenticate() async {
    log.i("BiometricStorage:canCheckBiometric");
    var canAuth = await auth.canCheckBiometrics;

    if (canAuth) {
      return CanAuthenticateResponse.success;
    } else {
      return CanAuthenticateResponse.failed;
    }
  }

  Future<bool> authenticate() async {
    log.i("BiometricStorage:authenticate");
    return await auth.authenticate(
        localizedReason: 'Scan your fingerprint (or face or whatever) to authenticate',
        useErrorDialogs: true,
        stickyAuth: true,
        biometricOnly: true);
  }

  Future<bool?> write(String value) async {
    log.i("BiometricStorage:write");
    if (await canAuthenticate() == CanAuthenticateResponse.success && await authenticate()) {
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

  Future<String?> read() async {
    log.i("BiometricStorage:read");
    if (await canAuthenticate() == CanAuthenticateResponse.success && await authenticate()) {
      return await storage.read(key: key);
    }
    return null;
  }

  Future<bool?> delete() async {
    log.i("BiometricStorage:delete");
    if (await canAuthenticate() == CanAuthenticateResponse.success && await authenticate()) {
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
    if (await canAuthenticate() == CanAuthenticateResponse.success && await authenticate()) {
      await storage.deleteAll();
    }

    return null;
  }

  Future<Map<String, String>?> readAll() async {
    log.i("BiometricStorage:readAll");
    if (await canAuthenticate() == CanAuthenticateResponse.success && await authenticate()) {
      Map<String, String> allValues = (await storage.readAll())!;

      return allValues;
    }
    return null;
  }
}
