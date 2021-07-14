import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wallet/providers/global_variable.dart';

class Platform {
  final g = Get.put(GlobalVariable());

  responseCheck(http.Response response) {
    switch ((response.statusCode / 100).floor()) {
      case 2:
        g.log.i(response);
        return response;
      default:
        g.longLog.w("Response Error", response);
        return response;
      // throw Error();
    }
  }

  getDIDDocument(Uri getDIDDocumentUri) async {
    print(getDIDDocumentUri.normalizePath());
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
