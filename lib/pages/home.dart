import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'package:wallet/pages/did_list.dart';
import 'package:wallet/pages/config.dart';
import 'package:wallet/pages/scan_qr.dart';
import 'package:wallet/providers/global_variable.dart';

class Home extends StatelessWidget {
  Home({key, required this.tabController}) : super(key: key);
  final g = Get.put(GlobalVariable());
  final PersistentTabController tabController;

  List<Widget> _buildScreens() {
    g.log.i("_buildScreens");
    return [
//      VCList(),
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
    g.log.i("home build");
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
        borderRadius: BorderRadius.circular(10.0),
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
