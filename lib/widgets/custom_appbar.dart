import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final String firstName;
  const CustomAppBar(
      {super.key,
      required this.leading,
      required this.trailing,
      required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF387ADF), Color(0xFF50C4ED)],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).systemGestureInsets.top),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: leading,
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.lato(fontSize: 24),
                        text: "Welcome, ",
                        children: [
                          TextSpan(
                            text: firstName,
                            style: GoogleFonts.lato(
                                fontSize: 24, fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    Text(
                      "You can start managing your EPs!",
                      style: GoogleFonts.lato(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFBEDAF6),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: trailing,
            )
          ],
        ),
      ),
    );
  }
}
