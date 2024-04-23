import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DebugDialog extends StatelessWidget {
  final TextEditingController _ipInputController = TextEditingController();
  final RxString _errorMessage = RxString("");
  DebugDialog({super.key});

  void _onConfirmClick() {
    if (_ipInputController.text.isEmpty) {
      _errorMessage.value = "Field is required";
    } else {
      if (_ipInputController.text.contains(":")) {
        final splitedInput = _ipInputController.text.split(":");
        if (splitedInput[0].isIPv4) {
          if (splitedInput[1].isNumericOnly) {
            Get.log("DIO base URL before change : ${MainController.dio.options.baseUrl}");
            MainController.dio.options.baseUrl = "http://${_ipInputController.text}";
            Get.log("DIO base URL after change : ${MainController.dio.options.baseUrl}");
            Get.back();
          } else {
            _errorMessage.value = "Invalid port. Should be numeric only";
          }
        } else {
          _errorMessage.value = "Invalid IP. Verify your input";
        }
      } else {
        _errorMessage.value = "Invalid format: [IP:PORT]";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          "Endpoint",
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF101828),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Run the server on your machine\nHead to the command line\nUse the CMD \"ipconfig\"\nEnter the IPv4 address in the field\nEnter the used port in the server console\nExample: 000.00.00.0:1111",
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ),
            Obx(
              () => TextField(
                controller: _ipInputController,
                onChanged: (value) => _errorMessage.value = "",
                decoration: InputDecoration(
                  isDense: true,
                  errorText: _errorMessage.isNotEmpty ? _errorMessage.value : null,
                  contentPadding: const EdgeInsets.all(12.0),
                  hintText: "Format : IP:PORT",
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: _onConfirmClick,
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
