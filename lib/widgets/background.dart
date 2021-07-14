import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  Background({key, this.appBar, required this.child, this.mainAxisAlignment = MainAxisAlignment.center})
      : super(key: key);

  final AppBar? appBar;
  final Widget child;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(color: Get.theme.canvasColor),
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        mainAxisAlignment: mainAxisAlignment,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [child])))));
  }
}
