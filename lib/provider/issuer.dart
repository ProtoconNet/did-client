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

  responseCheck(Response<dynamic> response) {
    log.i("Issuer:responseCheck");
    switch ((response.statusCode! / 100).floor()) {
      case 2:
        log.i("response: ${response.data}");
        return response.data;
      default:
        log.lw("Response Error $response");
        return response.data;
      // throw Error();
    }
  }

  getVC(token) async {
    log.i("Issuer:getVC");
    final locations = await getSchemaLocation();
    final response = await Dio().get(
      locations['VCGet'],
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    );
    return responseCheck(response);
  }

  postVC(data, privateKey) async {
    log.i("Issuer:postVC");
    final locations = await getSchemaLocation();
    log.i('1:${locations['VCPost']}, $data');

    var response = await Dio()
        .post(
      locations['VCPost'],
      data: data,
      options: Options(headers: {
        "content-type": "application/json",
        "accept": "application/json"
      }), //contentType: Headers.jsonContentType),
    )
        .catchError((onError) {
      log.e("error:${onError.toString()}");
    });
    log.i('response.data: ${response.data}');

    final result = responseCheck(response);
    log.i('result: $result, ${result.runtimeType}');

    final challenge = jsonDecode(result);

    log.i('response.headers: ${response.headers}');
    log.i('headers authorization: ${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final challengeResult =
          await didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization']![0], privateKey);
      if (challengeResult) {
        return response.headers['authorization']![0];
      }
    }
    return false;
  }

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    log.i("Issuer:responseChallenge");
    final response = await Dio().get(
      challengeUri,
      queryParameters: {'signature': encodedSignatureBytes},
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    );

    return responseCheck(response);
  }

  getSchemaLocation() async {
    log.i("Issuer:getSchemaLocation");
    log.i(schemaLocation);

    final response = await Dio().get(schemaLocation);

    final vcLocation = responseCheck(response);
    return json.decode(vcLocation);
  }

  didAuth(payload, endPoint, token, privateKey) async {
    log.i("Issuer:didAuth");

    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(challengeBytes, privateKey);

    final response2 = await responseChallenge(endPoint, Base58Encode(signature), token);
    if (response2 == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }
}
