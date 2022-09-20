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
import '../../models/user_data.dart';
import '../../resources/resource.dart';

class Macros extends StatefulWidget {
  final DateTime selectedDate;

  const Macros({required this.selectedDate});

  @override
  State<Macros> createState() => _MacrosState();
}

class _MacrosState extends State<Macros> {
  TooltipBehavior? _tooltipBehavior;
  DatabaseHelper helper = DatabaseHelper();
  num carbohydratesPercentage = 0;
  num proteinPercentage = 0;
  num fatPercentage = 0;
  num totalCarbohydratesValue = 0;
  num totalProteinValue = 0;
  num totalFatValue = 0;
  num carbsValue = 0;
  num proteinValue = 0;
  num fatValue = 0;
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
          carbohydratesPercentage = 0;
          proteinPercentage = 0;
          fatPercentage = 0;
          totalCarbohydratesValue = 0;
          totalProteinValue = 0;
          totalFatValue = 0;
          carbsValue = 0;
          proteinValue = 0;
          fatValue = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--meal--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('----ele11------${ele.toString()}');
              setState(() {
                carbsValue = carbsValue + int.parse(ele.carbohydrates!);
                proteinValue = proteinValue + int.parse(ele.protein!);
                fatValue = fatValue + int.parse(ele.fat!);
              });
            }
          }
        }
        setState(() {
          if (carbsValue > 0) {
            totalCarbohydratesValue = totalCarbohydratesValue + carbsValue;
          }
          if (proteinValue > 0) {
            totalProteinValue = totalProteinValue + proteinValue;
          }
          if (fatValue > 0) {
            totalFatValue = totalFatValue + fatValue;
          }
        });
        print('--carbs11---$totalCarbohydratesValue');
        print('--protein11---$totalProteinValue');
        print('--fat11---$totalFatValue');
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
          carbsValue = 0;
          proteinValue = 0;
          fatValue = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--meal--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('----ele11------${ele.toString()}');
              setState(() {
                carbsValue = carbsValue + int.parse(ele.carbohydrates!);
                proteinValue = proteinValue + int.parse(ele.protein!);
                fatValue = fatValue + int.parse(ele.fat!);
              });
            }
          }
        }
        setState(() {
          if (carbsValue > 0) {
            totalCarbohydratesValue = totalCarbohydratesValue + carbsValue;
          }
          if (proteinValue > 0) {
            totalProteinValue = totalProteinValue + proteinValue;
          }
          if (fatValue > 0) {
            totalFatValue = totalFatValue + fatValue;
          }
        });
        print('--carbs22---$totalCarbohydratesValue');
        print('--protein22---$totalProteinValue');
        print('--fat22---$totalFatValue');
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
          carbsValue = 0;
          proteinValue = 0;
          fatValue = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--meal--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('----ele11------${ele.toString()}');
              setState(() {
                carbsValue = carbsValue + double.parse(ele.carbohydrates!);
                proteinValue = proteinValue + double.parse(ele.protein!);
                fatValue = fatValue + double.parse(ele.fat!);
              });
            }
          }
        }
        setState(() {
          if (carbsValue > 0) {
            totalCarbohydratesValue = totalCarbohydratesValue + carbsValue;
          }
          if (proteinValue > 0) {
            totalProteinValue = totalProteinValue + proteinValue;
          }
          if (fatValue > 0) {
            totalFatValue = totalFatValue + fatValue;
          }
        });
        print('--carbohydrates---${userData.percentageCarbohydrates!}');
        print('--protein---${userData.protein!}');
        print('--fat---${userData.fat!}');
        setState(() {
          if (totalCarbohydratesValue > 0 || totalProteinValue > 0 || totalFatValue > 0) {
            carbohydratesPercentage = (totalCarbohydratesValue * userData.percentageCarbohydrates!) / double.parse(userData.carbohydrates!);
            proteinPercentage = (totalProteinValue * userData.percentageProtein!) / double.parse(userData.protein!);
            fatPercentage = (totalFatValue * userData.percentageFat!) / double.parse(userData.fat!);
            totalCarbohydratesValue = totalCarbohydratesValue - totalCarbohydratesValue.floor() > 0 ? totalCarbohydratesValue : totalCarbohydratesValue.toInt();
            totalProteinValue = totalProteinValue - totalProteinValue.floor() > 0 ? totalProteinValue : totalProteinValue.toInt();
            totalFatValue = totalFatValue - totalFatValue.floor() > 0 ? totalFatValue : totalFatValue.toInt();
          }
        });
        print('--carbs33---$totalCarbohydratesValue');
        print('--protein33---$totalProteinValue');
        print('--fat33---$totalFatValue');
        print('--percentageCarbs---$carbohydratesPercentage');
        print('--percentageProtein---$proteinPercentage');
        print('--percentageFat---$fatPercentage');
      });
    });
  }

  @override
  void initState() {
    getUserData();
    getMealData(widget.selectedDate);
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
        if (state is GetMacrosDateData) {
          getMealData(state.date);
          getFoodData(state.date);
          getQuickAddData(state.date);
        }
      },
      builder: (context, state) => state is GetMacrosDateData
          ? commonWidget(state.date)
          : commonWidget(widget.selectedDate),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius));
  }

  commonWidget(DateTime date){
    List<PieChartData> emptyList = [
      PieChartData(
          activity: '0', value: 100, calorie: 0, color: colorGrey.toString())
    ];
    List<PieChartData> mainList = [
      PieChartData(
          activity: 'Carbohydrates (${totalCarbohydratesValue}g)',
          value: double.parse(carbohydratesPercentage.toStringAsFixed(2)),
          calorie: 0,
          color: colorBreakfast.toString()),
      PieChartData(
          activity: 'Protein (${totalProteinValue}g)',
          value: double.parse(proteinPercentage.toStringAsFixed(2)),
          calorie: 0,
          color: colorLunch.toString()),
      PieChartData(
          activity: 'Fat (${totalFatValue}g)',
          value: double.parse(fatPercentage.toStringAsFixed(2)),
          calorie: 0,
          color: colorDinner.toString()),
    ];
    List<int> percentageGoal = [userData.percentageCarbohydrates!,userData.percentageProtein!,userData.percentageFat!];

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: deviceWidth(context) * 0.06),
      child: Column(
        children: [
          SizedBox(height: deviceHeight(context) * 0.01),
          SizedBox(
            height: 180,
            child: totalCarbohydratesValue > 0 || totalProteinValue > 0 || totalFatValue > 0
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
            padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: deviceWidth(context) * 0.5,
                ),
                Container(
                    width: deviceWidth(context) * 0.12,
                    alignment: Alignment.center,
                    child: Text('Total', style: textStyle13Bold(
                        colorIndigo))),
                Container(
                  width: deviceWidth(context) * 0.12,
                  alignment: Alignment.center,
                  child: Text('Goal', style: textStyle13Bold(
                      colorIndigo)),
                )
              ],
            ),
          ),
          SizedBox(height: deviceHeight(context) * 0.012),
          Padding(
            padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
            child: Column(
              children: List.generate(
                  mainList.length,
                      (index) =>
                      Padding(
                        padding: EdgeInsets.only(
                            bottom: deviceHeight(context) * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceEvenly,
                          children: [
                            SizedBox(
                              width: deviceWidth(context) * 0.5,
                              child: Row(
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
                                  SizedBox(width: deviceWidth(context) *
                                      0.03),
                                  Text(mainList[index]
                                      .activity,
                                      style: textStyle13Medium(
                                          colorIndigo))
                                ],
                              ),
                            ),
                            Container(
                                width: deviceWidth(context) * 0.12,
                                alignment: Alignment.center,
                                child: Text('${mainList[index].value}%',
                                    style: textStyle13Medium(
                                        colorIndigo))),
                            Container(
                              width: deviceWidth(context) * 0.12,
                              alignment: Alignment.center,
                              child: Text(
                                  '${percentageGoal[index]}%',
                                  style: textStyle13Medium(
                                      colorIndigo)),
                            )
                          ],
                        ),
                      )),
            ),
          ),
          SizedBox(height: deviceHeight(context) * 0.03),
          Container(
            height: deviceHeight(context) * 0.16,
            width: deviceWidth(context),
            decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(4)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: deviceHeight(context) * 0.017,
                  horizontal: deviceWidth(context) * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Foods highest in carbohydrates',
                      style: textStyle18Bold(colorIndigo)),
                  SizedBox(height: deviceHeight(context) * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Rice Bowl (example)',
                          style: textStyle13(colorIndigo)),
                      Text('43 g', style: textStyle13(colorIndigo)),
                    ],
                  ),
                  SizedBox(height: deviceHeight(context) * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tomato Soup (example)',
                          style: textStyle13(colorIndigo)),
                      Text('30 g', style: textStyle13(colorIndigo)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
