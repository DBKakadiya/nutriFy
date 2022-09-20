import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/handler/preference.dart';
import 'package:nutrime/handler/steps_handler.dart';
import 'package:pedometer/pedometer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../models/step_data.dart';
import '../../resources/resource.dart';
import '../../widgets/debug.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';
import 'Steps_Last7Days_Screen.dart';
import 'step_statistics_screen.dart';

class StepCounterScreen extends StatefulWidget {
  static const route = '/Step-Count-Screen';

  const StepCounterScreen({Key? key}) : super(key: key);

  @override
  State<StepCounterScreen> createState() => _StepCounterScreenState();
}

class _StepCounterScreenState extends State<StepCounterScreen> {
  bool isPlay = true;

  int? targetSteps;
  TextEditingController targetStepController = TextEditingController();

  int? totalSteps = 0;
  int? currentStepCount = 0;
  int? oldStepCount;

  double? distance;
  String? duration;
  double? calories;

  int? time;
  int? oldTime;

  StreamSubscription<StepCount>? _stepCountStream;

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  List<String> weekDates = [];
  int? last7DaysSteps;

  List<String> allDaysInSingleWord = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  DateTime currentDate = DateTime.now();

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  List<StepsData>? stepsData;
  Map<String, int> map = {};

  List<double> stepsPercentValue = List.generate(7, (index) => 0);

  Future getIsPlayFromPrefs() async {
    isPlay = await SharedPreference().getPlay('play');
    print('---isPlay---$isPlay');

    if (isPlay) {
      if (currentStepCount! > 0) {
        currentStepCount = currentStepCount! - 1;
      } else {
        currentStepCount = 0;
      }
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
      countStep();
    }
  }

