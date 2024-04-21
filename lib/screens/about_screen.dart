import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
        ),
        color: Color(0xFFEFF5FD),
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: DecoratedBox(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset("assets/Main.png", height: 70, width: 70),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24),
                      child: Text(
                        "AiT Mobile App",
                        style: GoogleFonts.lato(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101828),
                        ),
                      ),
                    ),
                    Text(
                      "Lorem ipsum dolor sit amet consectetur. Non ut pharetra elementum nec mauris sit malesuada velit. Elementum enim euismod vestibulum suspendisse ac porttitor aliquet. Vitae lobortis dignissim eu nisl. Molestie volutpat auctor sit diam sem mauris ut.",
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101828),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
