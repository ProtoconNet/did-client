import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:fast_base58/fast_base58.dart';
import 'package:wallet/providers/global_variable.dart';

class Issuer {
  final g = Get.put(GlobalVariable());

  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        g.log.i(response);
        return response;
        break;
      default:
        g.log.w("Response Error", response);
        return response;
        // throw Error();
        break;
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

  requestVC(requestVCUri) async {
    http.Response response = await http.get(
      requestVCUri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
//        HttpHeaders.authorizationHeader: 'Bearer ' + token
      },
    );
    return responseCheck(response);
  }

  responseChallenge(challengeUri, signature, token) async {
    http.Response response = await http.get(
        challengeUri.replace(queryParameters: {'signature': Base58Encode(signature.bytes)}),
        headers: {HttpHeaders.authorizationHeader: 'Bearer ' + token});
    return responseCheck(response);
  }

  getSchemaLocation(schemaLocationUri) async {
    http.Response response = await http.get(schemaLocationUri);
    return responseCheck(response);
  }
}
