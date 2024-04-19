import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EpProfilePhone extends StatelessWidget {
  final String epPhoneNumber;
  const EpProfilePhone({super.key, required this.epPhoneNumber});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: epPhoneNumber.isEmpty
            ? null
            : () async {
                try {
                  await launchUrl(Uri(scheme: 'tel', path: epPhoneNumber));
                } catch (e) {
                  Get.log("Phone exception : $e");
                }
              },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFD0D5DD),
              ),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  color: Color(0x1018280D),
                )
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle,
                  size: 8, color: epPhoneNumber.isEmpty ? Colors.grey : Colors.green),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(
                    epPhoneNumber.isNotEmpty ? epPhoneNumber : "Not provided",
                    style: GoogleFonts.inter(
                        color: const Color(0xFF344054), fontWeight: FontWeight.w500, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
