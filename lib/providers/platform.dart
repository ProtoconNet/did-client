import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wallet/utils/logger.dart';

class Platform {
  final log = Log();

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
    var didDocument = createDIDDocument(did);

    var response = await http.post(
      setDIDDocumentUri,
      headers: {"Content-Type": "application/json", "Accept": "application/json"},
      body: didDocument,
    );

    return responseCheck(response);
  }

  getScheme(schemeUri) async {
    http.Response response = await http.get(schemeUri);

    return responseCheck(response);
  }

  createDIDDocument(did) {
    final didExample = {
      "@context": ["https://www.w3.org/ns/did/v1", "https://w3id.org/security/suites/ed25519-2020/v1"],
      "id": did,
      "authentication": [
        {
          "id": did + "#z" + did.substring(8),
          "type": "Ed25519VerificationKey2018",
          "controller": did,
          "publicKeyMultibase": "z" + did.substring(8)
        }
      ],
      "verificationMethod": [
        {"id": did, "type": "Ed25519VerificationKey2018", "controller": did, "publicKeyBase58": did.substring(8)},
      ]
    };

    return json.encode(didExample);
  }
}
