import 'package:flutter/material.dart';
import 'package:nutrime/screens/users/goal_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../screens/users/add_weight_screen.dart';
import '../../screens/users/progress_screen.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({Key? key}) : super(key: key);

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  DatabaseHelper helper = DatabaseHelper();
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
  int weightDiffer = 0;

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
          weightDiffer = int.parse(userData.currentWeight!.split(' ')[0]) -
              int.parse(userData.weight!.split(' ')[0]);
        });
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.04),
        child: Column(
          children: [
            const SizedBox(height: 30),
            imageData(
                'Progress',
                icAddItem,
                'Add Weight',
                () => Navigator.of(context)
                    .pushNamed(AddWeightScreen.route, arguments: 'isProgress')),
            SizedBox(height: deviceHeight(context) * 0.03),
            imageData('Goals', icEdit, 'Update Goals',
                () => Navigator.of(context).pushNamed(GoalsScreen.route)),
            SizedBox(height: deviceHeight(context) * 0.01),
          ],
        ),
      ),
    );
  }

  BoxDecoration decoration() {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
              color: colorIndigo.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  shadowTitle(String title, double width) {
    return Container(
      height: deviceHeight(context) * 0.045,
      width: width,
      decoration: decoration(),
      alignment: Alignment.center,
      child: Text(title, style: textStyle16Bold(colorIndigo)),
    );
  }

  titleButton(String title, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.045,
        width: deviceWidth(context) * 0.31,
        decoration: BoxDecoration(
            color: colorIndigo.withOpacity(0.1),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: title.contains('Add')
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.center,
          children: [
            title.contains('Add')
                ? Icon(Icons.add,
                    color: colorIndigo, size: deviceWidth(context) * 0.05)
                : Container(),
            Text(title, style: textStyle14Bold(colorIndigo)),
          ],
        ),
      ),
    );
  }

  displayTitle(String first, String second) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(first, style: textStyle14Light(colorIndigo)),
        SizedBox(height: deviceHeight(context) * 0.015),
        Text(second, style: textStyle14Light(colorIndigo)),
      ],
    );
  }

  friendsApps(double sizedWidth, String icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.035),
      child: Row(
        children: [
          SizedBox(width: sizedWidth),
          Image.asset(icon, width: deviceWidth(context) * 0.1),
          const Spacer(),
          SizedBox(
              width: deviceWidth(context) * 0.7,
              child: Text(text,
                  style: textStyle14Medium(colorIndigo).copyWith(height: 1.3)))
        ],
      ),
    );
  }

  imageData(String title, String icon, String action, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.01),
      child: Container(
        height: title == 'Progress' ? 360 : 65 + (71.5 * 2),
        width: deviceWidth(context),
        decoration: BoxDecoration(
            border: Border.all(color: colorIndigo, width: 1),
            color: colorWhite,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Container(
              height: 55,
              width: deviceWidth(context),
              decoration: const BoxDecoration(
                  color: colorIndigo,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: textStyle16Bold(colorWhite)),
                    GestureDetector(
                      onTap: onClick,
                      child: Row(
                        children: [
                          Image.asset(icon,
                              color: colorWhite,
                              width: icon == icAddItem
                                  ? deviceWidth(context) * 0.06
                                  : deviceWidth(context) * 0.05),
                          SizedBox(width: deviceWidth(context) * 0.02),
                          Text(action, style: textStyle16Bold(colorWhite)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            if (title == 'Progress')
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ProgressScreen.route);
                },
                child: SizedBox(
                  height: 300,
                  width: deviceWidth(context) * 0.7,
                  child: SfRadialGauge(axes: <RadialAxis>[
                    RadialAxis(
                        showTicks: false,
                        showLabels: true,
                        showFirstLabel: true,
                        showLastLabel: true,
                        minimum: double.parse(userData.weight!.split(' ')[0]),
                        maximum:
                            double.parse(userData.goalWeight!.split(' ')[0]),
                        axisLineStyle: AxisLineStyle(
                          thickness: 0.15,
                          cornerStyle: CornerStyle.bothCurve,
                          color: colorIndigo.withOpacity(0.15),
                          thicknessUnit: GaugeSizeUnit.factor,
                        ),
                        pointers: <GaugePointer>[
                          RangePointer(
                            value: double.parse(
                                userData.currentWeight!.split(' ')[0]),
                            gradient:
                                const SweepGradient(colors: [colorIndigo]),
                            cornerStyle: CornerStyle.bothCurve,
                            width: 0.15,
                            sizeUnit: GaugeSizeUnit.factor,
                          ),
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              positionFactor: 0.1,
                              angle: 90,
                              widget: Column(
                                children: [
                                  const Spacer(),
                                  const SizedBox(height: 70),
                                  Image.asset(
                                      weightDiffer < 0
                                          ? icLostWeightGraph
                                          : icGainWeightGraph,
                                      width: deviceWidth(context) * 0.12),
                                  const SizedBox(height: 5),
                                  Text(
                                    weightDiffer < 0
                                        ? '$weightDiffer kg'
                                        : '$weightDiffer kg',
                                    style: textStyle36Bold(colorIndigo),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    weightDiffer < 0 ? 'Lost' : 'Gained',
                                    style: textStyle14Medium(colorIndigo),
                                  ),
                                  const SizedBox(height: 50),
                                  Text(
                                    'Current: ${userData.currentWeight!.split(' ')[0]} kg',
                                    style: textStyle16Medium(
                                        colorIndigo.withOpacity(0.8)),
                                  ),
                                  const Spacer()
                                ],
                              ))
                        ])
                  ]),
                ),
              ),
            if (title == 'Goals')
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(GoalsScreen.route);
                },
                child: Column(
                  children: [
                    goalsTileView('Weight', '${userData.goalWeight}',
                        '${userData.weeklyGoal}'),
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                    goalsTileView(
                        'Daily Calories',
                        '${userData.caloriesGoal}'.characters.length == 4
                            ? '${userData.caloriesGoal.toString().substring(0, 1)},${userData.caloriesGoal.toString().substring(1)}'
                            : userData.caloriesGoal.toString(),
                        'Carbs ${userData.carbohydrates}g /Fat ${userData.fat}g /\nProtein ${userData.protein}g')
                  ],
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  goalsTileView(String text, String subText, String rightText) {
    return Container(
      height: 70,
      width: deviceWidth(context),
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: textStyle14(colorIndigo)),
                SizedBox(height: deviceHeight(context) * 0.01),
                Text(subText, style: textStyle16Bold(colorIndigo)),
              ],
            ),
            Text(rightText,
                textAlign: TextAlign.center,
                style: textStyle13(colorIndigo).copyWith(height: 1.3)),
          ],
        ),
      ),
    );
  }
}
