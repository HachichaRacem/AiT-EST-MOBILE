import 'package:aiesec_im/controllers/main_controller.dart';
import 'package:aiesec_im/utils/exchange_participant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class UpdateContactedDialog extends StatelessWidget {
  final Map values;

  final Color _activeTrackColor = const Color(0xFF34C759);

  // 0 - normal, 1 - loading
  final RxInt _updateContactedStatus = RxInt(0);
  final RxInt _updateInterestedStatus = RxInt(0);

  UpdateContactedDialog({super.key, required this.values});

  void _updateIsContactedValue(bool value, BuildContext context) async {
    try {
      _updateContactedStatus.value = 1;
      await MainController.dio.put(
          "/updateContactedStatus/${MainController.user?.lcName}/${values['epID']}",
          queryParameters: {"newValue": value});
      values['contacted'].value = value;
    } catch (e) {
      Get.log("Updating contacted value : $e");
      Get.engine.addPostFrameCallback(
        (timeStamp) => toastification.show(
          autoCloseDuration: const Duration(seconds: 4),
          type: ToastificationType.error,
          context: context,
          title: const Text("Error"),
          description: const Text(
            "Could not update EP's contacted state",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      );
    } finally {
      _updateContactedStatus.value = 0;
    }
  }

  void _updateIsInterestedValue(bool value, BuildContext context) async {
    try {
      _updateInterestedStatus.value = 1;
      await MainController.dio.put(
        "/updateInterestedStatus/${MainController.user?.lcName}/${values['epID']}",
        queryParameters: {"newValue": value},
      );
      values['interested'].value = value;
    } catch (e) {
      Get.log("Updating interested value : $e");
      Get.engine.addPostFrameCallback(
        (timeStamp) => toastification.show(
          autoCloseDuration: const Duration(seconds: 4),
          type: ToastificationType.error,
          context: context,
          title: const Text("Error"),
          description: const Text(
            "Could not update EP's interested state",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      );
    } finally {
      _updateInterestedStatus.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      backgroundColor: Colors.white,
      title: Column(
        children: [
          Text(
            "Fill with needed information",
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: const Color(0xFF505050),
            ),
          ),
          const SizedBox(height: 12),
          const Divider()
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 26),
              Text(
                "Contacted",
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
              const SizedBox(width: 50),
              Obx(
                () => _updateContactedStatus.value == 1
                    ? const Padding(
                        padding: EdgeInsets.only(left: 24.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      )
                    : Switch(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: values['contacted'].value,
                        onChanged: (value) => _updateIsContactedValue(value, context),
                        trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
                        activeTrackColor: _activeTrackColor,
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              children: [
                const SizedBox(width: 26),
                Text(
                  "Interested",
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF101828),
                  ),
                ),
                const SizedBox(width: 50),
                Obx(
                  () => _updateInterestedStatus.value == 0
                      ? Switch(
                          value: values['interested'].value,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (value) => _updateIsInterestedValue(value, context),
                          trackOutlineColor: const MaterialStatePropertyAll(Colors.white),
                          activeTrackColor: _activeTrackColor,
                        )
                      : const Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
                          ),
                        ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UpdateNotesDialog extends StatelessWidget {
  final ExchangeParticipant ep;
  late final TextEditingController notesController =
      TextEditingController(text: ep.notes.isEmpty ? null : ep.notes);

  // 0 - confirmNormal, 1 - confirmLoading
  // 2 - clearNormal, 3 - clearLoading
  final RxInt _currentState = RxInt(0);
  final RxString _inputError = RxString("");
  UpdateNotesDialog({super.key, required this.ep});

  Future<void> _updateNotes({bool clear = false}) async {
    try {
      _currentState.value = clear ? 3 : 1;
      if (!clear && notesController.text.isEmpty) {
        _inputError.value = "Notes cannot be empty, if you want to clear it press the clear button";
        return;
      } else {
        await MainController.dio.put(
          "/updateNotes/${MainController.user?.lcName}/${ep.expaEPID}",
          queryParameters: {"newValue": clear ? "" : notesController.text},
        );
        ep.notes = clear ? "" : notesController.text;
        if (clear) {
          notesController.clear();
        }
      }
    } catch (e) {
      Get.log("$e");
      _inputError.value = "Could not update notes";
    } finally {
      _currentState.value = clear ? 2 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notes",
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF101828),
                ),
              ),
              SizedBox(
                height: 24,
                width: 24,
                child: IconButton(
                  onPressed: () => Get.back(closeOverlays: true),
                  icon: const Icon(
                    Icons.close_rounded,
                  ),
                  padding: EdgeInsets.zero,
                ),
              )
            ],
          ),
          Text(
            "Write your notes below",
            style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF475467)),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => TextField(
              controller: notesController,
              maxLines: 6,
              minLines: 4,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF101828),
                decorationThickness: 0,
              ),
              onChanged: (value) => _inputError.value = "",
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                error: _inputError.isEmpty
                    ? null
                    : Text(
                        _inputError.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10, color: Get.theme.colorScheme.error),
                      ),
                hintText: "Add Notes..",
                hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF667085)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _updateNotes,
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
                child: Obx(
                  () => _currentState.value == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.white),
                        )
                      : Text(
                          "Confirm",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _updateNotes(clear: true),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF344054)),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  overlayColor: MaterialStatePropertyAll(Colors.black12),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                child: Obx(
                  () => _currentState.value == 3
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.black),
                        )
                      : Text(
                          "Clear",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateTrackingPhaseDialog extends StatelessWidget {
  late final RxString _selectedPhase = RxString(ep.trackingPhase.value);
  final RxString _errorMessage = RxString("");

  // 0 - confirmNormal, 1 - confirmLoading
  // 2 - cancelNormal, 3 - cancelLoading
  final RxInt _currentState = RxInt(0);
  final ExchangeParticipant ep;

  final List<String> _phases = [
    "Explaining what's AIESEC",
    "Waiting for answer",
    "EP not responding",
    "Looking for opportunities",
    "Having an interview",
    "Will sign contract",
    "Contract signed",
    "Waiting for CV"
  ];
  UpdateTrackingPhaseDialog({super.key, required this.ep});

  Future<void> _updateTrackingPhase({bool clear = false}) async {
    try {
      _currentState.value = clear ? 3 : 1;
      if (!clear && _selectedPhase.isEmpty) {
        _errorMessage.value = "Select a phase or else use the clear button";
        return;
      } else {
        await MainController.dio.put(
          "/updateTrackingPhase/${MainController.user?.lcName}/${ep.expaEPID}",
          queryParameters: {"newValue": clear ? "" : _selectedPhase.value},
        );
        ep.trackingPhase.value = clear ? "" : _selectedPhase.value;
        if (clear) {
          _selectedPhase.value = "";
        }
      }
    } catch (e) {
      Get.log("$e");
      _errorMessage.value = "Could not update phase";
    } finally {
      _currentState.value = clear ? 2 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Add Tracking Phase",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              onPressed: () => Get.back(closeOverlays: true),
              icon: const Icon(
                Icons.close_rounded,
              ),
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tracking Phase",
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF344054),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFD0D5DD)),
              ),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Icon(Icons.adjust_rounded, size: 20, color: Color(0xFF667085)),
                  ),
                  Obx(
                    () => DropdownButton(
                      menuMaxHeight: 180,
                      isDense: true,
                      padding: const EdgeInsets.all(6.0),
                      underline: const SizedBox(),
                      icon: Transform.rotate(
                        angle: 180.61,
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 13,
                        ),
                      ),
                      hint: Text(
                        "Select from here",
                        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      value: _selectedPhase.value.isEmpty ? null : _selectedPhase.value,
                      items: List.generate(
                        _phases.length,
                        (index) {
                          return DropdownMenuItem(
                            value: _phases[index],
                            child: Text(
                              _phases[index],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101828),
                              ),
                            ),
                          );
                        },
                      ),
                      onChanged: (value) {
                        _selectedPhase.value = value!;
                        _errorMessage.value = "";
                      },
                    ),
                  ),
                  Obx(
                    () => _errorMessage.isNotEmpty
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                _errorMessage.value,
                                style: GoogleFonts.lato(
                                    color: Colors.red, fontSize: 11, fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _updateTrackingPhase,
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
                child: Obx(
                  () => _currentState.value == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.white),
                        )
                      : Text(
                          "Confirm",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _updateTrackingPhase(clear: true),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF344054)),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  overlayColor: MaterialStatePropertyAll(Colors.black12),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                child: Obx(
                  () => _currentState.value == 3
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.black),
                        )
                      : Text(
                          "Clear",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateUniversityDialog extends StatelessWidget {
  final ExchangeParticipant ep;
  late final TextEditingController universityController =
      TextEditingController(text: ep.university.isEmpty ? null : ep.university.value);

  // 0 - confirmNormal, 1 - confirmLoading
  // 2 - clearNormal, 3 - clearLoading
  final RxInt _currentState = RxInt(0);
  final RxString _inputError = RxString("");
  UpdateUniversityDialog({super.key, required this.ep});

  Future<void> _updateUniversity({bool clear = false}) async {
    try {
      _currentState.value = clear ? 3 : 1;
      if (!clear && universityController.text.isEmpty) {
        _inputError.value =
            "University cannot be empty, if you want to clear it press the clear button";
        return;
      } else {
        await MainController.dio.put(
          "/updateUniversity/${MainController.user?.lcName}/${ep.expaEPID}",
          queryParameters: {"newValue": clear ? "" : universityController.text},
        );
        ep.university.value = clear ? "" : universityController.text;
        if (clear) {
          universityController.clear();
        }
      }
    } catch (e) {
      Get.log("$e");
      _inputError.value = "Could not update notes";
    } finally {
      _currentState.value = clear ? 2 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "University",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              onPressed: () => Get.back(closeOverlays: true),
              icon: const Icon(
                Icons.close_rounded,
              ),
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => TextField(
              controller: universityController,
              maxLines: 1,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF101828),
                decorationThickness: 0,
              ),
              onChanged: (value) => _inputError.value = "",
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                error: _inputError.isEmpty
                    ? null
                    : Text(
                        _inputError.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10, color: Get.theme.colorScheme.error),
                      ),
                hintText: "University..",
                hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF667085)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _updateUniversity,
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
                child: Obx(
                  () => _currentState.value == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.white),
                        )
                      : Text(
                          "Confirm",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _updateUniversity(clear: true),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF344054)),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  overlayColor: MaterialStatePropertyAll(Colors.black12),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                child: Obx(
                  () => _currentState.value == 3
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.black),
                        )
                      : Text(
                          "Clear",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateFieldDialog extends StatelessWidget {
  final ExchangeParticipant ep;
  late final TextEditingController fieldController =
      TextEditingController(text: ep.field.isEmpty ? null : ep.field.value);

  // 0 - confirmNormal, 1 - confirmLoading
  // 2 - clearNormal, 3 - clearLoading
  final RxInt _currentState = RxInt(0);
  final RxString _inputError = RxString("");
  UpdateFieldDialog({super.key, required this.ep});

  Future<void> _updateUniversity({bool clear = false}) async {
    try {
      _currentState.value = clear ? 3 : 1;
      if (!clear && fieldController.text.isEmpty) {
        _inputError.value = "Field cannot be empty, if you want to clear it press the clear button";
        return;
      } else {
        await MainController.dio.put(
          "/updateField/${MainController.user?.lcName}/${ep.expaEPID}",
          queryParameters: {"newValue": clear ? "" : fieldController.text},
        );
        ep.field.value = clear ? "" : fieldController.text;
        if (clear) {
          fieldController.clear();
        }
      }
    } catch (e) {
      Get.log("$e");
      _inputError.value = "Could not update notes";
    } finally {
      _currentState.value = clear ? 2 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Field",
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101828),
            ),
          ),
          SizedBox(
            height: 24,
            width: 24,
            child: IconButton(
              onPressed: () => Get.back(closeOverlays: true),
              icon: const Icon(
                Icons.close_rounded,
              ),
              padding: EdgeInsets.zero,
            ),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => TextField(
              controller: fieldController,
              maxLines: 1,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF101828),
                decorationThickness: 0,
              ),
              onChanged: (value) => _inputError.value = "",
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFD0D5DD),
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                error: _inputError.isEmpty
                    ? null
                    : Text(
                        _inputError.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 10, color: Get.theme.colorScheme.error),
                      ),
                hintText: "Field..",
                hintStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF667085)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _updateUniversity,
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
                child: Obx(
                  () => _currentState.value == 1
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.white),
                        )
                      : Text(
                          "Confirm",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: () => _updateUniversity(clear: true),
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.white),
                  surfaceTintColor: MaterialStatePropertyAll(Colors.white),
                  foregroundColor: MaterialStatePropertyAll(Color(0xFF344054)),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Color(0xFFD0D5DD),
                    ),
                  ),
                  overlayColor: MaterialStatePropertyAll(Colors.black12),
                  shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                  ),
                ),
                child: Obx(
                  () => _currentState.value == 3
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.2, color: Colors.black),
                        )
                      : Text(
                          "Clear",
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
