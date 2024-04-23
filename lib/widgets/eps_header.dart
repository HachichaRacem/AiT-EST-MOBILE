import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/widgets/ep_assign_dialogs.dart';
import 'package:aiesec_im/widgets/ep_filter_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EpsHeader extends GetView<EpsController> {
  final bool isManagementScreen;
  final Color _orangeColor = const Color(0xFFFBA834);
  const EpsHeader({super.key, required this.isManagementScreen});

  void _onAllocatedFilterClick() {
    if (controller.isAllocatedFilterOn.value == null) {
      Get.dialog<bool>(const AllocatedFilterDialog()).then((value) {
        if (value == null) {
          controller.isAllocatedFilterOn.value = null;
          controller.searchedEPs = [0];
          controller.isUserSearching = false;
          controller.update();
        }
      });
    } else {
      controller.isAllocatedFilterOn.value = null;
      controller.searchedEPs = [0];
      controller.isUserSearching = false;
      controller.update();
    }
  }

  void _onContactedFilterClick() {
    if (controller.isContactedFilterOn.value == null) {
      Get.dialog<bool>(const ContactedFilterDialog()).then((value) {
        if (value == null) {
          controller.isContactedFilterOn.value = null;
          controller.searchedEPs = [0];
          controller.isUserSearching = false;
          controller.update();
        }
      });
    } else {
      controller.isContactedFilterOn.value = null;
      controller.searchedEPs = [0];
      controller.isUserSearching = false;
      controller.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFE5DFD6)),
                color: const Color(0xFFFFFDFB)),
            child: Obx(
              () {
                final chipText = isManagementScreen
                    ? controller.selectedEPsList.isNotEmpty
                        ? "${controller.selectedEPsList.length} selected out of ${controller.departmentEPs.length - 1}"
                        : "${controller.departmentEPs.length - 1} in total"
                    : "${controller.allocatedEPsList.length - 1} in total";
                return Text(
                  chipText,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _orangeColor,
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: isManagementScreen
                ? [
                    Obx(
                      () => _FilterButton(
                        color: _orangeColor,
                        isFilterOn: controller.isAllocatedFilterOn.value != null,
                        onTap: _onAllocatedFilterClick,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 28,
                      child: Obx(
                        () => IconButton(
                          iconSize: 20,
                          onPressed: controller.selectedEPsList.isEmpty
                              ? null
                              : () {
                                  Get.dialog(AssignToDialog());
                                },
                          icon: const Icon(
                            Icons.person_add_rounded,
                          ),
                          color: _orangeColor,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ]
                : [
                    Obx(
                      () => _FilterButton(
                        isFilterOn: controller.isContactedFilterOn.value != null,
                        color: _orangeColor,
                        onTap: _onContactedFilterClick,
                      ),
                    )
                  ],
          )
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isFilterOn;
  final Function()? onTap;
  final Color color;
  const _FilterButton({required this.isFilterOn, this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          isFilterOn ? "Filter on" : "Add Filter",
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        SizedBox(
          height: 28,
          width: 30,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Icon(isFilterOn ? Icons.close_rounded : Icons.tune),
            color: isFilterOn ? const Color(0xFF667085) : color,
            iconSize: 18,
            onPressed: onTap,
          ),
        ),
      ],
    );
  }
}
