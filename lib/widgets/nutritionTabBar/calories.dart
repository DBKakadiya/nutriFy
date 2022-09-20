import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../blocs/date/date_bloc.dart';
import '../../blocs/date/date_state.dart';
import '../../handler/handler.dart';
import '../../models/food_data.dart';
import '../../models/meal_data.dart';
import '../../models/piechart_data.dart';
import '../../models/quickAdd_data.dart';
import '../../models/recipe_data.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';

class Calories extends StatefulWidget {
  final DateTime selectedDate;

  const Calories({required this.selectedDate});

  @override
  State<Calories> createState() => _CaloriesState();
}

class _CaloriesState extends State<Calories> {
  TooltipBehavior? _tooltipBehavior;
  DatabaseHelper helper = DatabaseHelper();
  double breakfastPercentage = 0;
  double lunchPercentage = 0;
  double dinnerPercentage = 0;
  double snackPercentage = 0;
  int totalFoodValue = 0;
  int totalBreakfastValue = 0;
  int totalLunchValue = 0;
  int totalDinnerValue = 0;
  int totalSnackValue = 0;
  int breakfastFoodVal = 0;
  int lunchFoodVal = 0;
  int dinnerFoodVal = 0;
  int snackFoodVal = 0;
  int remainingVal = 0;
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

