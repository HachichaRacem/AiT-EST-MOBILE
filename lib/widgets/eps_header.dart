import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EpsHeader extends GetView<EpsController> {
  final bool isManagementScreen;
  final Color _orangeColor = const Color(0xFFFBA834);
  const EpsHeader({super.key, required this.isManagementScreen});

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
                    SizedBox(
                      width: 30,
                      height: 28,
                      child: Obx(
                        () => IconButton(
                          onPressed:
                              controller.selectedEPsList.isEmpty ? null : () => Get.log("Person add pressed"),
                          icon: const Icon(
                            Icons.person_add_rounded,
                          ),
                          color: _orangeColor,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: SizedBox(
                        width: 26,
                        height: 26,
                        child: Obx(
                          () => IconButton(
                            onPressed:
                                controller.selectedEPsList.isEmpty ? null : () => Get.log("Remove pressed"),
                            icon: const Icon(
                              Icons.delete_forever_outlined,
                            ),
                            color: _orangeColor,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                  ]
                : [
                    Text(
                      "Add Filter",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _orangeColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.tune),
                          color: _orangeColor,
                          iconSize: 18,
                          onPressed: () {},
                        ),
                      ),
                    )
                  ],
          )
        ],
      ),
    );
  }
}
