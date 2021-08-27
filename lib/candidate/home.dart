import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:wallet/view/did_list.dart';
import 'package:wallet/candidate/view/config.dart';
import 'package:wallet/candidate/view/scan_qr.dart';
import 'package:wallet/provider/global_variable.dart';
import 'package:wallet/util/logger.dart';

class Home extends StatelessWidget {
  Home({key, required this.tabController}) : super(key: key);
  final GlobalVariable g = Get.find();
  final log = Log();
  final PersistentTabController tabController;

  List<Widget> _buildScreens() {
    log.i("_buildScreens");
    return [
      DIDList(),
      ScanQR(),
      Config(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("myCertificate".tr),
        activeColorPrimary: Get.theme.accentColor,
        inactiveColorPrimary: Get.theme.disabledColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.qr_code_scanner),
        title: ("scanQr".tr),
        activeColorPrimary: Get.theme.accentColor,
        activeColorSecondary: Get.theme.bottomAppBarColor,
        inactiveColorPrimary: Get.theme.disabledColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("settings".tr),
        activeColorPrimary: Get.theme.accentColor,
        inactiveColorPrimary: Get.theme.disabledColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    log.i("home build");
    return PersistentTabView(
      context,
      controller: tabController,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Get.theme.bottomAppBarColor,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(15.0),
        colorBehindNavBar: Get.theme.bottomAppBarColor,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
    );
  }
}
