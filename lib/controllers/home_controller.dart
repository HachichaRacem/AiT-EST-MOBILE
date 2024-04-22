import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:aiesec_im/utils/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  // Current user throughout the application lifecycle.
  final User user = MainController.user!;

  // State Management variables
  final RxBool hasConfirmedExit = RxBool(false);

  late final AnimationController appBarFadeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 300,
    ),
  );
  late final Animation<double> appBarFadeAnim =
      CurvedAnimation(parent: appBarFadeCtrl, curve: Curves.easeIn);

  // Appbar related states management
  final RxInt appBarType = RxInt(0); // 0 - welcome, 1 - leads management, 2 - ep profile, 3 - about
  ExchangeParticipant? appBarSelectedEP;

  // Constants needed
  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  final tableColumns = ['Name', 'EP ID', 'Phone number'];

  @override
  void onInit() {
    // Helps with the application quit confirmation flow, resets the value to false if the user does not confirm the exit
    // once the popup is displayed which lasts for 5 seconds.
    hasConfirmedExit.listen((value) {
      if (value) {
        Future.delayed(const Duration(seconds: 5), () => hasConfirmedExit.value = false);
      }
    });
    Get.put(EpsController());
    super.onInit();
  }

  @override
  void onReady() {
    appBarFadeCtrl.forward();
    super.onReady();
  }
}
