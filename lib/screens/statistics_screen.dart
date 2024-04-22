import 'package:aiesec_im/controllers/statistics_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatisticsScreen extends GetView<StatisticsController> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFEFF5FD),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DecoratedBox(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Obx(
                  () => controller.currentState.value == 0
                      ? const Center(
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 0.8),
                          ),
                        )
                      : FunnelOverview(
                          data: {
                            "totals": controller.dataMap['totals'],
                            "totalEPs": controller.dataMap['totalEPs']
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DecoratedBox(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Obx(
                  () => controller.currentState.value == 0
                      ? const Center(
                          child: SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 0.8),
                          ),
                        )
                      : Tracking(
                          data: controller.dataMap['percentages'],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FunnelOverview extends StatelessWidget {
  final Map data;
  final funnelBarsColors = const [
    Color(0xFF333A73),
    Color(0xFF387ADF),
    Color(0xFF50C4ED),
    Color(0xFF50C4ED),
    Color(0xFF484B50),
    Color(0xFF484B50),
    Color(0xFF484B50)
  ];
  const FunnelOverview({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Funnel Overview",
          style: GoogleFonts.lato(
              color: const Color(0xFFFBA834), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        for (int i = 0; i < data['totals'].values.length - 1; i++)
          _FunnelItem(
            color: funnelBarsColors[i],
            percent: (data['totals'].values.elementAt(i) / data['totalEPs']),
            title: data['totals'].keys.elementAt(i),
            value: data['totals'].values.elementAt(i),
          )
      ],
    );
  }
}

class _FunnelItem extends StatelessWidget {
  final Color color;
  final double percent;
  final int value;
  final String title;
  const _FunnelItem(
      {required this.color, required this.percent, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF101828),
          ),
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: LinearProgressIndicator(
              color: color,
              value: percent,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Text(
          value.toString(),
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF101828),
          ),
        )
      ],
    );
  }
}

class Tracking extends StatelessWidget {
  final Map data;
  final List<Color> colors = const [Color(0xFF333A73), Color(0xFF387ADF), Color(0xFFFBA834)];
  const Tracking({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Tracking",
          style: GoogleFonts.lato(
              color: const Color(0xFFFBA834), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            data.values.length,
            (index) => Column(children: [
              CircularPercentIndicator(
                circularStrokeCap: CircularStrokeCap.round,
                radius: 35,
                progressColor: colors[index],
                percent: data.values.elementAt(index) / 100,
                center: Text("${data.values.elementAt(index).toStringAsFixed(1)} %",
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF101828),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  data.keys.elementAt(index),
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF101828),
                  ),
                ),
              )
            ]),
          ),
        )
      ],
    );
  }
}
