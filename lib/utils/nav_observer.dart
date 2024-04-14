import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyObserver extends NavigatorObserver {
  static List<String> history = [];

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      history.add(route.settings.name!);
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (route.settings.name != null) {
      history.removeLast();
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
