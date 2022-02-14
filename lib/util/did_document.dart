// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:fast_base58/fast_base58.dart';
import 'package:enum_to_string/enum_to_string.dart';

import 'package:wallet/util/logger.dart';

enum AsymmetricKeyType {
  JsonWebKey2020,
  EcdsaSecp256k1VerificationKey2019,
  Ed25519VerificationKey2018,
  Bls12381G1Key2020,
  Bls12381G2Key2020,
  PgpVerificationKey2021,
  RsaVerificationKey2018,
  X25519KeyAgreementKey2019,
  SchnorrSecp256k1VerificationKey2019,
  EcdsaSecp256k1RecoveryMethod2020,
  VerifiableCondition2021,
}

class KeyInfo {
  KeyInfo(this.type, this.context);

  String type;
  String context;
}

Map<AsymmetricKeyType, dynamic> Key = {
  AsymmetricKeyType.JsonWebKey2020: {},
  AsymmetricKeyType.EcdsaSecp256k1VerificationKey2019: {},
  AsymmetricKeyType.Ed25519VerificationKey2018: {},
  AsymmetricKeyType.Bls12381G1Key2020: {},
  AsymmetricKeyType.Bls12381G2Key2020: {},
  AsymmetricKeyType.PgpVerificationKey2021: {},
  AsymmetricKeyType.RsaVerificationKey2018: {},
  AsymmetricKeyType.X25519KeyAgreementKey2019: {},
  AsymmetricKeyType.SchnorrSecp256k1VerificationKey2019: {},
  AsymmetricKeyType.EcdsaSecp256k1RecoveryMethod2020: {},
  AsymmetricKeyType.VerifiableCondition2021: {},
};

enum PublicKeyType {
  publicKeyJwk,
  publicKeyMultibase,
  // publicKeyBase58,
  // publicKeyHex,
  // blockchainAccountId,
  // ethereumAddress,
}

enum VCType { VerifiablePresentation, VerifiableCredential }

List<String> didDocumentProperties = [
  "id",
  "alsoKnownAs",
  "controller",
  "verificationMethod",
  "authentication",
  "assertionMethod",
  "keyAgreement",
  "capabilityInvocation",
  "capabilityDelegation",
  "service",
];

List<String> verificationMethodProperties = [
  "id",
  "controller",
  "type",
  "publicKeyJwk",
  "publicKeyMultibase",
];

List<String> serviceProperties = [
  "id",
  "type",
  "serviceEndpoint",
];

class JsonTypeDIDDocument {
  final log = Log();
  Map<String, dynamic> base = {"id": ""};

  Map<String, dynamic> proofTemplate = {
    "type": "",
    "expire": "",
    "created": "",
    "proofPurpose": "",
  };

  Map<String, dynamic> keyTemplate = {
    "id": "",
    "type": "",
    "controller": "",
  };

  String _asymmetricKeyTypeContext(AsymmetricKeyType type) {
    switch (type) {
      case AsymmetricKeyType.JsonWebKey2020:
        return "JsonWebKey2020";
      case AsymmetricKeyType.EcdsaSecp256k1VerificationKey2019:
        return "EcdsaSecp256k1VerificationKey2019";
      case AsymmetricKeyType.Ed25519VerificationKey2018:
        return "Ed25519VerificationKey2018";
      case AsymmetricKeyType.Bls12381G1Key2020:
        return "Bls12381G1Key2020";
      case AsymmetricKeyType.Bls12381G2Key2020:
        return "Bls12381G2Key2020";
      case AsymmetricKeyType.PgpVerificationKey2021:
        return "PgpVerificationKey2021";
      case AsymmetricKeyType.RsaVerificationKey2018:
        return "RsaVerificationKey2018";
      case AsymmetricKeyType.X25519KeyAgreementKey2019:
        return "X25519KeyAgreementKey2019";
      case AsymmetricKeyType.SchnorrSecp256k1VerificationKey2019:
        return "SchnorrSecp256k1VerificationKey2019";
      case AsymmetricKeyType.EcdsaSecp256k1RecoveryMethod2020:
        return "EcdsaSecp256k1RecoveryMethod2020";
      case AsymmetricKeyType.VerifiableCondition2021:
        return "VerifiableCondition2021";
      default:
        return "";
    }
  }

