import 'dart:async';

import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EpsController extends GetxController {
  // State managment
  final RxInt currentState = RxInt(0); // 0 - loading, 1 - error, 2 - success
  final RxList allocatedEPsList = RxList([]);
  final RxList selectedEPsList = RxList([]);

  List departmentEPs = [0];

  final ScrollController verticalController = ScrollController();

  @override
  void onReady() async {
    try {
      currentState.value = 0;
      await _fetchAllocatedEPs();
      currentState.value = 2;
    } catch (e) {
      Get.log("[EPs Controller]: $e");
      currentState.value = 1;
    }
    super.onReady();
  }

  Future<void> _fetchAllocatedEPs() async {
    final String currentLC = MainController.user!.lcName!;
    final String department = MainController.user!.department!.toLowerCase();
    final String firstName = MainController.user!.firstName!;

    List allocatedEPs = [0];

    // UPDATE IP ADD WITH ipconfig
    final response = await MainController.dio.get("http://192.168.1.11:3000/lc_leads/$currentLC");
    for (final Map<String, dynamic> ep in response.data) {
      final String epDepartment = (ep['Allocate the departement'] as String).toLowerCase();
      final String epManager = ep['Member Name'];
      if (epManager == firstName) {
        // Later add condition to verify department if its the same
        allocatedEPs.add(ep);
      }
      if (epDepartment == department) {
        departmentEPs.add(ep);
      }
    }
    Get.log("${departmentEPs.length}");
    allocatedEPsList.value = allocatedEPs;
  }

  void onEpsHeaderCheckboxClick(bool? value) {
    if (selectedEPsList.length >= departmentEPs.length - 1) {
      selectedEPsList.clear();
    } else {
      for (int i = 1; i < departmentEPs.length; i++) {
        selectedEPsList.addIf(!selectedEPsList.contains(i), i);
      }
    }
  }

  void onEpTileSelect(bool value, int index) {
    if (value) {
      selectedEPsList.add(index);
    } else {
      selectedEPsList.removeWhere((element) => element == index);
    }
  }
}
