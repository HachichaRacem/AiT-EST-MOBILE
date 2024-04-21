import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateContactedDialog extends StatelessWidget {
  final Map values;

  final Color _activeTrackColor = const Color(0xFF34C759);

  const UpdateContactedDialog({super.key, required this.values});

  void _updateIsContactedValue(bool value) {
    values['contacted'].value = value;
  }

  void _updateIsInterestedValue(bool value) {
    values['interested'].value = value;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Text(
            "Fill with needed information",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF505050),
            ),
          ),
          const SizedBox(height: 12),
          const Divider()
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Contacted",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
              Obx(
                () => Switch(
                  value: values['contacted'].value,
                  onChanged: _updateIsContactedValue,
                  trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
                  activeTrackColor: _activeTrackColor,
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Interested",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
              Obx(
                () => Switch(
                  value: values['interested'].value,
                  onChanged: _updateIsInterestedValue,
                  trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
                  activeTrackColor: _activeTrackColor,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
