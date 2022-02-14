import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as a;
import 'package:wallet/util/flutter_secure_storage.dart' as b;

// import 'package:wallet/util/logger.dart';

class FlutterSecureStorage {
  FlutterSecureStorage();
  final A = const a.FlutterSecureStorage();
  final B = b.FlutterSecureStorage();

  Future<bool?> containsKey({required String key}) async {
    if (dotenv.env['env'] == "test") {
      return await A.containsKey(key: key);
    } else {
      return await B.containsKey(key: key);
    }
  }

  Future<String?> read({required String key}) async {
    if (dotenv.env['env'] == "test") {
      return await A.read(key: key);
    } else {
      return await B.read(key: key);
    }
  }

  Future<void> write({required String key, required String value}) async {
    if (dotenv.env['env'] == "test") {
      return await A.write(key: key, value: value);
    } else {
      return await B.write(key: key, value: value);
    }
  }

  Future<void> delete({required String key}) async {
    if (dotenv.env['env'] == "test") {
      return await A.delete(key: key);
    } else {
      return await B.delete(key: key);
    }
  }

  Future<void> deleteAll() async {
    if (dotenv.env['env'] == "test") {
      return await A.deleteAll();
    } else {
      return await B.deleteAll();
    }
  }

  Future<Map<String, String>?> readAll() async {
    if (dotenv.env['env'] == "test") {
      return await A.readAll();
    } else {
      return await B.readAll();
    }
  }
}
