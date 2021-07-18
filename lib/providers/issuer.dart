import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fast_base58/fast_base58.dart';
import 'package:wallet/utils/logger.dart';

class Issuer {
  final log = Log();
  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        log.i("$response, ${response.body}");
        return response;
      default:
        log.lw("Response Error $response");
        return response;
      // throw Error();
    }
  }

  getVC(getVCUri, token) async {
    http.Response response = await http.get(
      getVCUri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: 'Bearer ' + token
      },
    );
    return responseCheck(response);
  }

  requestVC(requestVCUri, body) async {
    http.Response response = await http.post(
      requestVCUri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: body,
    );
    return responseCheck(response);
  }

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    http.Response response = await http.get(challengeUri.replace(queryParameters: {'signature': encodedSignatureBytes}),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});
    return responseCheck(response);
  }

  getSchemaLocation(schemaLocationUri) async {
    http.Response response = await http.get(schemaLocationUri);
    return responseCheck(response);
  }
}
