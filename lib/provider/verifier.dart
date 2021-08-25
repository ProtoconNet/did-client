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

    final response = await Dio().get("http://mtm.securekim.com:3082/VPSchema?schema=rentCar");

    return responseCheck(response);
  }

  postVP(data) async {
    final locations = await getSchemaLocation();

    final response = await Dio().post(
      "http://mtm.securekim.com:3082/vp1",
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );

    return responseCheck(response);
  }

  getSchemaLocation() async {
    log.i(schemaLocation);

    final response = await Dio().get(schemaLocation);

    final vcLocation = responseCheck(response);
    return json.decode(vcLocation.data);
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
