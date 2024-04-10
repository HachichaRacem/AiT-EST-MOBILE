import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:aiesec_im/widgets/eps_header.dart';
import 'package:aiesec_im/widgets/eps_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadsManagementScreen extends GetView<EpsController> {
  const LeadsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          EpsHeader(isManagementScreen: true),
          Expanded(
            child: EpsTable(isManagementScreen: true),
          ),
        ],
      ),
    );
  }
}
