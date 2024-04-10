import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AssignToDialog extends StatelessWidget {
  const AssignToDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Assign to",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFBA834),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 25,
            indent: 25,
            color: Color(0xFFE2E8F0),
          )
        ],
      ),
      content: SizedBox(
        height: 250,
        child: Scrollbar(
          radius: const Radius.circular(20),
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(MainController.user!.deptMembers.length, (index) {
                final memberName = MainController.user!.deptMembers[index]['fullName']!;
                return SizedBox(
                  child: ListTile(
                    onTap: () {
                      Get.back();
                      Get.dialog(
                        AssignConfirmDialog(
                          selectedMember: memberName,
                        ),
                      );
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      memberName,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF101828),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class AssignConfirmDialog extends StatelessWidget {
  final String selectedMember;
  const AssignConfirmDialog({super.key, required this.selectedMember});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Assigned to",
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF32D583),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Divider(
            endIndent: 25,
            indent: 25,
            color: Color(0xFFE2E8F0),
          )
        ],
      ),
      content: Text(
        selectedMember,
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            surfaceTintColor: const MaterialStatePropertyAll(Colors.white),
            foregroundColor: const MaterialStatePropertyAll(
              Color(0xFFE70013),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFFE70013))),
            ),
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: const MaterialStatePropertyAll(Color(0xFF32D583)),
            surfaceTintColor: const MaterialStatePropertyAll(Color(0xFF32D583)),
            foregroundColor: const MaterialStatePropertyAll(Colors.white),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(Icons.check),
          ),
        )
      ],
    );
  }
}
