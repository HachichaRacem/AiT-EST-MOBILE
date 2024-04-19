import 'package:aiesec_im/controllers/eps_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class EpsTable extends GetView<EpsController> {
  final bool isManagementScreen;
  final ScrollController verticalController = ScrollController();
  final ScrollController horizontalController = ScrollController();
  EpsTable({super.key, required this.isManagementScreen});

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    const columns = ["Name", "EP ID", "Allocated Member"];
    const double paddingLeft = 24.0;

    final data = isManagementScreen ? controller.departmentEPs : controller.allocatedEPsList;

    if (vicinity.row == 0) {
      switch (vicinity.column) {
        case 0:
          return TableViewCell(
            child: Padding(
              padding: const EdgeInsets.only(left: paddingLeft),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    if (isManagementScreen)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: Obx(
                            () => Checkbox(
                              splashRadius: 13,
                              side: const BorderSide(
                                width: 1.2,
                                color: Color(0xFFD0D5DD),
                              ),
                              tristate: true,
                              value: controller.selectedEPsList.isNotEmpty
                                  ? controller.selectedEPsList.length >= data.length - 1
                                      ? true
                                      : null
                                  : false,
                              onChanged: controller.onEpsHeaderCheckboxClick,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Text(
                      columns[0],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475467),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        case 1:
          return TableViewCell(
            child: Padding(
              padding: const EdgeInsets.only(left: paddingLeft),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      columns[vicinity.column],
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF475467),
                      ),
                    ),
                    const Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      message: "Unique ID on EXPA",
                      child: Padding(
                        padding: EdgeInsets.only(left: 5.0),
                        child: Icon(
                          Icons.help_outline_rounded,
                          size: 14,
                          color: Color(0xFF98A2B3),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        default:
          return TableViewCell(
            child: Padding(
              padding: const EdgeInsets.only(left: paddingLeft),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  columns[vicinity.column],
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475467),
                  ),
                ),
              ),
            ),
          );
      }
    }
    final String epName = data[vicinity.row]['Full Name'];
    final String epID = data[vicinity.row]['EP ID'];
    final String epManager = data[vicinity.row]['Member Name'];

    switch (vicinity.column) {
      case 0:
        return TableViewCell(
          child: Padding(
            padding: const EdgeInsets.only(left: paddingLeft),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  if (isManagementScreen)
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Obx(
                          () => Checkbox(
                            splashRadius: 13,
                            side: const BorderSide(
                              width: 1.2,
                              color: Color(0xFFD0D5DD),
                            ),
                            value: controller.selectedEPsList.contains(vicinity.row),
                            onChanged: (value) => {controller.onEpTileSelect(value!, vicinity.row)},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Flexible(
                    child: Text(
                      epName,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF101828),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case 2:
        return TableViewCell(
          child: Padding(
            padding: const EdgeInsets.only(left: paddingLeft),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Text(
                  epManager.isNotEmpty ? epManager : "None",
                  style: GoogleFonts.inter(
                      color: const Color(0xFF344054), fontWeight: FontWeight.w500, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      default:
        return TableViewCell(
          child: Padding(
            padding: const EdgeInsets.only(left: paddingLeft),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                epID.isNotEmpty ? epID : "-",
                style: GoogleFonts.inter(color: const Color(0xFF475467), fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
    }
  }

  TableSpan? _columnBuilder(int index) {
    double spanExtent = 160;
    switch (index) {
      case 0:
        spanExtent = isManagementScreen ? 220 : 200;
        break;
      case 1:
        spanExtent = 100;
    }
    return TableSpan(
      extent: FixedTableSpanExtent(spanExtent),
    );
  }

  TableSpan? _rowBuilder(int index) {
    final data = isManagementScreen ? controller.departmentEPs : controller.allocatedEPsList;
    return TableSpan(
      extent: FixedTableSpanExtent(index == 0 ? 44 : 70),
      backgroundDecoration: TableSpanDecoration(
        color: index == 0 ? const Color(0xFFF9FAFB) : null,
        border: TableSpanBorder(
          leading: const BorderSide(color: Color(0xFFE4E7EC)),
          trailing: index == data.length - 1
              ? const BorderSide(
                  color: Color(0xFFE4E7EC),
                )
              : BorderSide.none,
        ),
      ),
      recognizerFactories: index != 0
          ? <Type, GestureRecognizerFactory>{
              TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
                () => TapGestureRecognizer(),
                (TapGestureRecognizer t) => t.onTap = () => Get.toNamed(
                      '/epProfile',
                      id: 0,
                      arguments: <String, dynamic>{"data": data.sublist(1), "index": index},
                    ),
              ),
            }
          : {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollbarTheme(
      data: const ScrollbarThemeData(
        crossAxisMargin: 4,
      ),
      child: Scrollbar(
        scrollbarOrientation: ScrollbarOrientation.bottom,
        interactive: true,
        radius: const Radius.circular(20),
        thickness: 6.0,
        trackVisibility: true,
        thumbVisibility: true,
        controller: horizontalController,
        child: TableView.builder(
          verticalDetails: ScrollableDetails.vertical(controller: verticalController),
          horizontalDetails: ScrollableDetails.horizontal(controller: horizontalController),
          columnCount: 3,
          rowCount: isManagementScreen
              ? controller.departmentEPs.length
              : controller.allocatedEPsList.length,
          columnBuilder: _columnBuilder,
          rowBuilder: _rowBuilder,
          cellBuilder: _buildCell,
        ),
      ),
    );
  }
}
