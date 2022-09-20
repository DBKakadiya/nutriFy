import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:nutrime/models/quickAdd_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/bottomBar/nutrition_screen.dart';
import 'package:nutrime/screens/bottomBar/step_counter_screen.dart';
import 'package:nutrime/screens/users/add_weight_screen.dart';
import 'package:nutrime/screens/users/progress_screen.dart';
import 'package:nutrime/widgets/animation_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../handler/handler.dart';
import '../../models/cardio_exercise_data.dart';
import '../../models/chart_data.dart';
import '../../models/meal_data.dart';
import '../../models/strength_exercise_data.dart';
import '../../models/user_data.dart';
import '../../models/weight_data.dart';
import '../../widgets/notes_Exercise_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  DatabaseHelper helper = DatabaseHelper();
  int foodVal = 0;
  int cardioExerciseVal = 0;
  int strengthExerciseVal = 0;
  int remainingVal = 0;
  String hour = '0';
  String min = '00';
  List<WeightData> weightData = [];
  List<ChartData> chartData = [];
  UserData userData = UserData(
      name: '',
      goalReason: '',
      activityLevel: '',
      gender: '',
      age: 0,
      dateOfBirth: '',
      country: '',
      height: '',
      weight: '',
      currentWeight: '',
      goalWeight: '',
      weeklyGoal: '',
      startDate: '',
      caloriesGoal: '',
      carbohydrates: '',
      percentageCarbohydrates: 0,
      protein: '',
      percentageProtein: 0,
      fat: '',
      percentageFat: 0,
      satFat: '',
      cholesterol: '',
      sodium: '',
      potassium: '',
      fiber: '',
      sugars: '',
      vitaminA: '',
      vitaminC: '',
      calcium: '',
      iron: '');

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
        });
      });
    });
  }

  void getWeightData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WeightData>?> userDataList = helper.getWeightList();
      userDataList.then((data) {
        setState(() {
          weightData = data!;
        });
        print('--------weightData-------$weightData');
        for (var i in weightData) {
          chartData.add(ChartData(date: i.date!, weight: int.parse(i.weight!)));
        }
      });
    });
  }

  void getMealData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          foodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    foodVal = foodVal + int.parse(i.calorie!);
                  });
                }
              }
              setState(() {
                remainingVal = int.parse(userData.caloriesGoal!) - foodVal;
              });
              print('--foodVal11----$foodVal----$remainingVal');
              break;
            }
          }
        }
      });
    });
  }

  void getRecipeData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<RecipeData>?> recipeDataList = helper.getRecipeList();
      recipeDataList.then((data) {
        print('--------data-----$data');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    foodVal = foodVal + int.parse(i.calorie!);
                  });
                }
              }
              setState(() {
                remainingVal = int.parse(userData.caloriesGoal!) - foodVal;
              });
              print('--foodVal22----$foodVal----$remainingVal');
              break;
            }
          }
        }
      });
    });
  }

  void getFoodData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FoodData>?> foodDataList = helper.getFoodList();
      foodDataList.then((data) {
        print('--------data-----$data');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    foodVal = foodVal + int.parse(i.calorie!);
                  });
                }
              }
              setState(() {
                remainingVal = int.parse(userData.caloriesGoal!) - foodVal;
              });
              print('--foodVal22----$foodVal----$remainingVal');
              break;
            }
          }
        }
      });
    });
  }

  void getQuickAddData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<QuickAddData>?> quickAddDataList = helper.getQuickAddList();
      quickAddDataList.then((data) {
        print('--------data-----$data');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    foodVal = foodVal + int.parse(i.calorie!);
                  });
                }
              }
              setState(() {
                remainingVal = int.parse(userData.caloriesGoal!) - foodVal;
              });
              print('--foodVal33----$foodVal----$remainingVal');
              break;
            }
          }
        }
      });
    });
  }

  void getCardioData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CardioData>?> userDataList = helper.getCardioExerciseList();
      userDataList.then((data) {
        print('--cardio--data-----$data');
        setState(() {
          cardioExerciseVal = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    cardioExerciseVal =
                        cardioExerciseVal + int.parse(i.calorie!);
                    min = (int.parse(min) + int.parse(i.time!)).toString();
                  });
                }
              }
              setState(() {
                remainingVal = remainingVal + cardioExerciseVal;
              });
              break;
            }
          }
        }
      });
    });
  }

  void getStrengthData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<StrengthData>?> userDataList =
          helper.getStrengthExerciseList();
      userDataList.then((data) {
        print('--strength--data-----$data');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) {
                  setState(() {
                    strengthExerciseVal =
                        strengthExerciseVal + int.parse(i.calorie!);
                    min = (int.parse(min) + int.parse(i.time!)).toString();
                  });
                }
              }
              setState(() {
                remainingVal = remainingVal + strengthExerciseVal;
              });
              var d = Duration(minutes: int.parse(min));
              List<String> parts = d.toString().split(':');
              setState(() {
                hour = parts[0].padLeft(1, '0');
                min = parts[1].padLeft(2, '0');
              });
              break;
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    getUserData();
    getWeightData();
    getMealData();
    getRecipeData();
    getFoodData();
    getQuickAddData();
    getCardioData();
    getStrengthData();
    super.initState();
  }

  navigateStep() {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return const StepCounterScreen();
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.easeOutBack;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return ScaleTransition(
          scale: animation.drive(tween),
          alignment: const Alignment(0.6, -0.5),
          child: child,
        );
      },
    ));
  }

  Future<void> _checkPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.activityRecognition.status;

      if (!status.isGranted) {
        await Permission.activityRecognition.request();
        Permission.activityRecognition.request().isGranted.then((value) {
          if (value) {
            navigateStep();
            // Navigator.of(context).pushNamed(StepCounterScreen.route);
          } else {
            stepsPermissionDialog();
          }
        });
      } else if (status.isDenied) {
        var status2 = await Permission.activityRecognition.request();
        if (!status2.isGranted) {
          stepsPermissionDialog();
        }
        return;
      } else {
        navigateStep();
        // Navigator.of(context).pushNamed(StepCounterScreen.route);
      }
    }
  }

  void stepsPermissionDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'Please give us access to Detect You Activity For Steps'),
            actions: [
              TextButton(
                child: Text(
                  'CANCEL'.toUpperCase(),
                  style: textStyle16(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  'Go to Settings'.toUpperCase(),
                  style: textStyle16(),
                ),
                onPressed: () async {
                  openAppSettings();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  calories(),
                  SizedBox(
                    height: 360,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        steps(),
                        exercise(),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Text('Progress', style: textStyle20Bold(colorIndigo)),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        progress(),
        const SizedBox(height: 15),
        SmoothPageIndicator(
          controller: controller,
          count: 2,
          effect: WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            dotColor: colorIndigo.withOpacity(0.3),
            activeDotColor: colorIndigo,
            spacing: 6,
            type: WormType.thin,
            // strokeWidth: 5,
          ),
        ),
        const SizedBox(height: 120),
      ],
    ));
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
              color: colorIndigo.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  calories() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(PageRouteBuilder(
          opaque: true,
          pageBuilder: (context, animation, secondaryAnimation) {
            return const NutritionScreen(index: 0);
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = 0.0;
            var end = 1.0;
            var curve = Curves.easeOutBack;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(tween),
              alignment: const Alignment(-0.5, -0.4),
              child: child,
            );
          },
        ));
        // Navigator.of(context).pushNamed(NutritionScreen.route, arguments: 0);
      },
      child: Container(
        height: 360,
        width: deviceWidth(context) * 0.44,
        decoration: decoration(),
        child: Padding(
          padding: EdgeInsets.all(deviceWidth(context) * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Hero(
                  tag: 'Calories',
                  child: Text('Calories', style: textStyle16Bold(colorIndigo))),
              Center(
                child: Container(
                  height: 150,
                  width: deviceWidth(context) * 0.33,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: colorIndigo.withOpacity(0.2),
                          width: deviceWidth(context) * 0.025)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          remainingVal.toString().characters.length == 4
                              ? '${remainingVal.toString().substring(0, 1)},${remainingVal.toString().substring(1)}'
                              : remainingVal.toString(),
                          style: textStyle22Bold(colorBlack)),
                      const SizedBox(
                        height: 4,
                      ),
                      Text('Remaining', style: textStyle12(colorBlack)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: deviceWidth(context) * 0.01),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(icBasicGoal,
                                width: deviceWidth(context) * 0.055),
                            SizedBox(width: deviceWidth(context) * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Basic Goal',
                                    style: textStyle12(colorBlack)),
                                const SizedBox(height: 3),
                                Text(
                                    userData.caloriesGoal
                                                .toString()
                                                .characters
                                                .length ==
                                            4
                                        ? '${userData.caloriesGoal.toString().substring(0, 1)},${userData.caloriesGoal.toString().substring(1)}'
                                        : userData.caloriesGoal.toString(),
                                    style: textStyle12Bold(colorBlack)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Image.asset(icFood,
                                width: deviceWidth(context) * 0.055),
                            SizedBox(width: deviceWidth(context) * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Food', style: textStyle12(colorBlack)),
                                const SizedBox(height: 3),
                                Text(
                                    foodVal.toString().characters.length == 4
                                        ? '${foodVal.toString().substring(0, 1)},${foodVal.toString().substring(1)}'
                                        : '$foodVal',
                                    style: textStyle12Bold(colorBlack)),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Image.asset(icExercise,
                                width: deviceWidth(context) * 0.055),
                            SizedBox(width: deviceWidth(context) * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Exercise',
                                    style: textStyle12(colorBlack)),
                                const SizedBox(height: 3),
                                Text(
                                    '${cardioExerciseVal + strengthExerciseVal}'
                                                .characters
                                                .length ==
                                            4
                                        ? '${'${cardioExerciseVal + strengthExerciseVal}'.substring(0, 1)},${'${cardioExerciseVal + strengthExerciseVal}'.toString().substring(1)}'
                                        : '${cardioExerciseVal + strengthExerciseVal}',
                                    style: textStyle12Bold(colorBlack)),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    // Expanded(child: Image.asset(icCalories))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  steps() {
    return GestureDetector(
      onTap: _checkPermission,
      child: Container(
        height: 170,
        width: deviceWidth(context) * 0.4,
        decoration: decoration(),
        child: Padding(
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.01, top: 10),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SizedBox(
                  width: deviceWidth(context) * 0.25,
                  child: Padding(
                    padding: EdgeInsets.only(left: deviceWidth(context) * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Steps', style: textStyle16Bold(colorIndigo)),
                        const SizedBox(height: 8),
                        Text('Connect to track steps',
                            textAlign: TextAlign.start,
                            style: textStyle10Light(colorIndigo)),
                      ],
                    ),
                  )),
              Positioned(
                right: deviceWidth(context) * 0.025,
                top: 5,
                child: Image.asset(icNext, width: deviceWidth(context) * 0.03),
              ),
              Positioned(
                right: 0,
                bottom: 10,
                child: Image.asset(icStepEmoji,
                    width: deviceWidth(context) * 0.12),
              )
            ],
          ),
        ),
      ),
    );
  }

  exercise() {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
                builder: (context, setState) =>
                    Dialogs(type: 'Exercise', selDate: DateTime.now()));
          }),
      // Dialogs().selectExercise(context, DateTime.now(), setState),
      child: Container(
        height: 170,
        width: deviceWidth(context) * 0.4,
        decoration: decoration(),
        child: Padding(
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.01, top: 10),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.arrow_drop_down,
                          color: colorIndigo,
                          size: deviceWidth(context) * 0.07),
                      Text('Exercise', style: textStyle16Bold(colorIndigo)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(icExercise,
                                width: deviceWidth(context) * 0.045),
                            SizedBox(width: deviceWidth(context) * 0.01),
                            Text(
                                '${cardioExerciseVal + strengthExerciseVal}'
                                            .characters
                                            .length ==
                                        4
                                    ? '${'${cardioExerciseVal + strengthExerciseVal}'.substring(0, 1)},${'${cardioExerciseVal + strengthExerciseVal}'.toString().substring(1)} cal'
                                    : '${cardioExerciseVal + strengthExerciseVal} cal',
                                style: textStyle12Medium(colorIndigo))
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Image.asset(icExercise,
                                width: deviceWidth(context) * 0.045),
                            SizedBox(width: deviceWidth(context) * 0.01),
                            Text('$hour:$min hr',
                                style: textStyle12Medium(colorIndigo))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                right: deviceWidth(context) * 0.03,
                bottom: 8,
                child: Image.asset(icExerciseGirl,
                    width: deviceWidth(context) * 0.16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  progress() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(2, (index) {
          print('-------index-==------$index');
          return Padding(
            padding: index == 0
                ? EdgeInsets.only(
                    left: deviceWidth(context) * 0.08,
                    right: deviceWidth(context) * 0.03)
                : EdgeInsets.only(
                    left: deviceWidth(context) * 0.02,
                    right: deviceWidth(context) * 0.09),
            child: GestureDetector(
              onTap: () {
                index == 0
                    ? {
                        if (weightData.length > 2)
                          {
                            Navigator.of(context)
                                .pushNamed(ProgressScreen.route)
                          }
                        else
                          {
                            Navigator.of(context).pushNamed(
                                AddWeightScreen.route,
                                arguments: 'isDashboard')
                          }
                      }
                    : _checkPermission();
              },
              child: Container(
                height: 300,
                width: deviceWidth(context) * 0.8,
                decoration: decoration(),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: deviceWidth(context) * 0.04),
                  child: index == 0
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text('Weight',
                                    style: textStyle18Bold(colorIndigo)),
                                const Spacer(),
                                if (weightData.length >= 2)
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              AddWeightScreen.route,
                                              arguments: 'isDashboard');
                                        },
                                        child: AnimationWidget(message: 'Weight', color: colorWhite, widget: Image.asset(icAddWeight, width: deviceWidth(context) * 0.07), screen: const AddWeightScreen(type: 'isDashboard')),
                                      ),
                                      SizedBox(
                                          width: deviceWidth(context) * 0.015)
                                    ],
                                  ),
                              ],
                            ),
                            if (weightData.length < 2) const Spacer(),
                            if (weightData.length < 2)
                              Image.asset(imgEmptyWeightChart,
                                  width: deviceWidth(context) * 0.45),
                            if (weightData.length < 2) const Spacer(),
                            if (weightData.length < 2)
                              Column(
                                children: [
                                  SizedBox(
                                    width: deviceWidth(context) * 0.6,
                                    child: Text(
                                        weightData.isEmpty
                                            ? 'Add Weight to see your latest progress here'
                                            : 'Add one more entry to see your progress here',
                                        textAlign: TextAlign.center,
                                        style: textStyle14Medium(colorBlack)
                                            .copyWith(height: 1.3)),
                                  ),
                                  const SizedBox(height: 15),
                                  AnimationWidget(message: 'Weight', color: colorWhite, widget: Container(
                                    height: 47,
                                    width: deviceWidth(context) * 0.5,
                                    decoration: const BoxDecoration(
                                      color: colorIndigo,
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(45),
                                          right: Radius.circular(45)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text('Update Your Weight',
                                        style: textStyle16Bold(colorWhite)),
                                  ), screen: const AddWeightScreen(type: 'isDashboard')),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            if (weightData.length >= 2)
                              const SizedBox(height: 10),
                            if (weightData.length >= 2)
                              AnimationWidget(message: 'Progress', color: colorWhite, widget: Stack(
                                children: [
                                  Container(
                                    height: 242,
                                    color: colorWhite,
                                    alignment: Alignment.center,
                                    child: SfCartesianChart(
                                        primaryXAxis: DateTimeAxis(),
                                        series: <ChartSeries>[
                                          LineSeries<ChartData, DateTime>(
                                              color: colorIndigo,
                                              dataSource: chartData,
                                              xValueMapper:
                                                  (ChartData data, _) =>
                                                  DateTime.parse(data.date),
                                              yValueMapper:
                                                  (ChartData data, _) =>
                                              data.weight)
                                        ]),
                                  ),
                                  Container(
                                    height: 242,
                                    color: Colors.transparent,
                                  )
                                ],
                              ), screen: const ProgressScreen()),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text('Steps',
                                    style: textStyle18Bold(colorIndigo)),
                              ],
                            ),
                            const Spacer(),
                            Image.asset(imgEmptyStepChart,
                                width: deviceWidth(context) * 0.55),
                            const Spacer(),
                            SizedBox(
                              width: deviceWidth(context) * 0.6,
                              child: Text('Tap to track your daily step goal',
                                  textAlign: TextAlign.center,
                                  style: textStyle14Medium(colorBlack)
                                      .copyWith(height: 1.3)),
                            ),
                            const SizedBox(height: 15),
                            GestureDetector(
                              onTap: _checkPermission,
                              child: AnimationWidget(message: 'StepCount', color: colorWhite, widget: Container(
                                height: 47,
                                width: deviceWidth(context) * 0.5,
                                decoration: const BoxDecoration(
                                  color: colorIndigo,
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(45),
                                      right: Radius.circular(45)),
                                ),
                                alignment: Alignment.center,
                                child: Text('Track Your Steps',
                                    style: textStyle16Bold(colorWhite)),
                              ), screen: const StepCounterScreen()),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
