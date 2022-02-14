import 'dart:convert';
import 'package:get/get.dart' as g;

import 'package:dio/dio.dart';
// import 'package:http/http.dart' as http;
import 'package:fast_base58/fast_base58.dart';

// import 'package:wallet/model/vp.dart';
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
      "name": "protoconPass",
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
  Verifier(this.endPoint);
  final log = Log();
  final crypto = Crypto();

  final String endPoint;

  Future<String?> presentationProposal(String did) async {
    log.i("Verifier:presentationProposal(did:$did)");
    final locations = await getUrls();

    // final url = endPoint + locations['getPresentationProposal'] + "?did=$did";

    var response = await Dio().get(
      endPoint + locations['getPresentationProposal'],
      queryParameters: {"did": did},
      // options: Options(headers: {"Authorization": 'Bearer ' + token}),
    ).catchError((onError) {
      g.Get.snackbar("Connection Error", "verifier.presentationProposal Connection Error");
      g.Get.snackbar("", "");
      log.e("PresentationProposal error:${onError.toString()}");
    });
    log.i('response.data: ${response.data}');

    return response.data;
  }

  Future<dynamic> presentationProof(String did, Map<String, dynamic> vp, String token) async {
    log.i("Verifier:presentationProof(did:$did, token:$token)");
    final locations = await getUrls();

    // log.i('{"did": $did, "vp", ${json.encode(vp)}}');

    var response = await Dio()
        .post(
      endPoint + locations['postPresentationProof'],
      data: '{"did": "$did", "vp": ${json.encode(vp)}}',
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {"Authorization": 'Bearer ' + token},
      ),
    )
        .catchError((onError) {
      g.Get.snackbar("Connection Error", "verifier.presentationProof Connection Error");
      g.Get.snackbar("", "");
      log.e("PresentationProof error:${onError.toString()}");
    });

    return response;
  }

  ackMessage(String token) async {
    log.i("Verifier:ackMessage(token:$token)");
    final locations = await getUrls();

    await Dio()
        .get(
      endPoint + locations['getAckMessage'],
      options: Options(headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      g.Get.snackbar("Connection Error", "verifier.ackMessage Connection Error");
      g.Get.snackbar("", "");
      log.e("CredentialProposal error:${onError.toString()}");
    });
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
      g.Get.snackbar("Connection Error", "verifier.responseChallenge Connection Error");
      g.Get.snackbar("", "");
      log.e("responseChallenge error:${onError.toString()}");
    });

    return response;
  }

  Future<Map<String, dynamic>> getUrls() async {
    log.i("Issuer:getUrls");

    final response = await Dio().get(endPoint + "/urls").catchError((onError) {
      g.Get.snackbar("Connection Error", "verifier.getUrls Connection Error");
      g.Get.snackbar("", "");
      log.e("getUrls error:${onError.toString()}");
    });

    return json.decode(response.data);
  }

  Future<String> didAuthentication(String did, String privateKey) async {
    log.i("Issuer:didAuthentication");

    final locations = await getUrls();

    var response = await Dio()
        .post(endPoint + locations['didAuth'],
            data: '{"did":"$did"}', options: Options(contentType: Headers.jsonContentType))
        .catchError((onError) {
      g.Get.snackbar("Connection Error", "verifier.didAuthentication Connection Error");
      g.Get.snackbar("", "");
      log.e("did Auth error:${onError.toString()}");
    });

    final challenge = jsonDecode(response.data);

    // log.i('response.headers: ${response.headers}');
    // log.i('headers authorization: ${response.headers['authorization']}');

    if (challenge.containsKey('payload')) {
      final payload = challenge['payload'];
      final token = response.headers['authorization']![0];
      final challengeEndpoint = challenge['endPoint'];

      final challengeBytes = utf8.encode(payload);

      final signature = await crypto.sign(Algorithm.ed25519, challengeBytes, privateKey);

      final response2 = await responseChallenge(challengeEndpoint, Base58Encode(signature), token);
      if (response2.data == "") {
        log.le("Challenge Failed");
        return "";
      }
    }
    return response.headers['authorization']![0];
  }
}
