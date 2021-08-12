import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fast_base58/fast_base58.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';
import 'package:wallet/util/crypto.dart';

class Issuer {
  Issuer(this.schemaLocation);
  final log = Log();
  final g = Get.put(GlobalVariable());
  final crypto = Crypto();

  final String schemaLocation;

  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        log.i("response: ${response.body}");
        return response;
      default:
        log.lw("Response Error $response");
        return response;
      // throw Error();
    }
  }

  getVC(token) async {
    final locations = await getSchemaLocation();
    http.Response response = await http.get(
      Uri.parse(locations['VCGet']),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ' + token
      },
    );
    return responseCheck(response);
  }

  postVC(body, privateKey) async {
    final locations = await getSchemaLocation();
    http.Response response = await http.post(
      Uri.parse(locations['VCPost']),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body,
    );
    final result = responseCheck(response);

    final challenge = jsonDecode(result.body);

    if (challenge.containsKey('payload')) {
      final challengeResult =
          await didAuth(challenge['payload'], challenge['endPoint'], response.headers['authorization'], privateKey);
      if (challengeResult) {
        return response.headers['authorization'];
      }
    }
    return false;
  }

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    http.Response response = await http.get(challengeUri.replace(queryParameters: {'signature': encodedSignatureBytes}),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});
    return responseCheck(response);
  }

  getSchemaLocation() async {
    log.i(schemaLocation);
    http.Response response = await http.get(Uri.parse(schemaLocation));
    final vcLocation = responseCheck(response);
    return json.decode(vcLocation.body);
  }

  didAuth(payload, endPoint, token, privateKey) async {
    log.i('did Auth');

    final pk = await g.didManager.value.getDIDPK(g.did.value, g.password.value);
    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(challengeBytes, pk);

    final response2 = await responseChallenge(Uri.parse(endPoint), Base58Encode(signature), token);
    if (response2 == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }
}
