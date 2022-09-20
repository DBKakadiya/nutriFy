import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../handler/steps_handler.dart';
import '../../models/step_data.dart';
import '../../resources/resource.dart';

class StepsLast7DaysScreen extends StatefulWidget {
  static const route = '/Steps-7Days';

  const StepsLast7DaysScreen({Key? key}) : super(key: key);

  @override
  State<StepsLast7DaysScreen> createState() => _StepsLast7DaysScreenState();
}

class _StepsLast7DaysScreenState extends State<StepsLast7DaysScreen> {
  DateTime currentDate = DateTime.now();

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  int touchedIndexForStepsChart = -1;

  List<StepsData>? stepsData;
  List dates = [];
  Map<String, int>? map = {};

  int? total = 0;
  double? avg = 0.0;

  @override
  void initState() {
    getLast7DaysData();
    getTotalLast7DaysSteps();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorBG,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            toolbarHeight: deviceHeight(context) * 0.08,
            backgroundColor: colorWhite,
            elevation: 5,
            shadowColor: colorIndigo.withOpacity(0.25),
            leadingWidth: deviceWidth(context) * 0.18,
            leading: buttons(icBack, () => Navigator.of(context).pop()),
            title: Text('Steps Report', style: textStyle20Bold(colorIndigo))),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.04),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  DateFormat.MMMd().format(DateTime.parse(dates[0])) +
                      " - " +
                      DateFormat.MMMd().format(DateTime.parse(dates[6])),
                  style: textStyle18Bold(colorIndigo),
                ),
                const SizedBox(height: 15),
                chartView(),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    totalAvg('Total', '$total'),
                    totalAvg('Average', avg!.toStringAsFixed(2))
                  ],
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ));
  }

  chartView() {
    return Container(
      height: 400,
      decoration: decoration(10),
      padding: EdgeInsets.symmetric(
          vertical: 12, horizontal: deviceWidth(context) * 0.015),
      child: BarChart(
        BarChartData(
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: colorIndigo.withOpacity(0.1),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    String day;
                    switch (group.x.toInt()) {
                      case 0:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[0]));
                        break;
                      case 1:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[1]));
                        break;
                      case 2:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[2]));
                        break;
                      case 3:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[3]));
                        break;
                      case 4:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[4]));
                        break;
                      case 5:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[5]));
                        break;
                      case 6:
                        day =
                            DateFormat.MMMd().format(DateTime.parse(dates[6]));
                        break;
                      default:
                        throw Error();
                    }
                    return BarTooltipItem(
                      day + '\n',
                      textStyle16Bold(colorIndigo),
                      children: <TextSpan>[
                        TextSpan(
                          text: (rod.y.toInt() - 1).toString(),
                          style: textStyle14Medium(colorIndigo),
                        ),
                      ],
                    );
                  }),
              touchCallback: (FlTouchEvent event, barTouchResponse) {
                setState(() {
                  if (!event.isInterestedForInteractions ||
                      barTouchResponse == null ||
                      barTouchResponse.spot == null) {
                    touchedIndexForStepsChart = -1;
                    return;
                  }
                  touchedIndexForStepsChart =
                      barTouchResponse.spot!.touchedBarGroupIndex;
                });
              },
            ),
            gridData: FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: xAxisTitleData(),
              leftTitles: yAxisTitleData(),
              rightTitles: SideTitles(showTitles: false),
              topTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
                show: true,
                border: const Border(
                    left: BorderSide.none,
                    top: BorderSide.none,
                    right: BorderSide.none,
                    bottom: BorderSide(width: 1, color: colorIndigo))),
            barGroups: showingStepsGroups()),
        swapAnimationCurve: Curves.ease,
        swapAnimationDuration: const Duration(seconds: 0),
      ),
    );
  }

  xAxisTitleData() {
    return SideTitles(
      showTitles: true,
      margin: 10,
      getTextStyles: (value, context) => textStyle12(colorIndigo),
      getTitles: (value) {
        switch (value.toInt()) {
          case 0:
            return DateFormat.MMMd().format(DateTime.parse(dates[0]));
          case 1:
            return DateFormat.MMMd().format(DateTime.parse(dates[1]));
          case 2:
            return DateFormat.MMMd().format(DateTime.parse(dates[2]));
          case 3:
            return DateFormat.MMMd().format(DateTime.parse(dates[3]));
          case 4:
            return DateFormat.MMMd().format(DateTime.parse(dates[4]));
          case 5:
            return DateFormat.MMMd().format(DateTime.parse(dates[5]));
          case 6:
            return DateFormat.MMMd().format(DateTime.parse(dates[6]));
          default:
            return '';
        }
      },
    );
  }

  yAxisTitleData() {
    return SideTitles(
        showTitles: true,
        getTextStyles: (value, context) => textStyle14Medium(colorIndigo),
        interval: 2000);
  }

  List<BarChartGroupData> showingStepsGroups() {
    List<BarChartGroupData> list = [];

    if (map!.isNotEmpty) {
      for (int i = 0; i < map!.length; i++) {
        list.add(makeBarChartGroupData(
            i, map!.entries.toList()[i].value.toDouble()));
      }
    } else {
      for (int i = 0; i < 7; i++) {
        list.add(makeBarChartGroupData(i, 0));
      }
    }
    return list;
  }

  makeBarChartGroupData(int index, double steps) {
    return BarChartGroupData(x: index, barRods: [
      BarChartRodData(
        y: steps + 1,
        colors: [colorIndigo],
        width: deviceWidth(context) * 0.11,
        borderRadius: BorderRadius.zero,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: 11000,
          colors: [colorIndigo.withOpacity(0.1)],
        ),
      ),
    ]);
  }

  getLast7DaysData() async {
    var startDate = getDate(currentDate.subtract(const Duration(days: 8)));

    for (int i = 0; i < 7; i++) {
      var date = startDate.add(const Duration(days: 1));
      dates.add(date.toString());
      startDate = date;
    }

    stepsData = await StepsDataHandler().getLast7DaysStepsData();

    for (int i = 0; i < dates.length; i++) {
      bool isMatch = false;
      for (var element in stepsData!) {
        if (element.stepDate == dates[i]) {
          isMatch = true;
          map!.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      }
      if (!isMatch) {
        map!.putIfAbsent(dates[i], () => 0);
      }
    }
    setState(() {});
  }

  getTotalLast7DaysSteps() async {
    total = await StepsDataHandler().getTotalStepsForLast7Days();
    avg = total! / 7;
    setState(() {});
  }

  buttons(String icon, [Function()? onclick]) {
    return Padding(
      padding: icon == icMoreVert
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              vertical: (deviceHeight(context) * 0.08 -
                      deviceHeight(context) * 0.042) /
                  2,
              horizontal:
                  (deviceWidth(context) * 0.18 - deviceWidth(context) * 0.085) /
                      2),
      child: GestureDetector(
        onTap: onclick,
        child: Container(
          height: deviceHeight(context) * 0.042,
          width: deviceWidth(context) * 0.085,
          decoration: decoration(5, icon),
          alignment: Alignment.center,
          child: Image.asset(icon,
              color: colorIndigo, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius, [String? icon]) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: colorIndigo.withOpacity(radius == 5 ? 0.3 : 0.15),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  totalAvg(String title, String val) {
    return Container(
      height: 70,
      width: deviceWidth(context) * 0.35,
      decoration: decoration(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: textStyle14Medium(colorIndigo)),
          const SizedBox(height: 6),
          Text(val, style: textStyle22Bold(colorIndigo)),
        ],
      ),
    );
  }
}
