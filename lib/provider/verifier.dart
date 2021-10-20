import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

const VPRequestExample = {
  "requestAttribute": [
    {
      "name": "driverLicense",
      "restrictions": {"schemaId": "_schemaId", "credDefId": "_credDefId"},
      "concealable": true
    },
    {
      "name": "jejuPass",
      "restrictions": {"schemaId": "_schemaId", "credDefId": "_credDefId"},
      "concealable": true
    }
  ],
  "predicateAttribute": [
    {
      "name": "이번엔 사용 안함",
      "condition": "ZKP를 위한 컨디션 (보다 크다, 작다 등등)",
      "value": "ZKP를 위한 값",
      "restrictions": {"schemaId": "_schemaId", "credDefId": "_credDefId"}
    }
  ],
  "selfAttestedAttribute": [
    {"name": "유저에게 전달받는 추가 정보. 따로 검증은 안함"}
  ]
};

class Verifier {
  Verifier(this.schemaLocation);
  final log = Log();
  final crypto = Crypto();

  final String schemaLocation;

  getVPSchema() async {
    log.i("Verifier:getVPSchema");
    final locations = await getSchemaLocation();

    final response = await Dio().get(locations['schema']).catchError((onError) {
      log.e("getVPSchema error: ${onError.toString()}");
    });

    return response;
  }

  Future<String> postVP(Map<String, dynamic> data, String privateKey) async {
    log.i("Verifier:postVP");
    log.i("params:$data");
    final locations = await getSchemaLocation();

    log.i("locations['VPPost']:${locations['VPPost']}");
    final response = await Dio()
        .post(
      locations["VPPost"],
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    )
        .catchError((onError) {
      log.e("postVP error: ${onError.toString()}");
    });

    final challenge = jsonDecode(response.data);

    log.i('response.headers: ${response.headers}');
    log.i('headers authorization: ${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final challengeResult =
          await didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization']![0], privateKey);
      log.i("challengeResult: $challengeResult");
    }

    return "";
  }

  getSchemaLocation() async {
    log.i("Verifier:getSchemaLocation");
    log.i("schemaLocation:$schemaLocation");

    final response = await Dio().get(schemaLocation).catchError((onError) {
      log.e("getSchemaLocation error: ${onError.toString()}");
    });

    return json.decode(response.data);
  }

  Future<bool> didAuth(String payload, endPoint, String token, String privateKey) async {
    log.i('Verifier:didAuth');

    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(Algorithm.ed25519, challengeBytes, privateKey);

    final response2 = await responseChallenge(endPoint, Base58Encode(signature), token);
    if (response2 == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    log.i('Verifier:responseChallenge');
    final response = await Dio()
        .get(
      challengeUri,
      queryParameters: {'signature': encodedSignatureBytes},
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      log.e("responseChallenge error: ${onError.toString()}");
    });

    return response;
  }
}