  editTargetStepsBottomDialog(Function() onCancel, Function() onSave) {
    Navigator.of(context).pop();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: 270,
                width: deviceWidth(context) * 0.78,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth(context) * 0.03),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: deviceHeight(context) * 0.025),
                          Center(
                            child: Text('Edit Target Steps',
                                style: textStyle20Bold(colorIndigo)),
                          ),
                          SizedBox(height: deviceHeight(context) * 0.025),
                          Text(
                              'Burned calories, walking distance & duration will be calculated accordingly.',
                              style: textStyle14Medium(colorIndigo)
                                  .copyWith(height: 1.3)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth(context) * 0.03),
                      child: Row(children: [
                        Text(
                          'Steps :  ',
                          style: textStyle18Bold(colorIndigo),
                        ),
                        Container(
                          height: 60,
                          width: deviceWidth(context) * 0.35,
                          decoration: const BoxDecoration(
                              color: colorBG,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          alignment: Alignment.center,
                          child: TextFormField(
                            autofocus: true,
                            controller: targetStepController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(7),
                            ],
                            style:
                                textStyle26Bold(colorIndigo.withOpacity(0.6)),
                            cursorColor: colorIndigo,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        cancelSave('CANCEL', onCancel),
                        Container(
                          height: deviceHeight(context) * 0.07,
                          width: deviceWidth(context) * 0.005,
                          color: colorWhite,
                        ),
                        cancelSave('SAVE', onSave),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }).whenComplete(() {
      getStepsDataForCurrentWeek();
      FocusScope.of(context).unfocus();
    });
  }

  countStep() {
    _stepCountStream = Pedometer.stepCountStream.listen((value) {
      if (!mounted) {
        totalSteps = value.steps;
        SharedPreference().storeIntValue('totalSteps', totalSteps);

        currentStepCount = currentStepCount! + 1;
        print('---currentStep11-----$currentStepCount');
        SharedPreference().storeIntValue('currentSteps', currentStepCount);
      } else {
        setState(() {
          totalSteps = value.steps;
          SharedPreference().storeIntValue('totalSteps', totalSteps);

          currentStepCount = currentStepCount! + 1;
          print('---currentStep22-----$currentStepCount');
          SharedPreference().storeIntValue('currentSteps', currentStepCount);
        });
      }
      calculateDistance();
      calculateCalories();
      getTodayStepsPercent();
    }, onError: (error) {
      totalSteps = 0;
      Debug.printLog("Error: $error");
    }, cancelOnError: false);
  }

  getTodayStepsPercent() {
    var todayDate = getDate(DateTime.now()).toString();
    for (int i = 0; i < weekDates.length; i++) {
      if (todayDate == weekDates[i]) {
        print('--Today--==---');
        if (!mounted) {
          double value = currentStepCount!.toDouble() / targetSteps!.toDouble();
          if (value <= 1.0) {
            if (stepsPercentValue.isNotEmpty) {
              stepsPercentValue[i] = value;
            }
          } else {
            stepsPercentValue[i] = 1.0;
          }
        } else {
          print('--=currentStepCount=--$currentStepCount');
          print('--=targetSteps=--$targetSteps');
          setState(() {
            double value =
                currentStepCount!.toDouble() / targetSteps!.toDouble();
            print('--=x=--$value');
            if (value <= 1.0) {
              if (stepsPercentValue.isNotEmpty) {
                stepsPercentValue[i] = value;
              }
            } else {
              stepsPercentValue[i] = 1.0;
            }
          });
        }
      }
    }
  }

  Future getPreference() async {
    targetSteps = await SharedPreference().getTargetStep('targetSteps');
    oldTime = await SharedPreference().getOldTime('oldTime');
    currentStepCount = await SharedPreference().getCurrentStep('currentSteps');
    duration = await SharedPreference().getDuration('duration');
    distance = await SharedPreference().getDistance('oldDistance');
    calories = await SharedPreference().getCalories('oldCalories');
    setState(() {
      targetStepController.text = targetSteps!.toString();
    });
    targetStepController.selection = TextSelection.fromPosition(
        TextPosition(offset: targetStepController.text.length));

    print('---targetSteps---$targetSteps');
    print('---oldTime---$oldTime');
    print('---currentStepCount---$currentStepCount');
    print('---duration---$duration');
    print('---distance---$distance');
    print('---calories---$calories');
  }

  resetData() {
    setState(() async {
      totalSteps = await SharedPreference().getTotalStep('totalSteps') ?? 0;
      oldStepCount = await SharedPreference().getTotalStep('totalSteps') ?? 0;
      if (totalSteps != null) {
        currentStepCount = totalSteps! - oldStepCount!;
      } else {
        currentStepCount = 0;
      }
      distance = 0;
      calories = 0;
      oldTime = 0;
      _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    });
    print('---totalSteps---$totalSteps');
    print('---oldStepCount---$oldStepCount');
    print('--==--currentStepCount--$currentStepCount');
    print('--==--distance--$distance');
    print('--==--calories--$calories');
    print('--==--oldTime--$oldTime');
    print('--==--stopWatchTimer--${_stopWatchTimer.minuteTime}');
    SharedPreference().storeIntValue('currentSteps', currentStepCount);
    SharedPreference().storeDoubleValue('oldDistance', distance);
    SharedPreference().storeDoubleValue('oldCalories', calories);

    if (isPlay) _stopWatchTimer.onExecute.add(StopWatchExecute.start);

    var todayDate = getDate(DateTime.now()).toString();
    print('----weekDates-----$weekDates');
    for (int i = 0; i < weekDates.length; i++) {
      if (todayDate == weekDates[i]) {
        print('------isMatch');
        print('--=x=--$i----${stepsPercentValue.length}');
        print('----list-----$stepsPercentValue');
        setState(() {
          stepsPercentValue[i] = 0;
        });
      }
    }
  }

  Future calculateDistance() async {
    if (!mounted) {
      distance = currentStepCount! * 0.0008 * 0.6214;
      SharedPreference().storeDoubleValue('oldDistance', distance);
    } else {
      setState(() {
        distance = currentStepCount! * 0.0008 * 0.6214;
        SharedPreference().storeDoubleValue('oldDistance', distance);
      });
    }
  }

  calculateCalories() {
    if (!mounted) {
      calories = currentStepCount! * 0.04;
      SharedPreference().storeDoubleValue('oldCalories', calories);
    } else {
      setState(() {
        calories = currentStepCount! * 0.04;
        SharedPreference().storeDoubleValue('oldCalories', calories);
      });
    }
  }

  Future setTime() async {
    DateTime? oldDate;
    var date = await SharedPreference().getDate('date');
    setState(() {});
    if (date != null) {
      oldDate = DateTime.parse(date);
    }
    print('---oldDate---$oldDate');

    DateTime currentDate = getDate(DateTime.now());
    await SharedPreference().storeStringValue('date', currentDate.toString());

    if (oldDate != null) {
      print('--xx--$currentDate---$oldDate-----${currentDate != oldDate}');
      if (currentDate != oldDate) {
        DateTime dateTime = DateTime.now();
        StepsDataHandler().insertSteps(StepsData(
            steps: currentStepCount,
            targetSteps: targetSteps ?? 6000,
            calorie: calories!.toInt(),
            distance: distance,
            duration: duration,
            time: DateFormat.jm().format(DateTime.now()),
            stepDate: oldDate.toString(),
            dateTime:
                "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString()}-${dateTime.minute.toString()}-${dateTime.second.toString()}"));
        resetData();
      }
    }
  }

  Future getStepsDataForCurrentWeek() async {
    for (int i = 0; i < 7; i++) {
      var currentWeekDates = getDate(DateTime.now()
          .subtract(Duration(days: currentDate.weekday - 1))
          .add(Duration(days: i)));
      weekDates.add(currentWeekDates.toString());
    }
    stepsData = await StepsDataHandler().getStepsForCurrentWeek();

    for (int i = 0; i < weekDates.length; i++) {
      bool isMatch = false;
      for (var element in stepsData!) {
        if (element.stepDate == weekDates[i]) {
          isMatch = true;
          setState(() {
            double value = element.steps!.toDouble() / targetSteps!.toDouble();
            if (value <= 1.0) {
              stepsPercentValue.add(value);
            } else {
              stepsPercentValue.add(1.0);
            }
          });
        }
      }
      if (!isMatch) {
        setState(() {
          stepsPercentValue.add(0.0);
        });
      }
    }
    getTodayStepsPercent();
  }

  getLast7DaysSteps() async {
    last7DaysSteps = await StepsDataHandler().getTotalStepsForLast7Days();
    setState(() {});
  }

  @override
  void initState() {
    getPreference().whenComplete(() => getIsPlayFromPrefs().whenComplete(() =>
        setTime().whenComplete(() => calculateDistance().whenComplete(() =>
            StepsDataHandler().getAllStepsData().whenComplete(() =>
                getStepsDataForCurrentWeek().whenComplete(() => getLast7DaysSteps()))))));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.18,
        leading: buttons(
            icBack,
            () => Navigator.of(context).pop()),
        title: Text('Step Counter', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.03),
            child: PopupMenuButton(
                icon: buttons(icMoreVert),
                offset: Offset(-deviceWidth(context) * 0.02,
                    deviceHeight(context) * 0.065),
                elevation: 3,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: colorIndigo, width: 1),
                    borderRadius: BorderRadius.circular(7)),
                itemBuilder: (context) => [
                      menuItem('Reset', () {
                        Navigator.of(context).pop();
                        resetData();
                      }),
                      menuItem('Edit Target Steps', () {
                        editTargetStepsBottomDialog(() {
                          Navigator.of(context).pop();
                        }, () async {
                          if (targetSteps! > 50) {
                            setState(() {
                              targetSteps =
                                  int.parse(targetStepController.text);
                            });
                            await SharedPreference()
                                .storeIntValue('targetSteps', targetSteps);
                            Navigator.of(context).pop();
                          } else {
                            ErrorDialog().errorDialog(
                                context, 'Please enter more than 50 steps.');
                          }
                        });
                      }),
                    ]),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05),
          child: Column(
            children: [
              const SizedBox(height: 30),
              buildStepIndicatorRow(),
              const SizedBox(height: 40),
              Container(
                height: 100,
                width: deviceWidth(context),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: colorIndigo, width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[0],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[1]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[1],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[0]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[2],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[2]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[3],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[3]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[4],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[4]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[5],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[5]
                            : 0.0),
                    buildWeekCircularIndicator(
                        allDaysInSingleWord[6],
                        stepsPercentValue.isNotEmpty
                            ? stepsPercentValue[6]
                            : 0.0),
                  ],
                ),
              ),
              const SizedBox(height: 55),
              otherInfo(),
              const SizedBox(height: 55),
              weeklyAverage(),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
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
              color: colorIndigo,
              width: icon == icBack
                  ? deviceWidth(context) * 0.04
                  : icon == icMoreVert || icon == icStatistics
                      ? deviceWidth(context) * 0.05
                      : deviceWidth(context) * 0.035),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius, [String? icon]) {
    return BoxDecoration(
        color: icon == icBack || icon == icMoreVert
            ? colorWhite
            : colorIndigo.withOpacity(0.15),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (radius == 5 && icon == icBack)
            BoxShadow(
                color: colorIndigo.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(2, 2)),
        ]);
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: onClick,
      child: Text(title, style: textStyle16Medium(colorIndigo)),
    ));
  }

  Widget cancelSave(String text, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Expanded(
        child: Container(
          height: deviceHeight(context) * 0.07,
          width: ((deviceWidth(context) * 0.78) / 2) -
              deviceWidth(context) * 0.0025,
          decoration: BoxDecoration(
              color: colorIndigo.withOpacity(0.2),
              borderRadius: text == 'SAVE'
                  ? const BorderRadius.only(bottomRight: Radius.circular(20))
                  : const BorderRadius.only(bottomLeft: Radius.circular(20))),
          alignment: Alignment.center,
          child: Text(text,
              style:
                  textStyle16Bold(text == 'SAVE' ? colorIndigo : colorWhite)),
        ),
      ),
    );
  }

  stepsIndicator() {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          showTicks: false,
          showLabels: false,
          minimum: 0,
          maximum: targetSteps!.toDouble(),
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: colorIndigo.withOpacity(0.15),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: currentStepCount!.toDouble(),
              gradient: const SweepGradient(colors: [colorIndigo]),
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            ),
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentStepCount.toString(),
                      style: textStyle44Bold(colorIndigo),
                    ),
                    Text(
                      "/$targetSteps",
                      style: textStyle14Medium(colorIndigo),
                    ),
                  ],
                ))
          ])
    ]);
  }

  buildStepIndicatorRow() {
    return Container(
      height: 250,
      width: deviceWidth(context),
      decoration: BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
                color: colorGrey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(2, 2))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttons(isPlay ? icPause : icPlay, () async {
            setState(() {
              isPlay = !isPlay;
            });
            print('---play---$isPlay');
            await SharedPreference().storeBoolValue('play', isPlay);
            if (isPlay) {
              print('-----if--play---$isPlay');
              if (currentStepCount! > 0) {
                print('--->0---$currentStepCount');
                setState(() {
                  currentStepCount = currentStepCount! - 1;
                });
              } else {
                setState(() {
                  currentStepCount = 0;
                });
              }
              _stopWatchTimer.onExecute.add(StopWatchExecute.start);
              countStep();
            } else {
              print('-----else--play---$isPlay');
              _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
              _stepCountStream!.cancel();
            }
          }),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 200,
                width: deviceWidth(context) * 0.5,
                child: stepsIndicator(),
              ),
              isPlay
                  ? Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        color: colorWhite,
                        border: Border.all(color: colorIndigo, width: 1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Steps',
                        style: textStyle14Bold(colorIndigo),
                      ))
                  : Container(
                      height: 30,
                      width: 80,
                      decoration: BoxDecoration(
                        color: colorIndigo,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Paused',
                          overflow: TextOverflow.ellipsis,
                          style: textStyle12(colorWhite),
                        ),
                      ),
                    )
            ],
          ),
          buttons(icStatistics, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        StepsStatisticsScreen(stepCount: currentStepCount!)));
          })
        ],
      ),
    );
  }

  buildWeekCircularIndicator(String weekDay, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 33,
          width: 33,
          child: CircularProgressIndicator(
            value: value,
            valueColor: const AlwaysStoppedAnimation(colorIndigo),
            backgroundColor: colorIndigo.withOpacity(0.2),
          ),
        ),
        Text(
          weekDay,
          style: textStyle12Medium(colorIndigo),
        ),
      ],
    );
  }

  otherInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                builder: (context, snapshot) {
                  time = snapshot.hasData ? snapshot.data! + oldTime! : 0;
                  SharedPreference().storeIntValue('oldTime', time);

                  duration = StopWatchTimer.getDisplayTime(
                    time!,
                    hours: true,
                    minute: true,
                    second: false,
                    milliSecond: false,
                    hoursRightBreak: "h ",
                  );
                  // print('--duration------------$duration');
                  SharedPreference().storeStringValue('duration', duration);
                  return Text(
                    duration! + "m",
                    style:
                        textStyle32Bold(colorIndigo).copyWith(letterSpacing: 1),
                  );
                }),
            const SizedBox(height: 3),
            Text(
              'Duration',
              style: textStyle14Medium(colorIndigo),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              calories!.toStringAsFixed(0),
              style: textStyle32Bold(colorIndigo).copyWith(letterSpacing: 1),
            ),
            const SizedBox(height: 3),
            Text(
              'Kcal',
              style: textStyle14Medium(colorIndigo),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              distance!.toStringAsFixed(2),
              style: textStyle32Bold(colorIndigo).copyWith(letterSpacing: 1),
            ),
            const SizedBox(height: 3),
            Text(
              'Km',
              style: textStyle14Medium(colorIndigo),
            ),
          ],
        ),
      ],
    );
  }

  weeklyAverage() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(StepsLast7DaysScreen.route);
      },
      child: Container(
        height: 60,
        width: deviceWidth(context) * 0.75,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(30), right: Radius.circular(30)),
            color: colorWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: deviceWidth(context) * 0.05),
            Text(
              'Last 7 Days Steps',
              style: textStyle18Bold(colorIndigo),
            ),
            // Text(
            //   last7DaysSteps != null ? ' ($last7DaysSteps)' : " (0)",
            //   style: textStyle20Medium(colorIndigo),
            // ),
            const Spacer(),
            Container(
                height: 60,
                width: 55,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: colorIndigo),
                alignment: Alignment.center,
                child: Image.asset(
                  icNext,
                  color: colorWhite,
                  width: deviceWidth(context) * 0.05,
                ))
          ],
        ),
      ),
    );
  }
}
