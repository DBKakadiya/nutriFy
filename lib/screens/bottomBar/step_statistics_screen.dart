import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/resources/resource.dart';

import '../../handler/steps_handler.dart';
import '../../models/step_data.dart';

class StepsStatisticsScreen extends StatefulWidget {
  static const route = '/Steps-Statistics';
  final int stepCount;

  const StepsStatisticsScreen({required this.stepCount});

  @override
  State<StepsStatisticsScreen> createState() =>
      _StepsTrackerStatisticsScreenState();
}

class _StepsTrackerStatisticsScreenState extends State<StepsStatisticsScreen> {
  DateTime currentDate = DateTime.now();
  var currentMonth = DateFormat('MM').format(DateTime.now());
  var currentYear = DateFormat.y().format(DateTime.now());
  String selectedTime = 'Week';
  List<String> periodTypes = ['Week', 'Month'];

  int? daysInMonth;
  List<StepsData>? stepMonthData;
  Map<String, int> monthMap = {};

  int totalMonthSteps = 0;
  double avgMonthSteps = 0.0;

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<StepsData>? stepsWeekData;

  int totalWeekSteps = 0;
  double avgWeekSteps = 0.0;

  var currentDay = DateFormat('EEE').format(DateTime.now());

  int touchedIndexForStepsChart = -1;

  List<String> weekDates = [];
  Map<String, int> mapWeek = {};

  bool isMonth = false;
  bool isWeek = true;

  List<String> allDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> allMonths = DateFormat('EEEE').dateSymbols.MONTHS;

  int prefSelectedDay = 1;

  int _daysInMonth(final int monthNum, final int year) {
    List<int> monthLength = List.filled(12, 0, growable: true);

    monthLength[0] = 31;
    monthLength[2] = 31;
    monthLength[4] = 31;
    monthLength[6] = 31;
    monthLength[7] = 31;
    monthLength[9] = 31;
    monthLength[11] = 31;
    monthLength[3] = 30;
    monthLength[8] = 30;
    monthLength[5] = 30;
    monthLength[10] = 30;

    if (leapYear(year) == true) {
      monthLength[1] = 29;
    } else {
      monthLength[1] = 28;
    }

    return monthLength[monthNum - 1];
  }

  static bool leapYear(int year) {
    bool leapYear = false;

    bool leap = ((year % 100 == 0) && (year % 400 != 0));
    if (leap == true) {
      leapYear = false;
    } else if (year % 4 == 0) {
      leapYear = true;
    }

    return leapYear;
  }

