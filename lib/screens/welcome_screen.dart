import 'package:aiesec_im/controllers/welcome_controller.dart';
import 'package:aiesec_im/widgets/stats_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends GetView<WelcomeController> {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 26.0, bottom: 12.0),
                child: Text(
                  "${controller.months[DateTime.now().month - 1]}'s Performance",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsPlaceholder(index: '1'),
                StatsPlaceholder(index: '2')
              ],
            ),
          ],
        ),
        const SizedBox(height: 50),
        Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 26.0, bottom: 12.0),
                child: Text(
                  "Term Performance",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatsPlaceholder(index: '3'),
                StatsPlaceholder(index: '4')
              ],
            ),
          ],
        ),
      ],
    );
  }
}
