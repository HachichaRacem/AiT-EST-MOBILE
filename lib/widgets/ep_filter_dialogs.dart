import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactedFilterDialog extends GetView<EpsController> {
  const ContactedFilterDialog({super.key});

  void _onConfirmClick() {
    Get.back(result: true);
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

class AllocatedFilterDialog extends GetView<EpsController> {
  const AllocatedFilterDialog({super.key});

  void _onConfirmClick() {
    Get.back(result: true);
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
                  value: controller.isAllocatedFilterOn.value == null
                      ? false
                      : controller.isAllocatedFilterOn.value == true,
                  shape: const CircleBorder(),
                  activeColor: const Color(0xFFFBA834),
                  side: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                  onChanged: (value) {
                    if (value == true) {
                      controller.isAllocatedFilterOn.value = true;
                    } else {
                      controller.isAllocatedFilterOn.value = null;
                    }
                  },
                ),
              ),
              Text(
                "Allocated EPs",
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
                  value: controller.isAllocatedFilterOn.value == null
                      ? false
                      : !controller.isAllocatedFilterOn.value!,
                  onChanged: (value) {
                    if (value == true) {
                      controller.isAllocatedFilterOn.value = false;
                    } else {
                      controller.isAllocatedFilterOn.value = null;
                    }
                  },
                ),
              ),
              Text(
                "Non-Allocated EPs",
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
