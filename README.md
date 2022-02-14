# wallet

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

##### build command
```
// android appbundle
flutter build appbundle —no-tree-shake-icons
// ios ipa
flutter build ipa —no-tree-shake-icons
```

##### mitum node config
```
// root의 default.env 수정
GET_DID_DOCUMENT="http://49.50.164.195:8080/v1/DIDDocument?did="
REGISTER_DID_DOCUMENT="http://49.50.164.195:8080/v1/DIDDocument"
```

##### Issuer config
```
// root의 default.env 수정
STATIC_VC_LIST=[{"name": "Driver's License", "icon": 57815, "schemaRequest": "http://mtm.securekim.com:3333/VCScheme?scheme=driverLicense", "requestVC":"", "getVC":"", "JWT": "", "VC": {}},{"name": "Protocon Pass", "icon": 59004, "schemaRequest": "http://mtm.securekim.com:3333/VCScheme?scheme=JejuPass", "requestVC":"", "getVC":"", "JWT": "", "VC": {}}]
```

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
