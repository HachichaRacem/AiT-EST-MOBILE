import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EpTile extends GetView<EpsController> {
  final int index;
  final bool selectable;
  const EpTile(this.index, this.selectable, {super.key});

  void _onArrowClick() {
    Get.nestedKey(1)!.currentState?.pushNamed('/epProfile',
        arguments: controller.allocatedEPsList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Obx(
        () => Checkbox(
          value: controller.selectedEPsList.contains(index),
          onChanged: (value) => controller.onEpTileSelect(value!, index),
        ),
      ),
      title: Text(controller.allocatedEPsList[index]['Full Name']),
      trailing: IconButton(
        onPressed: _onArrowClick,
        icon: const Icon(Icons.arrow_right_rounded),
      ),
    );
  }
}