  String _asymmetricKeyType(AsymmetricKeyType type) {
    switch (type) {
      case AsymmetricKeyType.JsonWebKey2020:
        return "JsonWebKey2020";
      case AsymmetricKeyType.EcdsaSecp256k1VerificationKey2019:
        return "EcdsaSecp256k1VerificationKey2019";
      case AsymmetricKeyType.Ed25519VerificationKey2018:
        return "Ed25519VerificationKey2018";
      case AsymmetricKeyType.Bls12381G1Key2020:
        return "Bls12381G1Key2020";
      case AsymmetricKeyType.Bls12381G2Key2020:
        return "Bls12381G2Key2020";
      case AsymmetricKeyType.PgpVerificationKey2021:
        return "PgpVerificationKey2021";
      case AsymmetricKeyType.RsaVerificationKey2018:
        return "RsaVerificationKey2018";
      case AsymmetricKeyType.X25519KeyAgreementKey2019:
        return "X25519KeyAgreementKey2019";
      case AsymmetricKeyType.SchnorrSecp256k1VerificationKey2019:
        return "SchnorrSecp256k1VerificationKey2019";
      case AsymmetricKeyType.EcdsaSecp256k1RecoveryMethod2020:
        return "EcdsaSecp256k1RecoveryMethod2020";
      case AsymmetricKeyType.VerifiableCondition2021:
        return "VerifiableCondition2021";
      default:
        return "";
    }
  }

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

  getKeyObject(String id, String type, String controller, PublicKeyType publicKeyType, List<int> publicKey) {
    var verificationMethod = keyTemplate;
    verificationMethod["id"] = id;
    verificationMethod["type"] = type;
    verificationMethod["controller"] = _isDIDFormat(controller)!;
    verificationMethod[EnumToString.convertToString(publicKeyType)] = _publicKeyType(publicKeyType, publicKey);
  }

  addProof(String type, DateTime expire, DateTime created, String proofPurpose, {String? challenge, String? domain}) {
    var proof = proofTemplate;
    proof["type"] = type;
    proof["expire"] = expire.toIso8601String();
    proof["created"] = created.toIso8601String();
    proof["proofPurpose"] = proofPurpose;
    if (challenge != null) {
      proof["challenge"] = challenge;
    }
    if (domain != null) {
      proof["domain"] = domain;
    }

    base["proof"] = [proof];
  }

  createDIDDocument(String did, AsymmetricKeyType keyType, PublicKeyType pubKeyType, List<int> publicKey) {
    log.i("JsonDIDDocument:createDIDDocument");

    var didDocument = base;

    didDocument["@context"] = ["https://www.w3.org/ns/did/v1", "https://w3id.org/security/suites/ed25519-2020/v1"];
    didDocument["id"] = did;
    didDocument["authentication"] = [
      getKeyObject(did, _asymmetricKeyType(keyType), did, pubKeyType, _publicKeyType(pubKeyType, publicKey))
    ];
    didDocument["verificationMethod"] = [
      getKeyObject(did, _asymmetricKeyType(keyType), did, pubKeyType, _publicKeyType(pubKeyType, publicKey))
    ];

    return json.encode(didDocument);
  }

  createVP(String did, String keyLocation, String audience, List<Map<String, dynamic>> payload, List<int> pk) async {
    log.i("JsonDIDDocument:createVP");
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

    var vp2 = template;

    proof["jws"] = token; //noPayloadToken;
    vp2["proof"] = [proof];

    return vp;
  }
}

// old version
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

    var vp2 = template;

    proof["jws"] = token; //noPayloadToken;

    vp2["proof"] = [proof];

    return vp;
  }
}
