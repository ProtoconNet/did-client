import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:wallet/widgets/background.dart';
import 'package:confetti/confetti.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:wallet/pages/camera.dart';
import 'package:camera/camera.dart';
// import 'package:dart_ipify/dart_ipify.dart';
// import 'package:socket_io/socket_io.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:wallet/controller/config_controller.dart';

import 'package:wallet/providers/vp_test.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

// import 'package:wallet/pages/camera.dart';
import 'package:wallet/pages/text_detector_painter.dart';

class TextDetectorView extends StatefulWidget {
  @override
  _TextDetectorViewState createState() => _TextDetectorViewState();
}

class _TextDetectorViewState extends State<TextDetectorView> {
  TextDetector textDetector = GoogleMlKit.vision.textDetector();
  bool isBusy = false;
  CustomPaint? customPaint;

  @override
  void dispose() async {
    super.dispose();
    await textDetector.close();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Text Detector',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;
    final recognisedText = await textDetector.processImage(inputImage);
    print('Found ${recognisedText.blocks.length} textBlocks');
    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      for (var block in recognisedText.blocks) {
        print("language:${block.recognizedLanguages}");
        print("text:${block.text}");
        for (var line in block.lines) {
          print("line:${line.text}");
        }
      }
      final painter = TextDetectorPainter(
          recognisedText, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}

List<CameraDescription> cameras = [];

class Config extends StatelessWidget {
  final ConfigController c = Get.put(ConfigController());

  @override
  Widget build(BuildContext context) {
    return Background(children: [
      Center(
          child: ConfettiWidget(
        confettiController: c.controllerCenter.value,
        blastDirection: -pi / 2,
        maxBlastForce: 10, // set a lower max blast force
        minBlastForce: 8, // set a lower min blast force
        emissionFrequency: 0.1,
        numberOfParticles: 10, // a lot of particles at once
        gravity: 0.1,
      )),
      Center(
        child: Column(children: [
          //ElevatedButton(child: Text('json test'), onPressed: () => c.jsonldTest()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Theme '),
              Obx(() => DropdownButton(
                    value: c.theme.value,
                    onChanged: (newValue) {
                      c.setTheme(newValue);
                    },
                    items: <String>['system', 'light', 'dark'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Language '),
              Obx(() => DropdownButton(
                    value: c.language.value,
                    onChanged: (newValue) {
                      c.setLanguage(newValue);
                    },
                    items: <String>['system', 'korean', 'english'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
            ],
          ),
          ElevatedButton(child: Text('Erase All Data'), onPressed: () => c.eraseAll()),
          ElevatedButton(child: Text('VP Test'), onPressed: () => VPTest().testVP()),
          ElevatedButton(child: Text('confetti'), onPressed: () => c.controllerCenter.value.play()),
          // ElevatedButton(
          //     child: Text('getIP'),
          //     onPressed: () async {
          //       final ipv4 = await Ipify.ipv4();
          //       print(ipv4); // 98.207.254.136
          //     }),
          // ElevatedButton(
          //     child: Text('runServer'),
          //     onPressed: () async {
          //       var io = Server();
          //       var nsp = io.of('/some');
          //       nsp.on('connection', (client) {
          //         print('connection /some');
          //         client.on('msg', (data) {
          //           print('data from /some => $data');
          //           client.emit('fromServer', "ok 2");
          //         });
          //       });
          //       io.on('connection', (client) {
          //         print('connection default namespace');
          //         client.on('msg', (data) {
          //           print('data from default => $data');
          //           client.emit('fromServer', "ok");
          //         });
          //       });
          //       io.listen(3000);
          //     }),
          ElevatedButton(
              child: Text('Camera Test'),
              onPressed: () async {
                Get.to(TextDetectorView());
              }),
          ElevatedButton(
              child: Text('dialog'),
              onPressed: () {
                var test = AwesomeDialog(
                  context: context,
                  dialogType: DialogType.INFO_REVERSED,
                  borderSide: BorderSide(color: Colors.green, width: 2),
                  width: 280,
                  buttonsBorderRadius: BorderRadius.all(Radius.circular(2)),
                  headerAnimationLoop: false,
                  animType: AnimType.BOTTOMSLIDE,
                  title: 'INFO',
                  desc: 'Dialog description here...',
                  showCloseIcon: true,
                  btnCancelOnPress: () {
                    return false;
                  },
                  btnOkOnPress: () {
                    return true;
                  },
                ).show();
                print(test);
              }),
          ElevatedButton(
              child: Text('Local Auth'),
              onPressed: () async {
                var localAuth = LocalAuthentication();
                bool didAuthenticate =
                    await localAuth.authenticate(localizedReason: 'Please authenticate to show account balance');
                print(didAuthenticate);
              }),
          ElevatedButton(
              child: Text('Biometric Storage Test'),
              onPressed: () async {
                var _noConfirmation = await BiometricStorage().getStorage('customPrompt',
                    options: StorageFileInitOptions(authenticationValidityDurationSeconds: 30),
                    androidPromptInfo: const AndroidPromptInfo(
                      confirmationRequired: false,
                    ));
                _noConfirmation.write('ASDFASDFasdfasdf');
                var test = await _noConfirmation.read();

                c.setText(test);
                print("test:$test");
              }),
          Obx(() => Text(c.text.value)),
        ]),
      ),
    ]);
  }
}
