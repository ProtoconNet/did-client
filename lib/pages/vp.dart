import 'package:flutter/material.dart';
// import 'package:get/get.dart';

import 'package:wallet/widgets/background.dart';
// import 'package:wallet/global/variable.dart';
// import 'package:google_fonts/google_fonts.dart';

class VP extends StatelessWidget {
  VP({key, required this.name}) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          title: Text(name),
        ),
        children: [Center(child: Image.asset("assets/images/driver_license.png"))]);
  }
}
