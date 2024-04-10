import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EpProfileInfoTile extends StatelessWidget {
  final String title;
  final String value;
  final bool? editable;
  const EpProfileInfoTile({super.key, required this.title, required this.value, this.editable});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 63, right: 36),
            child: Text(
              title,
              style: GoogleFonts.lato(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF101828),
              ),
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: editable == true ? 15.0 : 30),
              child: Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                message: value.isNotEmpty ? value : "-",
                child: Text(
                  value.isNotEmpty ? value : "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF475467),
                  ),
                ),
              ),
            ),
          ),
          if (editable == true)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                height: 22,
                width: 22,
                child: IconButton(
                  color: const Color(0xFF475467),
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined),
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                ),
              ),
            )
        ],
      ),
    );
  }
}