  @override
  void initState() {
    print('--stepCount----${widget.stepCount}');
    print('--allDays----$allDays');
    setState((){
      prefSelectedDay = 1;
      daysInMonth = _daysInMonth(int.parse(currentMonth), int.parse(currentYear));
    });
    getWeekChartData();
    getWeekTotalSteps();
    getMonthChartData();
    getMonthTotalSteps();
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
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.04),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(height: 30),
              dropTitle(),
              const SizedBox(height: 40),
              Text(
                isMonth ? displayMonth() : 'This Week',
                style: textStyle18Bold(colorIndigo),
              ),
              const SizedBox(height: 15),
              isMonth ? monthView() : weekView(),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  weekAvg(
                      'Total',
                      isMonth
                          ? '$totalMonthSteps'
                          : '$totalWeekSteps'),
                  weekAvg(
                      'Average',
                      isMonth
                          ? avgMonthSteps.toStringAsFixed(2)
                          : avgWeekSteps.toStringAsFixed(2))
                ],
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  monthView() {
    return Container(
      height: 400,
      decoration: decoration(10),
      padding: EdgeInsets.symmetric(
          vertical: 12, horizontal: deviceWidth(context) * 0.015),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          height: 400,
          width: deviceWidth(context) * 3.7,
          child: BarChart(
            BarChartData(
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: colorIndigo.withOpacity(0.1),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        int day = group.x + 1;
                        return BarTooltipItem(
                          "${day.toString()} ${displayMonth()}" + '\n',
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
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: SideTitles(showTitles: false),
                  bottomTitles: xAxisTitleData(),
                  leftTitles: yAxisTitleData(),
                  rightTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(
                    show: true,
                    border: const Border(
                        left: BorderSide.none,
                        right: BorderSide.none,
                        bottom: BorderSide(width: 1, color: colorIndigo))),
                barGroups: showingStepsGroups()),
            swapAnimationCurve: Curves.ease,
            swapAnimationDuration: const Duration(seconds: 0),
          ),
        ),
      ),
    );
  }

  weekView() {
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
                    String weekDay;
                    if (allDays.isNotEmpty) {
                      weekDay = allDays[groupIndex.toInt()];
                    } else {
                      weekDay = "";
                    }
                    return BarTooltipItem(
                      weekDay + '\n',
                      textStyle14Medium(colorIndigo),
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
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              topTitles: SideTitles(showTitles: false),
              bottomTitles: xAxisTitleData(),
              leftTitles: yAxisTitleData(),
              rightTitles: SideTitles(showTitles: false),
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
        getTextStyles: isMonth
            ? (context, value) {
                if ((value.toInt() + 1) == DateTime.now().day) {
                  return textStyle12Bold(colorIndigo);
                } else {
                  return textStyle12(colorGrey);
                }
              }
            : (context, value) {
                if (allDays.isNotEmpty) {
                  if (allDays[value.toInt()] == currentDay) {
                    return textStyle12Bold(colorIndigo);
                  } else {
                    return textStyle12(colorGrey);
                  }
                } else {
                  return textStyle12(colorGrey);
                }
              },
        getTitles: isMonth
            ? (value) {
                switch (value.toInt()) {
                  case 0:
                    return '1';
                  case 1:
                    return '2';
                  case 2:
                    return '3';
                  case 3:
                    return '4';
                  case 4:
                    return '5';
                  case 5:
                    return '6';
                  case 6:
                    return '7';
                  case 7:
                    return '8';
                  case 8:
                    return '9';
                  case 9:
                    return '10';
                  case 10:
                    return '11';
                  case 11:
                    return '12';
                  case 12:
                    return '13';
                  case 13:
                    return '14';
                  case 14:
                    return '15';
                  case 15:
                    return '16';
                  case 16:
                    return '17';
                  case 17:
                    return '18';
                  case 18:
                    return '19';
                  case 19:
                    return '20';
                  case 20:
                    return '21';
                  case 21:
                    return '22';
                  case 22:
                    return '23';
                  case 23:
                    return '24';
                  case 24:
                    return '25';
                  case 25:
                    return '26';
                  case 26:
                    return '27';
                  case 27:
                    return '28';
                  case 28:
                    return '29';
                  case 29:
                    return '30';
                  case 30:
                    return '31';
                  default:
                    return '';
                }
              }
            : (double value) {
                if (allDays.isNotEmpty) {
                  if (allDays[value.toInt()] == currentDay) {
                    return 'Today';
                  } else {
                    return allDays[value.toInt()].substring(0, 3);
                  }
                } else {
                  return "";
                }
              });
  }

  yAxisTitleData() {
    return SideTitles(
        showTitles: true,
        getTextStyles: (value, context) => textStyle14(colorGrey),
        interval: 2000);
  }

  displayMonth() {
    switch (currentMonth) {
      case "01":
        return allMonths[0];
      case "02":
        return allMonths[1];
      case "03":
        return allMonths[2];
      case "04":
        return allMonths[3];
      case "05":
        return allMonths[4];
      case "06":
        return allMonths[5];
      case "07":
        return allMonths[6];
      case "08":
        return allMonths[7];
      case "09":
        return allMonths[8];
      case "10":
        return allMonths[9];
      case "11":
        return allMonths[10];
      case "12":
        return allMonths[11];
    }
  }

  List<BarChartGroupData> showingStepsGroups() {
    List<BarChartGroupData> list = [];

    if (isWeek) {
      if (mapWeek.isNotEmpty) {
        for (int i = 0; i < mapWeek.length; i++) {
          list.add(makeBarChartGroupData(
              i, mapWeek.entries.toList()[i].value.toDouble()));
        }
      } else {
        for (int i = 0; i < 7; i++) {
          list.add(makeBarChartGroupData(i, 0));
        }
      }
    } else {
      if (monthMap.isNotEmpty) {
        for (int i = 0; i < monthMap.length - 1; i++) {
          list.add(makeBarChartGroupData(
              i, monthMap.entries.toList()[i].value.toDouble()));
        }
      } else {
        for (int i = 0; i < daysInMonth!; i++) {
          list.add(makeBarChartGroupData(i, 0));
        }
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

  getMonthChartData() async {
    List<String> monthDates = [];
    var startDateOfMonth = DateTime(currentDate.year, currentDate.month, 1);

    for (int i = 0; i <= daysInMonth!; i++) {
      monthDates.add(startDateOfMonth.toString());
      var date = startDateOfMonth.add(const Duration(days: 1));
      startDateOfMonth = date;
    }
    stepMonthData = await StepsDataHandler().getStepsForCurrentMonth();

    for (int i = 0; i <= monthDates.length - 1; i++) {
      bool isMatch = false;
      for (var element in stepMonthData!) {
        if (element.stepDate == monthDates[i]) {
          isMatch = true;
          monthMap.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      }
      if (monthDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        monthMap.putIfAbsent(monthDates[i], () => widget.stepCount);
      }
      if (!isMatch) {
        monthMap.putIfAbsent(monthDates[i], () => 0);
      }
    }
    setState(() {});
  }

  getMonthTotalSteps() async {
    var totalStep = await StepsDataHandler().getTotalStepsForCurrentMonth();
    print('--==--==---totalMonthStep----$totalStep');
    setState(() {
      totalMonthSteps = totalStep! + widget.stepCount;
      avgMonthSteps = (totalMonthSteps + widget.stepCount) / daysInMonth!;
    });
  }

  getWeekChartData() async {
    allDays.clear();
    for (int i = 0; i < 7; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - prefSelectedDay))
          .add(Duration(days: i)));
      weekDates.add(currentWeekDates.toString());
      allDays.add(DateFormat('EEE').format(currentWeekDates));
    }
    stepsWeekData = await StepsDataHandler().getStepsForCurrentWeek();
    for (int i = 0; i < weekDates.length; i++) {
      bool isMatch = false;
      for (var element in stepsWeekData!) {
        if (element.stepDate == weekDates[i]) {
          isMatch = true;
          mapWeek.putIfAbsent(element.stepDate!, () => element.steps!);
        }
      }
      if (weekDates[i] == getDate(currentDate).toString()) {
        isMatch = true;
        mapWeek.putIfAbsent(weekDates[i], () => widget.stepCount);
      }
      if (!isMatch) {
        mapWeek.putIfAbsent(weekDates[i], () => 0);
      }
    }

    setState(() {});
  }

  getWeekTotalSteps() async {
    var totalStep = await StepsDataHandler().getTotalStepsForCurrentWeek();
    print('--==--==---totalWeekStep----$totalStep');
    setState(() {
      totalWeekSteps = totalStep! + widget.stepCount;
      avgWeekSteps = (totalWeekSteps + widget.stepCount) / 7;
    });
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

  dropTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 40,
          width: deviceWidth(context) * 0.3,
          decoration: decoration(5.1),
          alignment: Alignment.center,
          child: Row(
            children: [
              const Spacer(),
              Text(selectedTime, style: textStyle16Bold(colorIndigo)),
              const Spacer(),
              PopupMenuButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.arrow_drop_down,
                      color: colorIndigo, size: deviceWidth(context) * 0.08),
                  offset: Offset(-deviceWidth(context) * 0.015,
                      deviceHeight(context) * 0.055),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: colorIndigo, width: 1),
                      borderRadius: BorderRadius.circular(7)),
                  itemBuilder: (context) => List<PopupMenuItem>.generate(
                      periodTypes.length,
                      (index) => menuItem(periodTypes[index], () {
                            setState(() {
                              selectedTime = periodTypes[index];
                              if (selectedTime == 'Week') {
                                isWeek = true;
                                isMonth = false;
                              } else {
                                isMonth = true;
                                isWeek = false;
                              }
                            });
                            Navigator.of(context).pop();
                          })))
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: onClick,
          child: Container(
              height: 50,
              alignment: Alignment.center,
              color: selectedTime == title
                  ? colorIndigo.withOpacity(0.1)
                  : colorWhite,
              child: Text(title, style: textStyle16Bold(colorIndigo))),
        ));
  }

  weekAvg(String title, String val) {
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
