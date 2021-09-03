import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:wallet/util/logger.dart';

class DID {}

enum PublicKeyType {
  publicKeyJwk,
  publicKeyBase58,
  publicKeyHex,
  publicKeyMultibase,
  blockchainAccountId,
  ethereumAddress,
}

class Authentication {
  String id = "";
  String type = ""; // enum??
  String controller = ""; // did type check??
  String publicKeyMultibase = ""; // type??
}

class VerificationMethod {
  String id = "";
  String type = ""; // enum??
  String controller = ""; // did type check??
  String publicKeyMultibase = ""; // type??
}

class DIDDocumentTmp {
  List<String> context = [];
  String id = ""; // single URI
  List<String> type = []; // VerificationCredential, VerifiablePresentation, UniversityDegreeCredential...
  dynamic issuer = ""; // URI or Map
  DateTime issuanceDate = DateTime.now();
  DateTime expirationDate = DateTime.now();
  Map<String, dynamic> credentialSubject = {};
  Map<String, dynamic> credentialStatus = {};
  List<Map<String, dynamic>> verifiableCredential = [];
  List<Authentication> authentication = [];
  List<VerificationMethod> verificationMethod = [];
}

class Proof {
  String type = "";
  DateTime expire = DateTime.now();
  DateTime created = DateTime.now();
  String proofPurpose = "";
  String verificationMethod = "";
  String challenge = "";
  String domain = "";
}

class JsonTypeDIDDocument {
  Map<String, dynamic> base = {"id": ""};

  Map<String, dynamic> proof = {
    "type": "",
    "expire": "",
    "created": "",
    "proofPurpose": "",
  };

  Map<String, dynamic> verificationMethod = {
    "id": "",
    "type": "",
    "controller": "",
    "publicKeyMultibase": "",
  };
  Map<String, dynamic> authentication = {};

  dynamic _publicKeyType(PublicKeyType type, List<int> publicKey) {
    switch (type) {
      // case PublicKeyType.publicKeyJwk:
      //   return {};
      // case PublicKeyType.publicKeyBase58:
      //   return "";
      // case PublicKeyType.publicKeyHex:
      //   return "";
      case PublicKeyType.publicKeyMultibase:
        return "z" + Base58Encode(publicKey);
      // case PublicKeyType.blockchainAccountId:
      //   return "";
      // case PublicKeyType.ethereumAddress:
      //   return "";
      default:
        return null;
    }
  }

  String? _isDIDFormat(String did) {
    var splitDID = did.split(":");
    if (splitDID.length == 3) {
      return did;
    }
    return null;
  }

  String? _isURI(String val) {
    return val;
  }

  addVerificationMethod(String id, String type, String controller, PublicKeyType publicKeyType, List<int> publicKey) {
    var newVerificationMethod = verificationMethod;
    newVerificationMethod["id"] = id;
    newVerificationMethod["type"] = type;
    newVerificationMethod["controller"] = _isDIDFormat(controller)!;

    newVerificationMethod[EnumToString.convertToString(publicKeyType)] = _publicKeyType(publicKeyType, publicKey);
  }

  addProof(String type, DateTime expire, DateTime created, String proofPurpose, {String? challenge, String? domain}) {
    var newProof = proof;
    newProof["type"] = type;
    newProof["expire"] = expire.toIso8601String();
    newProof["created"] = created.toIso8601String();
    newProof["proofPurpose"] = proofPurpose;
    if (challenge != null) {
      newProof["challenge"] = challenge;
    }
    if (domain != null) {
      newProof["domain"] = domain;
    }

    base["proof"] = [proof];
  }
}

class DIDDocument {
  final log = Log();

  String createDIDDocument(String did) {
    log.i("DIDDocument:createDIDDocument");
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

  Future<Map<String, dynamic>> createVP(
      String did, String keyLocation, String audience, List<Map<String, dynamic>> payload, List<int> pk) async {
    log.i("DIDDocument:createVP");
    // payload is vc list
    var now = DateTime.now();

    var expire = now.add(const Duration(minutes: 1));
    var template = {
      "@context": ["https://www.w3.org/2018/credentials/v1", "https://www.w3.org/2018/credentials/examples/v1"],
      "id": did,
      "type": ["VerifiablePresentation"],
      "issuer": did,
      "issuanceDate": now.toIso8601String(),
      "expirationDate": expire.toIso8601String(),
      "verifiableCredential": payload,
    };

    var vp = template;

    var proof = {
      "type": "Ed25519Signature2018",
      "expire": expire.toIso8601String(),
      "created": now.toIso8601String(),
      "proofPurpose": "authentication",
      "verificationMethod": keyLocation,
      // "challenge": "c0ae1c8e-c7e7-469f-b252-86e6a0e7387e", // random
      // "domain": "test.org", // submit vp domain
    };

    vp["proof"] = [proof];

    // Create a json web token
    final jwt = JWT(vp); //, issuer: did, audience: audience, jwtId: "test");

    var token = jwt.sign(EdDSAPrivateKey(pk),
        algorithm: JWTAlgorithm.EdDSA,
        noIssueAt: true); //, expiresIn: Duration(minutes: 1), notBefore: Duration(seconds: 0));

    // var splitToken = token.split('.');
    // var noPayloadToken = splitToken[0] + ".." + splitToken[2];

    log.i(vp["proof"]);

    var vp2 = template;

    proof["jws"] = token; //noPayloadToken;

    vp2["proof"] = [proof];

    log.i(token);
    // log.i("jws: ${vp['proof']}");

    return vp;
  }
}
