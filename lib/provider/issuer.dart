import 'dart:convert';
import 'package:get/get.dart' as g;
import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

class Issuer {
  Issuer(this.endPoint);
  final log = Log();
  final crypto = Crypto();

  final String endPoint;

  Future<String?> credentialProposal(
      String did, String schemaID, String creDefId, String privateKey, String token) async {
    log.i("Issuer:credentialProposal(schemaID:$schemaID, creDefId:$creDefId, privateKey:$privateKey)");
    final locations = await getUrls();

    // final url = endPoint + locations['getCredentialProposal'] + "?did=$did&schemaID=$schemaID&creDefId=$creDefId";

    var response = await Dio()
        .get(
      endPoint + locations['getCredentialProposal'],
      queryParameters: {"did": did, "schemaID": schemaID, "creDefId": creDefId},
      options: Options(headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      g.Get.snackbar("connection error", "issuer.credentialProposal connection error");
      g.Get.snackbar("", "");
      log.e("CredentialProposal error:${onError.toString()}");
    });
    log.i('response.data: ${response.data}');

    return token;
  }

  Future<dynamic> credentialRequest(String did, String schemaID, String creDefId, String token) async {
    log.i("Issuer:credentialRequest(did:$did, schemaID:$schemaID, creDefId:$creDefId, token:$token)");
    final locations = await getUrls();

    var response = await Dio()
        .get(
      endPoint + locations['getCredentialRequest'],
      queryParameters: {"did": did, "schemaID": schemaID, "creDefId": creDefId},
      options: Options(headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      g.Get.snackbar("connection error", "issuer.credentialRequest connection error");
      g.Get.snackbar("", "");
      log.e("CredentialProposal error:${onError.toString()}");
    });
    // log.i('response.data: ${response.data}');
    // log.i('response.data: ${json.decode(response.data)['VC']}');

    return response;
  }

  ackMessage(String token) async {
    log.i("Issuer:ackMessage(token:$token)");
    final locations = await getUrls();

    await Dio()
        .get(
      endPoint + locations['getAckMessage'],
      options: Options(headers: {"Authorization": 'Bearer ' + token}),
    )
        .catchError((onError) {
      g.Get.snackbar("connection error", "issuer.ackMessage connection error");
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
      g.Get.snackbar("connection error", "issuer.responseChallenge connection error");
      g.Get.snackbar("", "");
      log.e("responseChallenge error:${onError.toString()}");
    });

    return response;
  }

  Future<Map<String, dynamic>> getUrls() async {
    log.i("Issuer:getUrls");

    final response = await Dio().get(endPoint + "/urls").catchError((onError) {
      g.Get.snackbar("Connection Error", "issuer.getUrls Connection Error");
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
      g.Get.snackbar("connection error", "issuer.didAuthentication connection error");
      g.Get.snackbar("", "");
      log.e("did Auth error:${onError.toString()}");
    });

    final challenge = jsonDecode(response.data);

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
