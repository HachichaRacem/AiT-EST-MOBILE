import 'package:aiesec_im/controllers/statistics_controller.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:fl_chart/fl_chart.dart';
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
        child: Obx(
          () => controller.currentState.value == 1
              ? Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Something went wrong",
                        style: GoogleFonts.inter(fontSize: 14, color: Get.theme.colorScheme.error),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: controller.onReady,
                            icon: Icon(
                              Icons.replay_rounded,
                              size: 20,
                              color: Get.theme.colorScheme.error,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: controller.currentState.value == 0
                      ? const LoadingStatisticsScreen()
                      : Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12), color: Colors.white),
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
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12), color: Colors.white),
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
                              const SizedBox(height: 12),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12), color: Colors.white),
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
                                        : DepartmentAnalysis(
                                            data: {
                                              "totalEPs": controller.dataMap['totalEPs'],
                                              "Strangers": controller.dataMap['totals']['Stranger'],
                                              "Contacted": controller.dataMap['totals']
                                                  ['Contacted'],
                                              "Interested": controller.dataMap['totals']
                                                  ['Interested']
                                            },
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
        ),
      ),
    );
  }
}

class LoadingStatisticsScreen extends StatelessWidget {
  const LoadingStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                7,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FadeShimmer(
                        width: 60,
                        radius: 12,
                        highlightColor: Color(0xffF9F9FB),
                        baseColor: Color(0xffE6E8EB),
                        height: 8,
                      ),
                      FadeShimmer(
                        width: 220,
                        radius: 12,
                        highlightColor: Color(0xffF9F9FB),
                        baseColor: Color(0xffE6E8EB),
                        height: 8,
                      ),
                      FadeShimmer(
                        width: 20,
                        radius: 12,
                        highlightColor: Color(0xffF9F9FB),
                        baseColor: Color(0xffE6E8EB),
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Column(
                    children: [
                      FadeShimmer.round(
                        size: 70,
                        highlightColor: const Color(0xffF9F9FB),
                        baseColor: const Color(0xffE6E8EB),
                      ),
                      const SizedBox(height: 10),
                      const FadeShimmer(
                        width: 40,
                        radius: 12,
                        highlightColor: Color(0xffF9F9FB),
                        baseColor: Color(0xffE6E8EB),
                        height: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.white),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              FadeShimmer(
                width: 70,
                radius: 16,
                height: 220,
                highlightColor: Color(0xffF9F9FB),
                baseColor: Color(0xffE6E8EB),
              ),
            ]),
          ),
        ),
      ],
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
        for (int i = 0; i < data['totals'].values.length - 3; i++)
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

class DepartmentAnalysis extends StatelessWidget {
  final Map data;
  final List<Color> colors = const [
    Color(0xFF333A73),
    Color(0xFF387ADF),
    Color(0xFF50C4ED),
    Color(0xFFFBA834)
  ];
  final List<String> titles = const ["Total EPs", "Strangers", "Contacted", "Interested"];
  const DepartmentAnalysis({super.key, required this.data});

  BarChartGroupData _generateGroupData(int x, int? y) {
    y ??= 0;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y == 0 ? 0.01 : y.toDouble(),
          borderRadius: BorderRadius.circular(3),
          width: 16,
          color: colors[x],
        ),
      ],
    );
  }

  double _getMaxValue() {
    double max = 0.0;
    for (final int? value in data.values) {
      if (value != null && value > max) {
        final reminder = value % 5;
        if (reminder != 0) {
          max = (value + (5 - reminder)).toDouble();
        } else {
          max = value.toDouble();
        }
      }
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          "Department Analysis",
          style: GoogleFonts.lato(
              color: const Color(0xFFFBA834), fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 24),
        AspectRatio(
          aspectRatio: 1.8,
          child: BarChart(
            BarChartData(
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (group) => colors[group.x],
                  getTooltipItem: (group, groupIndex, rod, rodIndex) => BarTooltipItem(
                    rod.toY.toString(),
                    GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              gridData: FlGridData(
                drawHorizontalLine: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => const FlLine(strokeWidth: 0.1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Text(
                      "${value.toInt()}",
                      style: GoogleFonts.lato(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101828),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 18,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        titles[value.toInt()],
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(
                              0xFF101828,
                            )),
                      ),
                    ),
                  ),
                ),
              ),
              barGroups: List.generate(
                4,
                (index) => _generateGroupData(
                  index,
                  data.values.elementAt(index),
                ),
              ),
              maxY: _getMaxValue(),
            ),
          ),
        )
      ],
    );
  }
}
