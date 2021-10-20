import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

class Issuer {
  Issuer(this.schemaLocation);
  final log = Log();
  final crypto = Crypto();

  final String schemaLocation;

  Future<Response<dynamic>> getVC(String token) async {
    log.i("Issuer:getVC(token:$token)");
    final locations = await getSchemaLocation();
    final response = await Dio()
        .get(
      locations['VCGet'],
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      log.e("VCGet error:${onError.toString()}");
    });
    return response;
  }

  Future<String?> postVC(Map<String, dynamic> data, String privateKey) async {
    log.i("Issuer:postVC(data:$data, privateKey:$privateKey)");
    final locations = await getSchemaLocation();
    log.i('1:${locations['VCPost']}, $data');

    var response = await Dio()
        .post(locations['VCPost'], data: data, options: Options(contentType: Headers.jsonContentType))
        .catchError((onError) {
      log.e("VCPost error:${onError.toString()}");
    });
    log.i('response.data: ${response.data}');

    final challenge = jsonDecode(response.data);

    log.i('response.headers: ${response.headers}');
    log.i('headers authorization: ${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final challengeResult =
          await didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization']![0], privateKey);
      if (challengeResult) {
        return response.headers['authorization']![0];
      }
    }
    return null;
  }

  Future<Response<dynamic>> responseChallenge(String challengeUri, String encodedSignatureBytes, String token) async {
    log.i("Issuer:responseChallenge()");
    final response = await Dio()
        .get(
      challengeUri,
      queryParameters: {'signature': encodedSignatureBytes},
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      log.e("responseChallenge error:${onError.toString()}");
    });

    return response;
  }

  Future<Map<String, dynamic>> getSchemaLocation() async {
    log.i("Issuer:getSchemaLocation");
    log.i(schemaLocation);

    final response = await Dio().get(schemaLocation).catchError((onError) {
      log.e("getSchemaLocation error:${onError.toString()}");
    });

    return json.decode(response.data);
  }

  Future<bool> didAuthentication(String did, String authEndPoint, String privateKey) async {
    log.i("Issuer:didAuthentication");

    var response = await Dio().get(authEndPoint, queryParameters: {'did': did}).catchError((onError) {
      log.e("Get error:${onError.toString()}");
    });
    log.i('response.data: ${response.data}');

    final challenge = jsonDecode(response.data);

    log.i('response.headers: ${response.headers}');
    log.i('headers authorization: ${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final payload = challenge['payload'];
      final token = response.headers['authorization']![0];
      final challengeEndpoint = challenge['endPoint'];

      final challengeBytes = utf8.encode(payload);

      final signature = await crypto.sign(Algorithm.ed25519, challengeBytes, privateKey);

      final response2 = await responseChallenge(challengeEndpoint, Base58Encode(signature), token);
      if (response2.data == "") {
        log.le("Challenge Failed");
        return false;
      }
    }
    return true;
  }

  Future<bool> didAuth(String payload, String endPoint, String token, String privateKey) async {
    log.i("Issuer:didAuth");

    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(Algorithm.ed25519, challengeBytes, privateKey);

    final response2 = await responseChallenge(endPoint, Base58Encode(signature), token);
    if (response2.data == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }
}
