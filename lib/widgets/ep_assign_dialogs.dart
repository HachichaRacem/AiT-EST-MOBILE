import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../controllers/eps_controller.dart';

class AssignToDialog extends StatelessWidget {
  final RxString _selectedMember = RxString("");

  // 0 - confirmNormal, 1 - confirmLoading, 2 - confirmSuccess
  // 3 - clearNormal, 4 - clearLoading, 5 - clearSuccess
  final RxInt _currentState = RxInt(0);

  final RxString _errorMessage = RxString("");
  AssignToDialog({super.key});

  Future<void> _onButtonsClick(BuildContext context, {bool clear = false}) async {
    if (_selectedMember.isEmpty && !clear) {
      _errorMessage.value = "Select a member first";
    } else {
      _currentState.value = clear ? 4 : 1;
      final EpsController epController = Get.find();
      final baseURL = "/updateEPManager/${MainController.user?.lcName}";
      List<Future> requestsToSend = [];
      for (final epID in epController.selectedEPsList) {
        final ExchangeParticipant selectedEP = epController.departmentEPs
            .sublist(1)
            .singleWhere((element) => (element as ExchangeParticipant).id == epID);
        if (selectedEP.expaEPID != -1) {
          requestsToSend.add(
            MainController.dio.put("$baseURL/${selectedEP.expaEPID}", queryParameters: {
              "newValue": !clear ? _selectedMember.substring(0, 6).trim() : ""
            }),
          );
        } else {
          toastification.show(
            context: context,
            title: const Text("Warning"),
            description: Text("Could not update ${selectedEP.fullName} due to missing ID."),
            type: ToastificationType.warning,
            style: ToastificationStyle.minimal,
            autoCloseDuration: const Duration(seconds: 5),
            closeOnClick: true,
          );
          _currentState.value = clear ? 3 : 0;
          return;
        }
      }
      // VERIFY BACKEND
      try {
        final responses = await Future.wait(requestsToSend);
        for (final response in responses) {
          Get.log("${response.data}");
        }
        _currentState.value = clear ? 5 : 2;
        await epController.onReady();
      } catch (e) {
        Get.log("$e");
        _currentState.value = clear ? 3 : 0;
      } finally {
        epController.selectedEPsList.clear();
        Get.back(closeOverlays: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(
              "Assign EP manager",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF101828),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
                onPressed: () => Get.back(closeOverlays: true),
                icon: const Icon(Icons.close_rounded),
                padding: EdgeInsets.zero),
          )
        ],
      ),
      content: SizedBox(
        height: 185,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                "Team member",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFD0D5DD)),
                  ),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child:
                            Icon(Icons.person_outline_rounded, size: 20, color: Color(0xFF667085)),
                      ),
                      Obx(
                        () => DropdownButton(
                          menuMaxHeight: 180,
                          isDense: true,
                          padding: const EdgeInsets.all(6.0),
                          underline: const SizedBox(),
                          icon: Transform.rotate(
                            angle: 180.61,
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 13,
                            ),
                          ),
                          hint: Text(
                            "Select member",
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          value: _selectedMember.value.isEmpty ? null : _selectedMember.value,
                          items: List.generate(
                            MainController.user!.deptMembers.length,
                            (index) {
                              return DropdownMenuItem(
                                value: MainController.user!.deptMembers[index]['fullName']!,
                                child: Text(
                                  MainController.user!.deptMembers[index]['fullName']!,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF101828),
                                  ),
                                ),
                              );
                            },
                          ),
                          onChanged: (value) {
                            _selectedMember.value = value!;
                            _errorMessage.value = "";
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => _errorMessage.isNotEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              _errorMessage.value,
                              style: GoogleFonts.lato(
                                  color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      : const SizedBox(),
                )
              ],
            ),
            const SizedBox(height: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => _onButtonsClick(context),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Color(0xFF34C759)),
                      foregroundColor: MaterialStatePropertyAll(Colors.white),
                      overlayColor: MaterialStatePropertyAll(Colors.white24),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    child: Obx(
                      () => _currentState.value == 2
                          ? const Icon(Icons.check_rounded)
                          : _currentState.value == 1
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 1.5, color: Colors.white),
                                )
                              : Text(
                                  "Confirm",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _onButtonsClick(context, clear: true),
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      foregroundColor: MaterialStatePropertyAll(Colors.black),
                      side: MaterialStatePropertyAll(BorderSide(color: Color(0xFFD0D5DD))),
                      surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                      overlayColor: MaterialStatePropertyAll(Colors.black12),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    child: Obx(
                      () => _currentState.value == 5
                          ? const Icon(Icons.check_rounded)
                          : _currentState.value == 4
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  "Clear",
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
