import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VCCardController extends GetxController with SingleGetTickerProviderMixin {
  AnimationController? animationController;
  Animation<Offset>? animationOffset;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));

    final curve = CurvedAnimation(parent: animationController!, curve: Curves.easeIn);

    animationOffset = Tween(begin: const Offset(0.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(curve); //..addListener(() => update());
  }
}
