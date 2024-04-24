import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class McHeadsUpDialog extends StatelessWidget {
  const McHeadsUpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          "Information",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF101828),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hello dear ${MainController.user?.firstName}, this application does not yet fully support MC accounts, especially the ones that are not OGX related.\n\nHowever, you were assigned to the department ${MainController.user?.department} and randomly to the LC ${MainController.user?.lcName}",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey[700],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