  void getMealData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastPercentage = 0;
          lunchPercentage = 0;
          dinnerPercentage = 0;
          snackPercentage = 0;
          totalFoodValue = 0;
          totalBreakfastValue = 0;
          totalLunchValue = 0;
          totalDinnerValue = 0;
          totalSnackValue = 0;
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--meal--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            }
          }
        } else {
          print('--meal--else----remain');
          setState(() {
            remainingVal = int.parse(userData.caloriesGoal!);
          });
        }
        setState(() {
          totalBreakfastValue = breakfastFoodVal;
          totalLunchValue = lunchFoodVal;
          totalDinnerValue = dinnerFoodVal;
          totalSnackValue = snackFoodVal;
          totalFoodValue = totalBreakfastValue +
              totalLunchValue +
              totalDinnerValue +
              totalSnackValue;
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue11------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  void getRecipeData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<RecipeData>?> recipeDataList = helper.getRecipeList();
      recipeDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--recipe--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            }
          }
        }
        setState(() {
          if (breakfastFoodVal > 0) {
            totalBreakfastValue = totalBreakfastValue + breakfastFoodVal;
            totalFoodValue = totalFoodValue + totalBreakfastValue;
          }
          if (lunchFoodVal > 0) {
            totalLunchValue = totalLunchValue + lunchFoodVal;
            totalFoodValue = totalFoodValue + totalLunchValue;
          }
          if (dinnerFoodVal > 0) {
            totalDinnerValue = totalDinnerValue + dinnerFoodVal;
            totalFoodValue = totalFoodValue + totalDinnerValue;
          }
          if (snackFoodVal > 0) {
            totalSnackValue = totalSnackValue + snackFoodVal;
            totalFoodValue = totalFoodValue + totalSnackValue;
          }
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue22------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  void getFoodData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FoodData>?> foodDataList = helper.getFoodList();
      foodDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--food--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            }
          }
        }
        setState(() {
          if (breakfastFoodVal > 0) {
            totalBreakfastValue = totalBreakfastValue + breakfastFoodVal;
            totalFoodValue = totalFoodValue + totalBreakfastValue;
          }
          if (lunchFoodVal > 0) {
            totalLunchValue = totalLunchValue + lunchFoodVal;
            totalFoodValue = totalFoodValue + totalLunchValue;
          }
          if (dinnerFoodVal > 0) {
            totalDinnerValue = totalDinnerValue + dinnerFoodVal;
            totalFoodValue = totalFoodValue + totalDinnerValue;
          }
          if (snackFoodVal > 0) {
            totalSnackValue = totalSnackValue + snackFoodVal;
            totalFoodValue = totalFoodValue + totalSnackValue;
          }
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue33------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  void getQuickAddData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<QuickAddData>?> quickAddDataList = helper.getQuickAddList();
      quickAddDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--quickAdd--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            }
          }
        }
        setState(() {
          if (breakfastFoodVal > 0) {
            totalBreakfastValue = totalBreakfastValue + breakfastFoodVal;
            totalFoodValue = totalFoodValue + totalBreakfastValue;
          }
          if (lunchFoodVal > 0) {
            totalLunchValue = totalLunchValue + lunchFoodVal;
            totalFoodValue = totalFoodValue + totalLunchValue;
          }
          if (dinnerFoodVal > 0) {
            totalDinnerValue = totalDinnerValue + dinnerFoodVal;
            totalFoodValue = totalFoodValue + totalDinnerValue;
          }
          if (snackFoodVal > 0) {
            totalSnackValue = totalSnackValue + snackFoodVal;
            totalFoodValue = totalFoodValue + totalSnackValue;
          }
          remainingVal = remainingVal - totalFoodValue;
        });
        setState(() {
          if (totalFoodValue > 0) {
            breakfastPercentage = (totalBreakfastValue * 100) / totalFoodValue;
            lunchPercentage = (totalLunchValue * 100) / totalFoodValue;
            dinnerPercentage = (totalDinnerValue * 100) / totalFoodValue;
            snackPercentage = (totalSnackValue * 100) / totalFoodValue;
          }
        });
        print(
            '--totalFoodValue44------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  @override
  void initState() {
    getUserData();
    getMealData(widget.selectedDate);
    getRecipeData(widget.selectedDate);
    getFoodData(widget.selectedDate);
    getQuickAddData(widget.selectedDate);
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        color: colorWhite,
        textStyle: textStyle12(colorBlack),
        format: 'point.x: point.y%');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DateBloc, DateState>(
      listener: (context, state) {
        if (state is GetCalorieDateData) {
          getMealData(state.date);
          getRecipeData(state.date);
          getFoodData(state.date);
          getQuickAddData(state.date);
        }
      },
      builder: (context, state) => state is GetCalorieDateData
          ? commonWidget(state.date)
          : commonWidget(widget.selectedDate),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(radius));
  }

  nutritionData(String title, String value, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(colorWhite, 30),
          child: Row(
            children: [
              SizedBox(width: deviceWidth(context) * 0.04),
              Text(title, style: textStyle16Bold(colorIndigo)),
              const Spacer(),
              Text(value, style: textStyle16Bold(colorIndigo)),
              SizedBox(width: deviceWidth(context) * 0.04),
            ],
          ),
        ),
      ),
    );
  }

  commonWidget(DateTime date) {
    List<PieChartData> emptyList = [
      PieChartData(
          activity: '0', value: 100, calorie: 0, color: colorGrey.toString())
    ];
    List<PieChartData> mainList = [
      PieChartData(
          activity: 'Breakfast',
          value: double.parse(breakfastPercentage.toStringAsFixed(2)),
          calorie: totalBreakfastValue,
          color: colorBreakfast.toString()),
      PieChartData(
          activity: 'Lunch',
          value: double.parse(lunchPercentage.toStringAsFixed(2)),
          calorie: totalLunchValue,
          color: colorLunch.toString()),
      PieChartData(
          activity: 'Dinner',
          value: double.parse(dinnerPercentage.toStringAsFixed(2)),
          calorie: totalDinnerValue,
          color: colorDinner.toString()),
      PieChartData(
          activity: 'Snack',
          value: double.parse(snackPercentage.toStringAsFixed(2)),
          calorie: totalSnackValue,
          color: colorSnack.toString()),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
      child: Column(
        children: [
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: totalFoodValue > 0
                ? SfCircularChart(
                    tooltipBehavior: _tooltipBehavior,
                    series: <CircularSeries>[
                        PieSeries<PieChartData, String>(
                          dataSource: mainList,
                          radius: '70',
                          xValueMapper: (PieChartData data, _) => data.activity,
                          yValueMapper: (PieChartData data, _) => data.value,
                          pointColorMapper: (PieChartData data, _) => Color(
                              int.parse(
                                  data.color.split('(0x')[1].split(')')[0],
                                  radix: 16)),
                        )
                      ])
                : SfCircularChart(series: <CircularSeries>[
                    PieSeries<PieChartData, String>(
                      dataSource: emptyList,
                      radius: '70',
                      xValueMapper: (PieChartData data, _) => data.activity,
                      yValueMapper: (PieChartData data, _) => data.value,
                      pointColorMapper: (PieChartData data, _) => Color(
                          int.parse(data.color.split('(0x')[1].split(')')[0],
                              radix: 16)),
                    )
                  ]),
          ),
          Padding(
            padding: EdgeInsets.only(left: deviceWidth(context) * 0.225),
            child: Column(
              children: List.generate(
                  mainList.length,
                  (index) => Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceHeight(context) * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 4,
                              backgroundColor: Color(int.parse(
                                  mainList[index]
                                      .color
                                      .split('(0x')[1]
                                      .split(')')[0],
                                  radix: 16)),
                            ),
                            SizedBox(width: deviceWidth(context) * 0.03),
                            Text(
                                '${mainList[index].activity} ${mainList[index].value.toStringAsFixed(2)}% (${mainList[index].calorie} cal)',
                                style: textStyle13Medium(colorIndigo))
                          ],
                        ),
                      )),
            ),
          ),
          SizedBox(height: deviceHeight(context) * 0.03),
          nutritionData('Total Calories', '$totalFoodValue', () => null),
          nutritionData('Net Calories', '$remainingVal', () => null),
          nutritionData(
              'Goal',
              userData.caloriesGoal!.length == 4
                  ? '${userData.caloriesGoal!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}'
                  : userData.caloriesGoal!,
              () => null),
          SizedBox(height: deviceHeight(context) * 0.012),
          Container(
            height: deviceHeight(context) * 0.25,
            width: deviceWidth(context),
            decoration: BoxDecoration(
                color: colorWhite, borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: deviceHeight(context) * 0.017,
                  horizontal: deviceWidth(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Foods highest in calories',
                      style: textStyle20Bold(colorIndigo)),
                  SizedBox(height: deviceHeight(context) * 0.02),
                  Text('Rice Bowl (example)', style: textStyle13(colorIndigo)),
                  SizedBox(height: deviceHeight(context) * 0.02),
                  Text('Tomato Soup (example)',
                      style: textStyle13(colorIndigo)),
                  SizedBox(height: deviceHeight(context) * 0.02),
                  Text(
                      'Go Premium to see which of the foods you’ve logged rank highest in calories',
                      style: textStyle13(colorIndigo).copyWith(height: 1.3)),
                ],
              ),
            ),
          ),
          SizedBox(height: deviceHeight(context) * 0.05),
        ],
      ),
    );
  }
}
