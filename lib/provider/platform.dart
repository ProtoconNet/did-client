import 'package:dio/dio.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/did_document.dart';

class Platform {
  final log = Log();

  final didDocument = DIDDocument();
/*
  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        log.i("${response.body}");
        try {
          return json.decode(response.body);
        } catch (e) {
          log.e(e);
          return response.body;
        }
      default:
        log.lw("Response Error: $response");
        return json.decode(response.body);
      // throw Error();
    }
  }

  getDIDDocument(String getDIDDocumentUri) async {
    log.i(getDIDDocumentUri);
    http.Response response = await http.get(Uri.parse(getDIDDocumentUri)); //.replace(queryParameters: {'did': did}));

    return responseCheck(response);
  }

  setDIDDocument(String setDIDDocumentUri, String did) async {
    var document = didDocument.createDIDDocument(did);

    var response = await http.post(
      Uri.parse(setDIDDocumentUri),
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: document,
    );

    return responseCheck(response);
  }

  getSchema(String schemaUri) async {
    http.Response response = await http.get(Uri.parse(schemaUri));

    return responseCheck(response);
  }
*/
  responseCheck(Response<dynamic> response) {
    switch ((response.statusCode! / 100).floor()) {
      case 2:
        // log.i("${response.body}");
        return response.data;
      default:
        log.lw("Response Error: $response");
        return response.data;
      // throw Error();
    }
  }

  getDIDDocument(String getDIDDocumentUri) async {
    log.i(getDIDDocumentUri);
    final response = await Dio().get(getDIDDocumentUri);

    return responseCheck(response);
  }

  setDIDDocument(String setDIDDocumentUri, String did) async {
    var document = didDocument.createDIDDocument(did);

    var response =
        await Dio().post(setDIDDocumentUri, options: Options(contentType: Headers.jsonContentType), data: document);

    return responseCheck(response);
  }

  getSchema(schemaUri) async {
    final response = await Dio().get(schemaUri);

    return responseCheck(response);
  }
}
