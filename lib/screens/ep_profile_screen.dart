import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:aiesec_im/widgets/ep_profile_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EpProfileScreen extends StatelessWidget {
  final ExchangeParticipant epData;
  const EpProfileScreen({super.key, required this.epData});

  void _onContactTap() {
    Get.dialog(
      UpdateContactedDialog(
        values: {"contacted": epData.isContacted, "interested": epData.isInterested},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFEFF5FD),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => _ProfileChip(
                    title: "Contacted",
                    isToAdd: !epData.isContacted.value,
                    onTap: _onContactTap,
                    titleColor: const Color(0xFF387ADF),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 27.0),
                  child: _ProfileChip(
                    title: epData.status,
                    titleColor: const Color(0xFF32D583),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: const MaterialStatePropertyAll(Color(0xFFFBA834)),
                      surfaceTintColor: const MaterialStatePropertyAll(Color(0xFFFBA834)),
                      overlayColor: const MaterialStatePropertyAll(Colors.white10),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: Text("CV",
                        style: GoogleFonts.inter(
                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFF387ADF), Color(0xFF50C4ED)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
                        backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
                        overlayColor: const MaterialStatePropertyAll(Colors.white10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: Text(
                        "Notes",
                        style: GoogleFonts.inter(
                            fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          children: [
                            _InfoTile(
                                title: epData.isInterested.value ? "Interested" : "Not interested"),
                            _InfoTile(title: epData.phoneNumber, isPhone: true),
                            _InfoTile(title: epData.email),
                            _InfoTile(title: epData.source, showDivider: false),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DecoratedBox(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16), color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Column(
                          children: [
                            _InfoTile(
                              title: "Add Tracking Phase",
                              titleColor: const Color(0xFF387ADF),
                            ),
                            _InfoTile(title: epData.university, editable: true),
                            _InfoTile(title: epData.field, showDivider: false, editable: true),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  final Function()? onTap;
  final String title;
  final bool isToAdd;
  final Color titleColor;
  const _ProfileChip(
      {this.onTap, required this.title, this.isToAdd = false, required this.titleColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(
              0xFFD6DFE5,
            ),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12.0),
          child: isToAdd == true
              ? const Icon(Icons.add_rounded, size: 22, color: Colors.grey)
              : Text(
                  title,
                  style: GoogleFonts.lato(
                      fontSize: 14, color: titleColor, fontWeight: FontWeight.w500),
                ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final bool isPhone;
  final bool showDivider;
  final Color? titleColor;
  final bool? editable;

  late final _textStyle = GoogleFonts.lato(
      fontWeight: FontWeight.w700, fontSize: 16, color: titleColor ?? const Color(0xFF101828));

  _InfoTile(
      {required this.title,
      this.isPhone = false,
      this.showDivider = true,
      this.titleColor,
      this.editable});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 32),
          child: isPhone
              ? GestureDetector(
                  onTap: title.isEmpty
                      ? null
                      : () async {
                          try {
                            await launchUrl(Uri(scheme: 'tel', path: title));
                          } catch (e) {
                            Get.log("Phone exception : $e");
                          }
                        },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle,
                          color: title.isEmpty ? Colors.grey : Colors.green, size: 10),
                      const SizedBox(width: 8),
                      Text(title.isEmpty ? "Not provided" : title,
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: _textStyle)
                    ],
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(title.isEmpty ? "-" : title,
                          maxLines: 1, overflow: TextOverflow.ellipsis, style: _textStyle),
                    ),
                    if (editable == true)
                      const Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: Color(0xFF387ADF),
                        ),
                      )
                  ],
                ),
        ),
        if (showDivider) const Divider()
      ],
    );
  }
}
