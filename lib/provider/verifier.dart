import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

class Verifier {
  Verifier(this.schemaLocation);
  final log = Log();
  final crypto = Crypto();

  final String schemaLocation;

  getVPSchema() async {
    final locations = await getSchemaLocation();

    final response = await Dio().get(locations['schema']);

    return responseCheck(response);
  }

  postVP(data, privateKey) async {
    final locations = await getSchemaLocation();

    final response = await Dio().post(
      locations["VPPost"],
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );

    final result = responseCheck(response);
    log.i('b:$result, ${result.runtimeType}');

    final challenge = jsonDecode(result);
    log.i('c');

    log.i('${response.headers}');
    log.i('${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final challengeResult =
          await didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization']![0], privateKey);
      if (challengeResult) {
        return response.headers['authorization']![0];
      }
    }
    return false;
  }

  getSchemaLocation() async {
    log.i(schemaLocation);

    final response = await Dio().get(schemaLocation);

    final vcLocation = responseCheck(response);
    return json.decode(vcLocation.data);
  }

  didAuth(payload, endPoint, token, privateKey) async {
    log.i('did Auth');

    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(challengeBytes, privateKey);

    final response2 = await responseChallenge(endPoint, Base58Encode(signature), token);
    if (response2 == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    final response = await Dio().get(
      challengeUri,
      queryParameters: {'signature': encodedSignatureBytes},
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    );

    return responseCheck(response);
  }

  responseCheck(Response<dynamic> response) {
    switch ((response.statusCode! / 100).floor()) {
      case 2:
        log.i("response: ${response.data}");
        return response;
      default:
        log.lw("Response Error $response");
        return response;
      // throw Error();
    }
  }
}
