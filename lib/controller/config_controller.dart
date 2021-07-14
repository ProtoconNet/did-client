import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/pages/select_join.dart';

class ConfigController extends GetxController {
  final box = GetStorage();
  final storage = FlutterSecureStorage();
  final g = Get.put(GlobalVariable());

  var theme = 'system'.obs;
  var language = 'system'.obs;

  @override
  onInit() {
    language.value = g.language;

    theme.value = g.theme;
    super.onInit();
  }

  setTheme(val) {
    theme.value = val;
    g.changeTheme(val);
  }

  setLanguage(val) {
    language.value = val;
    g.changeLanguage(val);
  }

  var text = "".obs;

  void setText(val) {
    text.value = val;
  }

  String getAccount() {
    return g.did.value;
  }

  jsonldTest() async {
    // final didExample = """{
    //   "@context": ["https://www.w3.org/ns/did/v1", "https://w3id.org/security/suites/ed25519-2020/v1"],
    //   "id": g.did.value,
    //   "authentication": [
    //     {
    //       "id": g.did.value + "#z" + g.did.value.substring(8),
    //       "type": "Ed25519VerificationKey2018",
    //       "controller": g.did.value,
    //       "publicKeyMultibase": "z" + g.did.value.substring(8)
    //     }
    //   ],
    //   "verificationMethod": [
    //     {
    //       "id": g.did.value,
    //       "type": "Ed25519VerificationKey2018",
    //       "controller": g.did.value,
    //       "publicKeyBase58": g.did.value.substring(8)
    //     },
    //   ]
    // }""";

    // var structuredData = MetadataParser.jsonLdSchema(MetadataFetch.responseToDocument(didExample));
    // g.log.i(structuredData);
    /*
    final referencedSchema = {
      r"$id": "https://example.com/geographical-location.schema.json",
      r"$schema": "http://json-schema.org/draft-06/schema#",
      "title": "Longitude and Latitude",
      "description": "A geographical coordinate on a planet (most commonly Earth).",
      "required": ["latitude", "longitude"],
      "type": "object",
      "properties": {
        "name": {"type": "string"},
        "latitude": {"type": "number", "minimum": -90, "maximum": 90},
        "longitude": {"type": "number", "minimum": -180, "maximum": 180}
      }
    };

    final RefProviderAsync refProvider = (String ref) async {
      final Map references = {
        'https://example.com/geographical-location.schema.json': JsonSchema.createSchema(referencedSchema),
      };

      if (references.containsKey(ref)) {
        // Silly example that adds a 1 second delay.
        // In practice, you could make any service call here,
        // parse the results into a schema, and return.
        await new Future.delayed(new Duration(seconds: 1));
        return references[ref];
      }

      // Fall back to default URL $ref behavior
      return await JsonSchema.createSchemaFromUrl(ref);
    };

    final schema = await JsonSchema.createSchemaAsync({
      'type': 'array',
      'items': {r'$ref': 'https://example.com/geographical-location.schema.json'}
    }, refProvider: refProvider);

    final workivaLocations = [
      {
        'name': 'Ames',
        'latitude': 41.9956731,
        'longitude': -93.6403663,
      },
      {
        'name': 'Scottsdale',
        'latitude': 33.4634707,
        'longitude': -111.9266617,
      }
    ];

    final badLocations = [
      {
        'name': 'Bad Badlands',
        'latitude': 181,
        'longitude': 92,
      },
      {
        'name': 'Nowhereville',
        'latitude': -2000,
        'longitude': 7836,
      }
    ];

    g.log.i('${json.encode(workivaLocations)} => ${schema.validate(workivaLocations)}');
    g.log.i('${json.encode(badLocations)} => ${schema.validate(badLocations)}');
    */
  }

  Future<void> deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    final appDir = await getApplicationSupportDirectory();

    if (appDir.existsSync()) {
      appDir.deleteSync(recursive: true);
    }
  }

  eraseAll() async {
    // box.remove('themeMode');
    // box.remove('language');
    if (await storage.containsKey(key: "DIDList")) {
      String didList = await storage.read(key: "DIDList") as String;

      print(didList);
      print(json.decode(didList));

      for (var did in json.decode(didList).keys.toList()) {
        //var didVC = storage.read(key: did) as String;
        if (await storage.containsKey(key: did)) {
          await storage.delete(key: did);
        }
      }
      await storage.delete(key: "DIDList");
    }

    // await deleteCacheDir();
    // await deleteAppDir();

    Get.offAll(SelectJoin());
  }
}
