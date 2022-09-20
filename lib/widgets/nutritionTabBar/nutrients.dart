import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/date/date_bloc.dart';
import '../../blocs/date/date_state.dart';
import '../../handler/handler.dart';
import '../../models/food_data.dart';
import '../../models/meal_data.dart';
import '../../models/quickAdd_data.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';

class Nutrients extends StatefulWidget {
  final DateTime selectedDate;

  const Nutrients({required this.selectedDate});

  @override
  State<Nutrients> createState() => _NutrientsState();
}

class _NutrientsState extends State<Nutrients> {
  DatabaseHelper helper = DatabaseHelper();
  num totalCarbohydratesValue = 0;
  num totalProteinValue = 0;
  num totalFatValue = 0;
  num totalSatFatValue = 0;
  num totalCholesterolValue = 0;
  num totalPotassiumValue = 0;
  num totalFiberValue = 0;
  num totalSodiumValue = 0;
  num totalSugarValue = 0;
  num totalCalciumValue = 0;
  num totalIronValue = 0;
  num totalVitaminAValue = 0;
  num totalVitaminCValue = 0;
  num carbsValue = 0;
  num proteinValue = 0;
  num fatValue = 0;
  num satFatValue = 0;
  num cholesterolValue = 0;
  num potassiumValue = 0;
  num fiberValue = 0;
  num sodiumValue = 0;
  num sugarValue = 0;
  num calciumValue = 0;
  num ironValue = 0;
  num vitaminAValue = 0;
  num vitaminCValue = 0;
  num leftCarbohydratesValue = 0;
  num leftProteinValue = 0;
  num leftFatValue = 0;
  num leftSatFatValue = 0;
  num leftCholesterolValue = 0;
  num leftPotassiumValue = 0;
  num leftFiberValue = 0;
  num leftSodiumValue = 0;
  num leftSugarValue = 0;
  num leftCalciumValue = 0;
  num leftIronValue = 0;
  num leftVitaminAValue = 0;
  num leftVitaminCValue = 0;
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
          totalCarbohydratesValue = 0;
          totalProteinValue = 0;
          totalFatValue = 0;
          totalSatFatValue = 0;
          totalCholesterolValue = 0;
          totalPotassiumValue = 0;
          totalFiberValue = 0;
          totalSodiumValue = 0;
          totalSugarValue = 0;
          totalCalciumValue = 0;
          totalIronValue = 0;
          totalVitaminAValue = 0;
          totalVitaminCValue = 0;
          carbsValue = 0;
          proteinValue = 0;
          fatValue = 0;
          satFatValue = 0;
          cholesterolValue = 0;
          potassiumValue = 0;
          fiberValue = 0;
          sodiumValue = 0;
          sugarValue = 0;
          calciumValue = 0;
          ironValue = 0;
          vitaminAValue = 0;
          vitaminCValue = 0;
          leftCarbohydratesValue = double.parse(userData.carbohydrates!);
          leftProteinValue = double.parse(userData.protein!);
          leftFatValue = double.parse(userData.fat!);
          leftSatFatValue = double.parse(userData.satFat!);
          leftCholesterolValue = double.parse(userData.cholesterol!);
          leftPotassiumValue = double.parse(userData.potassium!);
          leftFiberValue = double.parse(userData.fiber!);
          leftSodiumValue = double.parse(userData.sodium!);
          leftSugarValue = double.parse(userData.sugars!);
          leftCalciumValue = double.parse(userData.calcium!);
          leftIronValue = double.parse(userData.iron!);
          leftVitaminAValue = double.parse(userData.vitaminA!);
          leftVitaminCValue = double.parse(userData.vitaminC!);
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
                if (ele.satFat!.isNotEmpty) {
                  satFatValue = satFatValue + int.parse(ele.satFat!);
                }
                if (ele.cholesterol!.isNotEmpty) {
                  cholesterolValue =
                      cholesterolValue + int.parse(ele.cholesterol!);
                }
                if (ele.potassium!.isNotEmpty) {
                  potassiumValue = potassiumValue + int.parse(ele.potassium!);
                }
                if (ele.fiber!.isNotEmpty) {
                  fiberValue = fiberValue + int.parse(ele.fiber!);
                }
                if (ele.sodium!.isNotEmpty) {
                  sodiumValue = sodiumValue + int.parse(ele.sodium!);
                }
                if (ele.sugar!.isNotEmpty) {
                  sugarValue = sugarValue + int.parse(ele.sugar!);
                }
                if (ele.calcium!.isNotEmpty) {
                  calciumValue = calciumValue + int.parse(ele.calcium!);
                }
                if (ele.iron!.isNotEmpty) {
                  ironValue = ironValue + int.parse(ele.iron!);
                }
                if (ele.vitaminA!.isNotEmpty) {
                  vitaminAValue = vitaminAValue + int.parse(ele.vitaminA!);
                }
                if (ele.vitaminC!.isNotEmpty) {
                  vitaminCValue = vitaminCValue + int.parse(ele.vitaminC!);
                }
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
          if (satFatValue > 0) {
            totalSatFatValue = totalSatFatValue + satFatValue;
          }
          if (cholesterolValue > 0) {
            totalCholesterolValue = totalCholesterolValue + cholesterolValue;
          }
          if (potassiumValue > 0) {
            totalPotassiumValue = totalPotassiumValue + potassiumValue;
          }
          if (fiberValue > 0) {
            totalFiberValue = totalFiberValue + fiberValue;
          }
          if (sodiumValue > 0) {
            totalSodiumValue = totalSodiumValue + sodiumValue;
          }
          if (sugarValue > 0) {
            totalSugarValue = totalSugarValue + sugarValue;
          }
          if (calciumValue > 0) {
            totalCalciumValue = totalCalciumValue + calciumValue;
          }
          if (ironValue > 0) {
            totalIronValue = totalIronValue + ironValue;
          }
          if (vitaminAValue > 0) {
            totalVitaminAValue = totalVitaminAValue + vitaminAValue;
          }
          if (vitaminCValue > 0) {
            totalVitaminCValue = totalVitaminCValue + vitaminCValue;
          }
        });
        print('--carbs11---$totalCarbohydratesValue');
        print('--protein11---$totalProteinValue');
        print('--fat11---$totalFatValue');
        print('--satFat11---$totalSatFatValue');
        print('--cholesterol11---$totalCholesterolValue');
        print('--potassium11---$totalPotassiumValue');
        print('--fiber11---$totalFiberValue');
        print('--sodium11---$totalSodiumValue');
        print('--sugar11---$totalSugarValue;');
        print('--calcium11---$totalCalciumValue');
        print('--iron11---$totalIronValue');
        print('--vitaminA11---$totalVitaminAValue');
        print('--vitaminC11---$totalVitaminCValue');
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
          satFatValue = 0;
          cholesterolValue = 0;
          potassiumValue = 0;
          fiberValue = 0;
          sodiumValue = 0;
          sugarValue = 0;
          calciumValue = 0;
          ironValue = 0;
          vitaminAValue = 0;
          vitaminCValue = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--food--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('----ele11------${ele.toString()}');
              setState(() {
                carbsValue = carbsValue + int.parse(ele.carbohydrates!);
                proteinValue = proteinValue + int.parse(ele.protein!);
                fatValue = fatValue + int.parse(ele.fat!);
                if (ele.satFat!.isNotEmpty) {
                  satFatValue = satFatValue + int.parse(ele.satFat!);
                }
                if (ele.cholesterol!.isNotEmpty) {
                  cholesterolValue =
                      cholesterolValue + int.parse(ele.cholesterol!);
                }
                if (ele.potassium!.isNotEmpty) {
                  potassiumValue = potassiumValue + int.parse(ele.potassium!);
                }
                if (ele.fiber!.isNotEmpty) {
                  fiberValue = fiberValue + int.parse(ele.fiber!);
                }
                if (ele.sodium!.isNotEmpty) {
                  sodiumValue = sodiumValue + int.parse(ele.sodium!);
                }
                if (ele.sugar!.isNotEmpty) {
                  sugarValue = sugarValue + int.parse(ele.sugar!);
                }
                if (ele.calcium!.isNotEmpty) {
                  calciumValue = calciumValue + int.parse(ele.calcium!);
                }
                if (ele.iron!.isNotEmpty) {
                  ironValue = ironValue + int.parse(ele.iron!);
                }
                if (ele.vitaminA!.isNotEmpty) {
                  vitaminAValue = vitaminAValue + int.parse(ele.vitaminA!);
                }
                if (ele.vitaminC!.isNotEmpty) {
                  vitaminCValue = vitaminCValue + int.parse(ele.vitaminC!);
                }
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
          if (satFatValue > 0) {
            totalSatFatValue = totalSatFatValue + satFatValue;
          }
          if (cholesterolValue > 0) {
            totalCholesterolValue = totalCholesterolValue + cholesterolValue;
          }
          if (potassiumValue > 0) {
            totalPotassiumValue = totalPotassiumValue + potassiumValue;
          }
          if (fiberValue > 0) {
            totalFiberValue = totalFiberValue + fiberValue;
          }
          if (sodiumValue > 0) {
            totalSodiumValue = totalSodiumValue + sodiumValue;
          }
          if (sugarValue > 0) {
            totalSugarValue = totalSugarValue + sugarValue;
          }
          if (calciumValue > 0) {
            totalCalciumValue = totalCalciumValue + calciumValue;
          }
          if (ironValue > 0) {
            totalIronValue = totalIronValue + ironValue;
          }
          if (vitaminAValue > 0) {
            totalVitaminAValue = totalVitaminAValue + vitaminAValue;
          }
          if (vitaminCValue > 0) {
            totalVitaminCValue = totalVitaminCValue + vitaminCValue;
          }
        });
        print('--carbs22---$totalCarbohydratesValue');
        print('--protein22---$totalProteinValue');
        print('--fat22---$totalFatValue');
        print('--satFat22---$totalSatFatValue');
        print('--cholesterol22---$totalCholesterolValue');
        print('--potassium22---$totalPotassiumValue');
        print('--fiber22---$totalFiberValue');
        print('--sodium22---$totalSodiumValue');
        print('--sugar22---$totalSugarValue;');
        print('--calcium22---$totalCalciumValue');
        print('--iron22---$totalIronValue');
        print('--vitaminA22---$totalVitaminAValue');
        print('--vitaminC22---$totalVitaminCValue');
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
        print('--carbohydrates---${userData.percentageCarbohydrates!}');
        print('--protein---${userData.protein!}');
        print('--fat---${userData.fat!}');
        setState(() {
          if (totalCarbohydratesValue > 0 ||
              totalProteinValue > 0 ||
              totalFatValue > 0 ||
              totalSatFatValue > 0 ||
              totalCholesterolValue > 0 ||
              totalPotassiumValue > 0 ||
              totalFiberValue > 0 ||
              totalSodiumValue > 0 ||
              totalSugarValue > 0 ||
              totalCalciumValue > 0 ||
              totalIronValue > 0 ||
              totalVitaminAValue > 0 ||
              totalVitaminCValue > 0) {
            print('----isNotEmpty');
            totalCarbohydratesValue = totalCarbohydratesValue - totalCarbohydratesValue.floor() > 0 ? totalCarbohydratesValue : totalCarbohydratesValue.toInt();
            totalProteinValue = totalProteinValue - totalProteinValue.floor() > 0 ? totalProteinValue : totalProteinValue.toInt();
            totalFatValue = totalFatValue - totalFatValue.floor() > 0 ? totalFatValue : totalFatValue.toInt();
            totalSatFatValue = totalSatFatValue - totalSatFatValue.floor() > 0 ? totalSatFatValue : totalSatFatValue.toInt();
            totalCholesterolValue = totalCholesterolValue - totalCholesterolValue.floor() > 0 ? totalCholesterolValue : totalCholesterolValue.toInt();
            totalPotassiumValue = totalPotassiumValue - totalPotassiumValue.floor() > 0 ? totalPotassiumValue : totalPotassiumValue.toInt();
            totalFiberValue = totalFiberValue - totalFiberValue.floor() > 0 ? totalFiberValue : totalFiberValue.toInt();
            totalSodiumValue = totalSodiumValue - totalSodiumValue.floor() > 0 ? totalSodiumValue : totalSodiumValue.toInt();
            totalSugarValue = totalSugarValue - totalSugarValue.floor() > 0 ? totalSugarValue : totalSugarValue.toInt();
            totalCalciumValue = totalCalciumValue - totalCalciumValue.floor() > 0 ? totalCalciumValue : totalCalciumValue.toInt();
            totalIronValue = totalIronValue - totalIronValue.floor() > 0 ? totalIronValue : totalIronValue.toInt();
            totalVitaminAValue = totalVitaminAValue - totalVitaminAValue.floor() > 0 ? totalVitaminAValue : totalVitaminAValue.toInt();
            totalVitaminCValue = totalVitaminCValue - totalVitaminCValue.floor() > 0 ? totalVitaminCValue : totalVitaminCValue.toInt();
            leftCarbohydratesValue =
                double.parse(userData.carbohydrates!) - totalCarbohydratesValue;
            leftProteinValue = double.parse(userData.protein!) - totalProteinValue;
            leftFatValue = double.parse(userData.fat!) - totalFatValue;
            leftSatFatValue = double.parse(userData.satFat!) - totalSatFatValue;
            leftCholesterolValue =
                double.parse(userData.cholesterol!) - totalCholesterolValue;
            leftPotassiumValue =
                double.parse(userData.potassium!) - totalPotassiumValue;
            leftFiberValue = double.parse(userData.fiber!) - totalFiberValue;
            leftSodiumValue = double.parse(userData.sodium!) - totalSodiumValue;
            leftSugarValue = double.parse(userData.sugars!) - totalSugarValue;
            leftCalciumValue = double.parse(userData.calcium!) - totalCalciumValue;
            leftIronValue = double.parse(userData.iron!) - totalIronValue;
            leftVitaminAValue =
                double.parse(userData.vitaminA!) - totalVitaminAValue;
            leftVitaminCValue =
                double.parse(userData.vitaminC!) - totalVitaminCValue;
          }
          leftCarbohydratesValue = leftCarbohydratesValue - leftCarbohydratesValue.floor() > 0 ? leftCarbohydratesValue : leftCarbohydratesValue.toInt();
          leftProteinValue = leftProteinValue - leftProteinValue.floor() > 0 ? leftProteinValue : leftProteinValue.toInt();
          leftFatValue = leftFatValue - leftFatValue.floor() > 0 ? leftFatValue : leftFatValue.toInt();
          leftSatFatValue = leftSatFatValue - leftSatFatValue.floor() > 0 ? leftSatFatValue : leftSatFatValue.toInt();
          leftCholesterolValue = leftCholesterolValue - leftCholesterolValue.floor() > 0 ? leftCholesterolValue : leftCholesterolValue.toInt();
          leftPotassiumValue = leftPotassiumValue - leftPotassiumValue.floor() > 0 ? leftPotassiumValue : leftPotassiumValue.toInt();
          leftFiberValue = leftFiberValue - leftFiberValue.floor() > 0 ? leftFiberValue : leftFiberValue.toInt();
          leftSodiumValue = leftSodiumValue - leftSodiumValue.floor() > 0 ? leftSodiumValue : leftSodiumValue.toInt();
          leftSugarValue = leftSugarValue - leftSugarValue.floor() > 0 ? leftSugarValue : leftSugarValue.toInt();
          leftCalciumValue = leftCalciumValue - leftCalciumValue.floor() > 0 ? leftCalciumValue : leftCalciumValue.toInt();
          leftIronValue = leftIronValue - leftIronValue.floor() > 0 ? leftIronValue : leftIronValue.toInt();
          leftVitaminAValue = leftVitaminAValue - leftVitaminAValue.floor() > 0 ? leftVitaminAValue : leftVitaminAValue.toInt();
          leftVitaminCValue = leftVitaminCValue - leftVitaminCValue.floor() > 0 ? leftVitaminCValue : leftVitaminCValue.toInt();
        });
        print('--carbs33---$totalCarbohydratesValue');
        print('--protein33---$totalProteinValue');
        print('--fat33---$totalFatValue');
      });
    });
  }

  @override
  void initState() {
    getUserData();
    getMealData(widget.selectedDate);
    getFoodData(widget.selectedDate);
    getQuickAddData(widget.selectedDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DateBloc, DateState>(
      listener: (context, state) {
        if (state is GetNutrientDateData) {
          getMealData(state.date);
          getFoodData(state.date);
          getQuickAddData(state.date);
        }
      },
      builder: (context, state) => state is GetNutrientDateData
          ? commonWidget(state.date)
          : commonWidget(widget.selectedDate),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: color, borderRadius: BorderRadius.circular(radius));
  }

  nutritionData(String title, num totalValue, String leftValue,
      String goalValue, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(colorWhite, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                  width: deviceWidth(context) * 0.4,
                  child: Text(title, style: textStyle14Bold(colorIndigo))),
              Container(
                  width: deviceWidth(context) * 0.11,
                  alignment: Alignment.center,
                  child:
                      Text('$totalValue', style: textStyle12Bold(colorIndigo))),
              Container(
                  width: deviceWidth(context) * 0.11,
                  alignment: Alignment.center,
                  child: Text(leftValue, style: textStyle12Bold(colorIndigo))),
              Container(
                  width: deviceWidth(context) * 0.15,
                  alignment: Alignment.center,
                  child: Text(goalValue, style: textStyle12Bold(colorIndigo))),
            ],
          ),
        ),
      ),
    );
  }

  commonWidget(DateTime date) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
      child: Column(
        children: [
          SizedBox(height: deviceHeight(context) * 0.025),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(width: deviceWidth(context) * 0.4),
              Container(
                  width: deviceWidth(context) * 0.11,
                  alignment: Alignment.center,
                  child: Text('Total', style: textStyle12Bold(colorIndigo))),
              Container(
                  width: deviceWidth(context) * 0.11,
                  alignment: Alignment.center,
                  child: Text('Left', style: textStyle12Bold(colorIndigo))),
              Container(
                  alignment: Alignment.center,
                  width: deviceWidth(context) * 0.15,
                  child: Text('Goal', style: textStyle12Bold(colorIndigo))),
            ],
          ),
          nutritionData(
              'Carbohydrates',
              totalCarbohydratesValue,
              '$leftCarbohydratesValue',
              '${userData.carbohydrates!}g',
              () => null),
          nutritionData('Protein', totalProteinValue, '$leftProteinValue',
              '${userData.protein!}g', () => null),
          nutritionData('Fat', totalFatValue, '$leftFatValue',
              '${userData.fat!}g', () => null),
          nutritionData('Saturated', totalSatFatValue, '$leftSatFatValue',
              '${userData.satFat!}g', () => null),
          nutritionData('Cholesterol', totalCholesterolValue,
              '$leftCholesterolValue', '${userData.cholesterol!}mg', () => null),
          nutritionData('Potassium', totalPotassiumValue, '$leftPotassiumValue',
              '${userData.potassium!}mg', () => null),
          nutritionData('Fiber', totalFiberValue, '$leftFiberValue',
              '${userData.fiber!}g', () => null),
          nutritionData('Sodium', totalSodiumValue, '$leftSodiumValue',
              '${userData.sodium!}mg', () => null),
          nutritionData('Sugars', totalSugarValue, '$leftSugarValue',
              '${userData.sugars!}g', () => null),
          nutritionData('Calcium', totalCalciumValue, '$leftCalciumValue',
              '${userData.calcium!}%', () => null),
          nutritionData('Icon', totalIronValue, '$leftIronValue',
              '${userData.iron!}%', () => null),
          nutritionData('Vitamin A', totalVitaminAValue, '$leftVitaminAValue',
              '${userData.vitaminA!}%', () => null),
          nutritionData('Vitamin C', totalVitaminCValue, '$leftVitaminCValue',
              '${userData.vitaminC!}%', () => null),
          SizedBox(height: deviceHeight(context) * 0.03),
        ],
      ),
    );
  }
}
