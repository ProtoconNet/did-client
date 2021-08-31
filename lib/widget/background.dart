import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Background extends StatelessWidget {
  Background(
      {key,
      this.appBar,
      required this.children,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center})
      : super(key: key);

  final AppBar? appBar;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        body: SafeArea(
            child: Container(
                decoration: BoxDecoration(color: Get.theme.canvasColor),
                child: Column(
                    mainAxisAlignment: mainAxisAlignment,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [...children, SizedBox(width: Get.width, height: 0)]))));
  }
}
