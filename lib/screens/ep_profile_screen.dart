import 'package:aiesec_im/widgets/ep_profile_arrow.dart';
import 'package:aiesec_im/widgets/ep_profile_dialogs.dart';
import 'package:aiesec_im/widgets/ep_profile_info_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class EpsProfilesScreen extends StatelessWidget {
  final List data;
  final int openedEpIndex;
  late final PageController _controller = PageController(initialPage: openedEpIndex - 1);
  EpsProfilesScreen({super.key, required this.data, required this.openedEpIndex});

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
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: List.generate(
            data.length,
            (index) => EpSingleProfileScreen(
              epData: data[index],
              pageController: _controller,
              lastPageIndex: data.length - 1,
            ),
          ),
        ),
      ),
    );
  }
}

class EpSingleProfileScreen extends StatelessWidget {
  final Map epData;
  final PageController pageController;
  final int lastPageIndex;
  const EpSingleProfileScreen(
      {super.key, required this.epData, required this.pageController, required this.lastPageIndex});

  void _onContactTap() {
    Get.log("$epData");
    Get.dialog(UpdateContactedDialog(
      values: {"contacted": epData['Contacted'], "interested": epData['Interested']},
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                          padding: const EdgeInsets.only(left: 12, right: 12, top: 64),
                          child: Row(
                            children: [
                              EpProfileArrow(
                                isFlipped: false,
                                onTap: () {
                                  final double currentIndex = pageController.page!;
                                  if (currentIndex == 0.0) {
                                    pageController.animateToPage(
                                      lastPageIndex,
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeIn,
                                    );
                                  } else {
                                    pageController.animateToPage(
                                      (currentIndex - 1).toInt(),
                                      duration: const Duration(milliseconds: 250),
                                      curve: Curves.easeIn,
                                    );
                                  }
                                },
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
                              EpProfileArrow(
                                isFlipped: true,
                                onTap: () {
                                  final double currentIndex = pageController.page!;
                                  pageController.animateToPage(
                                    (currentIndex + 1).toInt(),
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeIn,
                                  );
                                },
                              )
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
                                              style: ToastificationStyle.flat,
                                              closeOnClick: true,
                                              autoCloseDuration: const Duration(
                                                seconds: 2,
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
                              GestureDetector(
                                onTap: _onContactTap,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFD6DFE5,
                                        ),
                                      ),
                                      color: const Color(0xFFF3F8FF)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                                    child: Text(
                                      epData['Contacted'] == "TRUE" ? "Contacted" : "Not contacted",
                                      style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: epData['Contacted'] == "TRUE"
                                              ? const Color(0xFF387ADF)
                                              : Colors.grey,
                                          fontWeight: FontWeight.w500),
                                    ),
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
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
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
              EpProfileInfoTile(
                  title: "Interested",
                  value: epData['Interested'] == "TRUE" ? "Interested" : "Not Interested"),
              EpProfileInfoTile(
                  title: "Phone Number: ", value: epData["Phone Number(s)"], isPhoneNumber: true),
              EpProfileInfoTile(title: "Email: ", value: epData["Email(s)"]),
              EpProfileInfoTile(title: "Source: ", value: epData["Source"]),
              EpProfileInfoTile(title: "University: ", value: epData["University"], editable: true),
              EpProfileInfoTile(
                  title: "Field of Study: ", value: epData["Field Of Study"], editable: true),
            ],
          ),
        )
      ],
    );
  }
}
