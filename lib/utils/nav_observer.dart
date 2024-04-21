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
      final controller = Get.find<HomeController>();
      if (route.settings.name == "/leadsManagement") {
        Get.engine.addPostFrameCallback((timeStamp) {
          controller.appBarType.value = 1;
          controller.appBarType.refresh();
          controller.appBarFadeCtrl.forward(from: 0);
        });
      } else if (route.settings.name == "/epProfile") {
        controller.appBarType.value = 2;
        controller.appBarType.refresh();
        controller.appBarFadeCtrl.forward(from: 0);
      } else if (route.settings.name == "/about") {
        controller.appBarType.value = 3;
        controller.appBarType.refresh();
        controller.appBarFadeCtrl.forward(from: 0);
      }
      Get.log("[$_tag]: Pushed ${route.settings.name} -> $history");
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      Get.log("[$_tag]: Popped ${route.settings.name} -> $history");
      history.removeLast();
      final controller = Get.find<HomeController>();
      if (previousRoute?.settings.name == "/") {
        controller.appBarType.value = 1;
        controller.appBarType.refresh();
        controller.appBarFadeCtrl.forward(from: 0);
      } else if (previousRoute?.settings.name == "/leadsManagement") {
        controller.appBarType.value = 1;
        controller.appBarType.refresh();
        controller.appBarFadeCtrl.forward(from: 0);
      } else if (previousRoute?.settings.name == "/about") {
        controller.appBarType.value = 3;
        controller.appBarType.refresh();
        controller.appBarFadeCtrl.forward(from: 0);
      }
      if (route.settings.name == "/leadsManagement") {
        Get.find<EpsController>().reset();
      }
      // If we are going back to EPs Screen ('/') and some changes have happened, we need to update it
      if (previousRoute?.settings.name == '/') {
        final epController = Get.find<EpsController>();
        if (epController.epsScreenNeedsUpdate) {
          epController.onReady();
        }
      }
    }
    super.didPop(route, previousRoute);
  }
}
