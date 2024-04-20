import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/widgets/eps_header.dart';
import 'package:aiesec_im/widgets/eps_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EpsScreen extends GetView<EpsController> {
  const EpsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.currentState.value == 0
          ? const Center(child: CircularProgressIndicator(strokeWidth: 1.5))
          : controller.currentState.value == 1
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Something went wrong",
                        style: GoogleFonts.inter(
                          color: Get.theme.colorScheme.error,
                        ),
                      ),
                      IconButton(
                        onPressed: controller.onReady,
                        icon: const Icon(Icons.refresh),
                        color: Get.theme.colorScheme.error,
                      )
                    ],
                  ),
                )
              : Column(
                  children: [
                    const EpsHeader(isManagementScreen: false),
                    Expanded(
                      child: EpsTable(isManagementScreen: false),
                    )
                  ],
                ),
    );
  }
}
