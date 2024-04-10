import 'dart:math' as math;
import 'package:flutter/material.dart';

class EpProfileArrow extends StatelessWidget {
  final bool isFlipped;
  final VoidCallback onTap;
  const EpProfileArrow({super.key, required this.isFlipped, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.circle,
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF475467),
              ),
            ),
            child: isFlipped
                ? Transform.rotate(
                    angle: 180 * math.pi / 180,
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 13,
                      color: Color(0xFF475467),
                    ),
                  )
                : const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 13,
                    color: Color(0xFF475467),
                  ),
          ),
        ),
      ),
    );
  }
}
