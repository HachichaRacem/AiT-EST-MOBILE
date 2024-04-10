import 'package:aiesec_im/controllers/crm_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CRMScreen extends GetView<CRMController> {
  const CRMScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("CRM screen")),
    );
  }
}
