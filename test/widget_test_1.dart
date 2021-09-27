import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_driver/flutter_driver.dart' as fd;
// import 'package:flutter_driver/driver_extension.dart';
import 'package:get_storage/src/storage_impl.dart';
import 'package:get_storage/src/read_write_value.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/view/create_wallet.dart';
import 'package:wallet/util/logger.dart';
// import 'package:wallet/widget/gradient_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // late fd.FlutterDriver driver;

  // enableFlutterDriverExtension();

  final log = Log();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  void setUpMockChannels(MethodChannel channel) {
    TestWidgetsFlutterBinding.ensureInitialized();
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return '.';
      }
    });
  }

  setUpAll(() async {
    setUpMockChannels(channel);
    // driver = await fd.FlutterDriver.connect();
    await initService();
  });

  tearDownAll(() async {
    // driver.close();
  });

  setUp(() async {
    log.i('a');
    log.i('b');
  });

  testWidgets('MyWidget has a title and message', (WidgetTester tester) async {
    log.i('c');
    await tester.pumpWidget(GetMaterialApp(home: Scaffold(body: CreateWallet())));
    // final buttonFinder = find.byType(GradientButton);
    // expect(buttonFinder, findsOneWidget);

    final textFinder = find.byType(Text);
    expect(textFinder, findsWidgets);
  });
}

initService() async {
  final log = Log();
  log.i("c");
  await dotenv.load(fileName: "test.env");

  Logger.level = Level.info;
  log.i("d");

  await GetStorage.init();
  log.i("e");

  var g = Get.put(GlobalVariable(), permanent: true);
  log.i("f");
}
