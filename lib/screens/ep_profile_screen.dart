import 'dart:math' as math;
import 'package:aiesec_im/widgets/ep_profile_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class EpProfileScreen extends StatelessWidget {
  final Map epData;
  const EpProfileScreen({super.key, required this.epData});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 22.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, top: 64),
                              child: Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      size: 14,
                                      color: Color(0xFF475467),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      epData['Full Name'],
                                      style: GoogleFonts.lato(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF101828),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.all(4.0),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF475467),
                                      ),
                                    ),
                                    child: Transform.rotate(
                                      angle: 180 * math.pi / 180,
                                      child: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 14,
                                        color: Color(0xFF475467),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 6.0, bottom: 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    epData['EP ID'],
                                    style: GoogleFonts.lato(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFFBA834),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: IconButton(
                                        onPressed: () async {
                                          String message = "";
                                          try {
                                            await Clipboard.setData(
                                                ClipboardData(text: epData['EP ID']));
                                            message = "Copied to clipboard";
                                          } catch (e) {
                                            message = "Could not copy ID";
                                          } finally {
                                            Get.engine.addPostFrameCallback(
                                              (timeStamp) {
                                                toastification.show(
                                                  context: context,
                                                  title: Text(message),
                                                  type: ToastificationType.info,
                                                  style: ToastificationStyle.simple,
                                                  closeOnClick: true,
                                                  autoCloseDuration: const Duration(
                                                    seconds: 3,
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.copy),
                                        iconSize: 16,
                                        color: const Color(0xFFFBA834),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 26, bottom: 41),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (epData['Contacted'] == "TRUE")
                                    DecoratedBox(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: const Color(
                                              0xFFD6DFE5,
                                            ),
                                          ),
                                          color: const Color(0xFFF3F8FF)),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 10.0),
                                        child: Text(
                                          "Contacted",
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: epData['Contacted'] == "TRUE"
                                                  ? const Color(0xFF387ADF)
                                                  : Colors.grey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 27.0),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(
                                            0xFFD6E5DF,
                                          ),
                                        ),
                                        color: const Color(0xFFF1FFF8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3.0, horizontal: 10.0),
                                        child: Text(
                                          epData['Status on expa'] == ""
                                              ? "Stranger"
                                              : epData['Status on expa'],
                                          style: GoogleFonts.lato(
                                              fontSize: 14,
                                              color: const Color(0xFF32D583),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 16,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: Text(
                                "CV",
                                style: GoogleFonts.lato(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFFFBA834),
                                ),
                              ),
                            ),
                            const Icon(Icons.download_for_offline_rounded,
                                color: Color(0xFFFBA834), size: 18)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  EpProfileInfoTile(title: "Phone Number: ", value: epData["Phone Number(s)"]),
                  EpProfileInfoTile(title: "Email: ", value: epData["Email(s)"]),
                  EpProfileInfoTile(title: "Source: ", value: epData["Source"]),
                  EpProfileInfoTile(
                      title: "University: ", value: epData["University"], editable: true),
                  EpProfileInfoTile(
                      title: "Field of Study: ", value: epData["Field Of Study"], editable: true),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
