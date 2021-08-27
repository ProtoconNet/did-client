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
/*
  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        log.i("response: ${response.body}");
        return response.body;
      default:
        log.lw("Response Error ${response.statusCode}:${response.body}");
        return response.body;
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
      body: json.encode(body),
    );
    final challenge = json.decode(responseCheck(response));

    // final challenge = jsonDecode(result.body);

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
    return json.decode(vcLocation);
  }

  didAuth(payload, endPoint, token, privateKey) async {
    log.i('did Auth');

    final challengeBytes = utf8.encode(payload);

    final signature = await crypto.sign(challengeBytes, privateKey);

    final response2 = await responseChallenge(Uri.parse(endPoint), Base58Encode(signature), token);
    if (response2 == "") {
      log.le("Challenge Failed");
      return false;
    }
    return true;
  }
  */
  responseCheck(Response<dynamic> response) {
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
    final locations = await getSchemaLocation();
    final response = await Dio().get(
      locations['VCGet'],
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    );
    return responseCheck(response);
  }

  postVC(data, privateKey) async {
    final locations = await getSchemaLocation();
    log.i('1:${locations['VCPost']}, $data');

    // var response = await http.post(
    //   Uri.parse(locations['VCPost']),
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Accept": "application/json",
    //   },
    //   body: json.encode(data),
    // );
    // log.i("response body: ${response.body}");

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
    log.i('a:${response.data}');

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

  responseChallenge(challengeUri, encodedSignatureBytes, token) async {
    final response = await Dio().get(
      challengeUri,
      queryParameters: {'signature': encodedSignatureBytes},
      options: Options(contentType: Headers.jsonContentType, headers: {"Authorization": 'Bearer ' + token}),
    );

    return responseCheck(response);
  }

  getSchemaLocation() async {
    log.i(schemaLocation);

    final response = await Dio().get(schemaLocation);

    final vcLocation = responseCheck(response);
    return json.decode(vcLocation);
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
}
