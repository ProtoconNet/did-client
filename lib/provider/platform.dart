import 'package:http/http.dart' as http;

import 'package:wallet/util/logger.dart';
import 'package:wallet/util/did_document.dart';

class Platform {
  final log = Log();

  final didDocument = DIDDocument();

  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        // log.i("${response.body}");
        return response;
      default:
        log.lw("Response Error: $response");
        return response;
      // throw Error();
    }
  }

  getDIDDocument(Uri getDIDDocumentUri) async {
    log.i(getDIDDocumentUri.normalizePath());
    http.Response response = await http.get(getDIDDocumentUri); //.replace(queryParameters: {'did': did}));

    return responseCheck(response);
  }

  setDIDDocument(setDIDDocumentUri, did) async {
    var document = didDocument.createDIDDocument(did);

    var response = await http.post(
      setDIDDocumentUri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: document,
    );

    return responseCheck(response);
  }

  getSchema(schemaUri) async {
    http.Response response = await http.get(schemaUri);

    return responseCheck(response);
  }
}
