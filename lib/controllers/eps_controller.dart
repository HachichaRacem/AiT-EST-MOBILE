import 'dart:async';

import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:aiesec_im/utils/nav_observer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EpsController extends GetxController {
  // State managment and other parameters.
  final RxInt currentState = RxInt(0); // 0 - loading, 1 - error, 2 - success
  final RxList allocatedEPsList = RxList([]);
  final RxList selectedEPsList = RxList([]); // contains ep.id of selected EPs

  // null - filters OFF, true - filters on : first value, false - filters on : second value
  final Rx<bool?> isContactedFilterOn = Rx(null);
  final Rx<bool?> isAllocatedFilterOn = Rx(null);

  final TextEditingController appBarSearchCtrl = TextEditingController();

  bool isUserSearching = false;
  bool isDataFiltered = false;

  List filteredEPs = [0];
  List searchedEPs = [0];
  List departmentEPs = [0];

  @override
  void onInit() {
    isContactedFilterOn.listen((p0) {
      filteredEPs = [0];
      switch (p0) {
        case null:
          isDataFiltered = false;
          break;
        case true:
          isDataFiltered = true;
          for (final ExchangeParticipant ep
              in isUserSearching ? searchedEPs.sublist(1) : allocatedEPsList.sublist(1)) {
            if (ep.isContacted.value) {
              filteredEPs.add(ep);
            }
          }

          break;
        case false:
          isDataFiltered = true;
          for (final ExchangeParticipant ep
              in isUserSearching ? searchedEPs.sublist(1) : allocatedEPsList.sublist(1)) {
            if (!ep.isContacted.value) {
              filteredEPs.add(ep);
            }
          }
          break;
      }
      update();
    });
    isAllocatedFilterOn.listen((p0) {
      filteredEPs = [0];
      switch (p0) {
        case null:
          isDataFiltered = false;
          break;
        case true:
          isDataFiltered = true;
          for (final ExchangeParticipant ep
              in isUserSearching ? searchedEPs.sublist(1) : departmentEPs.sublist(1)) {
            if (ep.memberName != "None") {
              filteredEPs.add(ep);
            }
          }
          break;
        case false:
          isDataFiltered = true;
          for (final ExchangeParticipant ep
              in isUserSearching ? searchedEPs.sublist(1) : departmentEPs.sublist(1)) {
            if (ep.memberName == "None") {
              filteredEPs.add(ep);
            }
          }
          break;
      }
      update();
    });
    super.onInit();
  }

// Called once the screen is building
  @override
  Future<void> onReady() async {
    try {
      currentState.value = 0;
      await _fetchAllocatedEPs();
      currentState.value = 2;
    } catch (e, stack) {
      Get.log("[EPs Controller]: $e\n$stack");

      currentState.value = 1;
    }
    super.onReady();
  }

  /// Fetches all the EPs in [User]'s department into [departmentEPs]
  /// then filters the ones allocated to [User] into [allocatedEPsList] with the help of [allocatedEPs]
  Future<void> _fetchAllocatedEPs() async {
    final String currentLC = MainController.user!.lcName!;
    final String department = MainController.user!.department!;
    final String fullName = MainController.user!.fullName!;

    List allocatedEPs = [0];

    final response = await MainController.dio.get("/lc_leads/$currentLC");

    // Reset in case of an update rather than a first call
    if (departmentEPs.length != 1) {
      departmentEPs = [0];
    }
    int id = 0;
    for (final Map<String, dynamic> epData in response.data) {
      final ExchangeParticipant ep = ExchangeParticipant.fromJson(epData, id);
      if (ep.memberName.toLowerCase() == fullName.toLowerCase()) {
        // Later add condition to verify department if its the same
        allocatedEPs.add(ep);
      }
      if (ep.allocatedDepartment.toLowerCase() == department.toLowerCase()) {
        departmentEPs.add(ep);
      }
      id++;
    }
    allocatedEPsList.value = allocatedEPs;
  }

  // Click handlers
  void onEpsHeaderCheckboxClick(bool? value) {
    if (selectedEPsList.length >= departmentEPs.length - 1) {
      selectedEPsList.clear();
    } else {
      for (int i = 1; i < departmentEPs.length; i++) {
        final ExchangeParticipant ep = departmentEPs[i];
        selectedEPsList.addIf(!selectedEPsList.contains(ep.id), ep.id);
      }
    }
  }

  void onEpTileSelect(bool value, int id) {
    if (value) {
      selectedEPsList.add(id);
    } else {
      selectedEPsList.removeWhere((element) => element == id);
    }
  }

  void reset() {
    isUserSearching = false;
    isDataFiltered = false;
    isAllocatedFilterOn.value = null;
    isContactedFilterOn.value = null;
    filteredEPs = [0];
    searchedEPs = [0];
    selectedEPsList.clear();
    appBarSearchCtrl.clear();
    update();
  }

  void onSearchBarTextChange(String value) {
    searchedEPs = [0];
    if (value.isNotEmpty) {
      isUserSearching = true;
      if (MyObserver.history.last == "/crm") {
        for (final ExchangeParticipant ep
            in isDataFiltered ? filteredEPs.sublist(1) : allocatedEPsList.sublist(1)) {
          if (ep.fullName.toLowerCase().contains(value.toLowerCase())) {
            searchedEPs.add(ep);
          }
        }
      } else if (MyObserver.history.last == "/leadsManagement") {
        for (final ExchangeParticipant ep
            in isDataFiltered ? filteredEPs.sublist(1) : departmentEPs.sublist(1)) {
          if (ep.fullName.toLowerCase().contains(value.toLowerCase())) {
            searchedEPs.add(ep);
          }
        }
      }
    } else {
      isUserSearching = false;
    }
    update();
  }
}
