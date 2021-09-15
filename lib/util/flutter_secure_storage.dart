import 'package:wallet/util/logger.dart';
import 'package:get_storage/get_storage.dart';

class FlutterSecureStorage {
  FlutterSecureStorage();

  final box = GetStorage();

  containsKey({required String key}) {
    var keys = box.getKeys();

    for (var k in keys) {
      if (key == k) {
        return true;
      }
    }
    return false;
  }

  read({required String key}) {
    return box.read(key);
  }

  write({required String key, required String value}) {
    box.write(key, value);
  }

  delete({required String key}) {
    box.remove(key);
  }

  readAll() {
    Map<String, String> ret = {};

    var keys = box.getKeys();

    for (var k in keys) {
      ret[k] = box.read(k);
    }

    return ret;
  }

  deleteAll() {
    var keys = box.getKeys();

    for (var k in keys) {
      box.remove(k);
    }
  }
}
