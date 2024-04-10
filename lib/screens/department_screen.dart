import 'package:aiesec_im/controllers/department_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DepartmentScreen extends GetView<DepartmentController> {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Department screen")),
    );
  }
}
