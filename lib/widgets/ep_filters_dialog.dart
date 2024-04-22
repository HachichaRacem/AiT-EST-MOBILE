import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EpsFilterDialog extends GetView<EpsController> {
  const EpsFilterDialog({super.key});

  void _onConfirmClick() {
    controller.searchedEPs = [0];
    switch (controller.isContactedFilterOn.value) {
      case null:
        controller.isUserSearching = false;
        break;
      case true:
        controller.isUserSearching = true;
        for (final ExchangeParticipant ep in controller.allocatedEPsList.sublist(1)) {
          if (ep.isContacted.value) {
            controller.searchedEPs.add(ep);
          }
        }
        break;
      case false:
        controller.isUserSearching = true;
        for (final ExchangeParticipant ep in controller.allocatedEPsList.sublist(1)) {
          if (!ep.isContacted.value) {
            controller.searchedEPs.add(ep);
          }
        }
        break;
    }
    controller.update();
    Get.back(closeOverlays: true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Filter",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              onPressed: () => Get.back(closeOverlays: true),
              icon: const Icon(
                Icons.close_rounded,
              ),
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Obx(
                () => Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: controller.isContactedFilterOn.value == null
                      ? false
                      : controller.isContactedFilterOn.value == true,
                  shape: const CircleBorder(),
                  activeColor: const Color(0xFFFBA834),
                  side: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                  onChanged: (value) {
                    if (value == true) {
                      controller.isContactedFilterOn.value = true;
                    } else {
                      controller.isContactedFilterOn.value = null;
                    }
                  },
                ),
              ),
              Text(
                "Contacted",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              )
            ],
          ),
          Row(
            children: [
              Obx(
                () => Checkbox(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const CircleBorder(),
                  activeColor: const Color(0xFFFBA834),
                  side: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                  value: controller.isContactedFilterOn.value == null
                      ? false
                      : !controller.isContactedFilterOn.value!,
                  onChanged: (value) {
                    if (value == true) {
                      controller.isContactedFilterOn.value = false;
                    } else {
                      controller.isContactedFilterOn.value = null;
                    }
                  },
                ),
              ),
              Text(
                "Not Contacted",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF344054),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _onConfirmClick,
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
                child: Text(
                  "Confirm",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
