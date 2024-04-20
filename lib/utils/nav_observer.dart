import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyObserver extends NavigatorObserver {
  static List history = [];
  static const String _tag = "Navigation";

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      history.add(route.settings.name!);
      if (route.settings.name == "/leadsManagement") {
        Get.engine.addPostFrameCallback((timeStamp) {
          final controller = Get.find<HomeController>();
          controller.appBarType.value = 1;
          controller.appBarType.refresh();
          controller.appBarFadeCtrl.forward(from: 0);
        });
      }
      Get.log("[$_tag]: Pushed ${route.settings.name}");
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      Get.log("[$_tag]: Popped ${route.settings.name}");
      history.removeLast();
      if (previousRoute?.settings.name == "/") {
        Get.engine.addPostFrameCallback((timeStamp) {
          final controller = Get.find<HomeController>();
          controller.appBarType.value = 0;
          controller.appBarType.refresh();
          controller.appBarFadeCtrl.forward(from: 0);
        });
      }
      // If we are going back to EPs Screen ('/') and some changes have happened, we need to update it
      if (history[0] == '/') {
        final epController = Get.find<EpsController>();
        if (epController.epsScreenNeedsUpdate) {
          epController.onReady();
        }
      }
    }
    super.didPop(route, previousRoute);
  }
}
