import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

import '../controllers/eps_controller.dart';

class AssignToDialog extends StatelessWidget {
  const AssignToDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Assign to",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFBA834),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 25,
            indent: 25,
            color: Color(0xFFE2E8F0),
          )
        ],
      ),
      content: SizedBox(
        height: 250,
        child: Scrollbar(
          radius: const Radius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(MainController.user!.deptMembers.length, (index) {
                final memberName = MainController.user!.deptMembers[index]['fullName']!;
                return SizedBox(
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      Get.dialog(
                        AssignConfirmDialog(
                          selectedMember: memberName,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      memberName,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF101828),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignConfirmDialog extends StatelessWidget {
  final String selectedMember;
  final RxInt _currentState = RxInt(0); // 0 - static, 1 - loading, 2 - error
  AssignConfirmDialog({super.key, required this.selectedMember});

  Future<void> _onConfirmClick(BuildContext context) async {
    _currentState.value = 1;
    final EpsController epController = Get.find();
    const baseURL = "http://192.168.1.11:3000/updateMemberName";
    List<Future> requestsToSend = [];
    for (final epID in epController.selectedEPsList) {
      final ExchangeParticipant selectedEP = epController.departmentEPs
          .sublist(1)
          .singleWhere((element) => (element as ExchangeParticipant).id == epID);
      if (selectedEP.expaEPID != -1) {
        Get.log("Updating : ${selectedEP.fullName}");
        Get.log("URL : $baseURL/${selectedEP.expaEPID}");
        requestsToSend.add(MainController.dio.put("$baseURL/${selectedEP.expaEPID}",
            data: {"newMemberName": selectedMember.substring(0, 6)}));
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
      }
    }
    // VERIFY BACKEND
    /*try {
      final responses = await Future.wait(requestsToSend);
      for (final response in responses) {
        Get.log("${response.data}");
        _currentState.value = 0;
      }
    } catch (e) {
      Get.log("$e");
      _currentState.value = 2;
    }*/
    _currentState.value = 0;
    epController.epsScreenNeedsUpdate = true;
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Assigned to",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF32D583),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 25,
            indent: 25,
            color: Color(0xFFE2E8F0),
          )
        ],
      ),
      content: Text(
        selectedMember,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(),
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
            foregroundColor: const MaterialStatePropertyAll(
              Color(0xFFE70013),
            ),
            overlayColor: const MaterialStatePropertyAll(Color.fromARGB(20, 244, 67, 54)),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(
                  color: Color(0xFFE70013),
                ),
              ),
            ),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () => _onConfirmClick(context),
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF32D583)),
            surfaceTintColor: const MaterialStatePropertyAll(Color(0xFF32D583)),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            overlayColor: const MaterialStatePropertyAll(Colors.white12),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Obx(
              () {
                switch (_currentState.value) {
                  case 0:
                    return const Icon(Icons.check);
                  case 1:
                    return const SizedBox(
                        height: 12,
                        width: 12,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5));
                  case 2:
                    return const Icon(Icons.error);
                  default:
                    return const Icon(Icons.check);
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
