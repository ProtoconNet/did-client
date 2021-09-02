import 'package:dio/dio.dart';

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/did_document.dart';

class Platform {
  final log = Log();

  final didDocument = DIDDocument();

  Response<dynamic> responseCheck(Response<dynamic> response) {
    log.i("Platform:responseCheck(response:$response)");
    switch ((response.statusCode! / 100).floor()) {
      case 2:
        // log.i("${response.body}");
        return response;
      default:
        log.lw("Response Error: $response");
        return response;
      // throw Error();
    }
  }

  Future<Response<dynamic>> getDIDDocument(String getDIDDocumentUri) async {
    log.i("Platform:getDIDDocument(getDIDDocumentUri:$getDIDDocumentUri)");
    log.i(getDIDDocumentUri);
    final response = await Dio().get(getDIDDocumentUri);

    return responseCheck(response);
  }

  Future<Response<dynamic>> setDIDDocument(String setDIDDocumentUri, String did) async {
    log.i("Platform:setDIDDocument(setDIDDocumentUri:$setDIDDocumentUri, did:$did)");
    String document = didDocument.createDIDDocument(did);

    var response =
        await Dio().post(setDIDDocumentUri, options: Options(contentType: Headers.jsonContentType), data: document);

    return responseCheck(response);
  }

  Future<Response<dynamic>> getSchema(String schemaUri) async {
    log.i("Platform:getSchema(schemaUri:$schemaUri)");
    final response = await Dio().get(schemaUri);

    return responseCheck(response);
  }
}
