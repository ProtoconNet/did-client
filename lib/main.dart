import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:camera/camera.dart';

import 'package:wallet/config/translations.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/config/theme.dart';
import 'package:wallet/wallet_route.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await initService();
  runApp(WigglerWallet());
}

initService() async {
  const environment = String.fromEnvironment("environment", defaultValue: "production");
  if (environment == "production") {
    await dotenv.load(fileName: "production.env");
  } else if (environment == "development") {
    await dotenv.load(fileName: "development.env");
  } else {
    await dotenv.load(fileName: "default.env");
  }
  Logger.level = Level.info;

  await GetStorage.init();

  Get.put(GlobalVariable(), permanent: true);
}

class WigglerWallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wiggler Wallet',
      theme: theme,
      darkTheme: theme, // darkTheme,
      themeMode: GlobalVariable().themeMode(GlobalVariable().theme),
      translations: Messages(),
      locale: GlobalVariable().languageMode(GlobalVariable().language),
      fallbackLocale: Locale('en', 'US'),
      home: WalletRoute(),
      // initialRoute: '/',
      // getPages: [GetPage(name: '/', page: () => WalletRoute())],
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (BuildContext context) => Scaffold(body: Center(child: Text('Not Found'))),
        );
      },
    );
  }
}
