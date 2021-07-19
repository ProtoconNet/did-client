import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:wallet/providers/global_variable.dart';
import 'package:wallet/widgets/background.dart';
import 'package:wallet/controller/create_wallet_controller.dart';
import 'package:wallet/pages/create_did.dart';
import 'package:wallet/utils/logger.dart';

class CreateWallet extends StatelessWidget {
  final CreateWalletController c = Get.put(CreateWalletController());
  final GlobalVariable g = Get.put(GlobalVariable());
  final log = Log();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log.i('CreateAccountPage');
    final node = FocusScope.of(context);
    return Background(
      child: Form(
        key: c.formKey.value,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('createWallet'.tr, style: Get.theme.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold)),
          Text('inputPasswordMsg'.tr),
          TextFormField(
              autofocus: true,
              controller: pass,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Input password', labelText: 'Password'),
              validator: (value) {
                if (value != confirmPass.text) return ' ';
                return null;
              },
              onChanged: (value) {
                c.setStatus(value.isNotEmpty && pass.text == confirmPass.text);
              },
              onEditingComplete: () => node.nextFocus()),
          TextFormField(
              controller: confirmPass,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(hintText: 'Confirm password', labelText: 'Confirm'),
              validator: (value) {
                if (value != pass.text) return 'Error: Password and confirm password have to same';
                return null;
              },
              onChanged: (value) {
                c.formKey.value.currentState!.validate();
                c.setStatus(value.isNotEmpty && pass.text == confirmPass.text);
              },
              onEditingComplete: () => node.nextFocus(),
              onFieldSubmitted: (test) async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
              }),
          Obx(() => ElevatedButton(
              onPressed: c.status.value
                  ? () async {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => CreateDID(password: confirmPass.text)));
                    }
                  : null,
              child: c.status.value ? Text('submit'.tr) : Text('check password')))
        ]),
      ),
    );
  }
}
