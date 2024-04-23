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
      final homeController = Get.find<HomeController>();
      if (route.settings.name == "/leadsManagement") {
        Get.find<EpsController>().reset();
        homeController.appBarType.value = 1;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (route.settings.name == "/crm") {
        homeController.appBarType.value = 1;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (route.settings.name == "/epProfile") {
        homeController.appBarType.value = 2;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (route.settings.name == "/about") {
        homeController.appBarType.value = 3;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      }
      Get.log("[$_tag]: Pushed ${route.settings.name} -> $history");
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      history.removeLast();
      final homeController = Get.find<HomeController>();
      if (previousRoute?.settings.name == "/crm") {
        homeController.appBarType.value = 1;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (previousRoute?.settings.name == "/") {
        homeController.appBarType.value = 0;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (previousRoute?.settings.name == "/leadsManagement") {
        homeController.appBarType.value = 1;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      } else if (previousRoute?.settings.name == "/about") {
        homeController.appBarType.value = 3;
        homeController.appBarType.refresh();
        homeController.appBarFadeCtrl.forward(from: 0);
      }
      if (route.settings.name == "/leadsManagement") {
        Get.find<EpsController>().reset();
      }
    }
    Get.log("[$_tag]: Popped ${route.settings.name} -> $history");
    super.didPop(route, previousRoute);
  }
}
