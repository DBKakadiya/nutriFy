import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/calories/calories_bloc.dart';
import '../../blocs/calories/calories_event.dart';
import '../../blocs/calories/calories_state.dart';
import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/valuePicker.dart';

class UpdateCPFScreen extends StatefulWidget {
  static const route = '/Update-CPF';

  const UpdateCPFScreen({Key? key}) : super(key: key);

  @override
  State<UpdateCPFScreen> createState() => _UpdateCPFState();
}

class _UpdateCPFState extends State<UpdateCPFScreen> {
  bool is100 = true;
  int? total;
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
  int? perCarbs;
  int? perProtein;
  int? perFat;

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        setState(() {
          userData = data!.first;
          perCarbs = userData.percentageCarbohydrates!;
          perProtein = userData.percentageProtein!;
          perFat = userData.percentageFat!;
          total = perCarbs! + perProtein! + perFat!;
          is100 = total == 100 ? true : false;
          print('---userData------${userData.toString()}');
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
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.15,
        leading: buttons(icBack, () => Navigator.of(context).pop()),
        title: Text('Macronutrients', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () {
                  if (is100) {
                    helper.updateUserData(userData);
                    Navigator.of(context).pop();
                  }
                },
                icon: Image.asset(icSaveWeight,
                    color: is100 ? colorIndigo : colorIndigo.withOpacity(0.2),
                    width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: deviceHeight(context) * 0.02),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
            child: Column(
              children: [
                BlocBuilder<CaloriesBloc, CaloriesState>(
                  builder: (context, state) {
                    return showValue(
                        'Carbohydrates',
                        state is GetCarbsData
                            ? '${state.carbs}g'
                            : '${userData.carbohydrates}g',
                        ValuePicker(
                          initialValue: perCarbs!,
                          minValue: 0,
                          maxValue: 100,
                          direction: Axis.horizontal,
                          withSpring: true,
                          onChanged: (val) {
                            setState(() {
                              userData.percentageCarbohydrates = val;
                              total = userData.percentageCarbohydrates! +
                                  userData.percentageProtein! +
                                  userData.percentageFat!;
                              if (total == 100) {
                                is100 = true;
                              } else {
                                is100 = false;
                              }
                              double carbVal =
                                  ((int.parse(userData.caloriesGoal!) *
                                              userData
                                                  .percentageCarbohydrates!) /
                                          100) /
                                      4;
                              userData.carbohydrates = int.parse(carbVal
                                          .toStringAsFixed(2)
                                          .split('.')[1]) >
                                      0
                                  ? carbVal.toStringAsFixed(2)
                                  : carbVal.floor().toString();
                            });
                            BlocProvider.of<CaloriesBloc>(context).add(
                                GetCarbsEvent(carbs: userData.carbohydrates!));
                          },
                          enableOnOutOfConstraintsAnimation: true,
                          onOutOfConstraints: () =>
                              print("This value is too high or too low"),
                        ));
                  },
                ),
                BlocBuilder<CaloriesBloc, CaloriesState>(
                  builder: (context, state) {
                    return showValue(
                        'Protein',
                        state is GetProteinData
                            ? '${state.protein}g'
                            : '${userData.protein}g',
                        ValuePicker(
                          initialValue: perProtein!,
                          minValue: 0,
                          maxValue: 100,
                          direction: Axis.horizontal,
                          withSpring: true,
                          onChanged: (val) {
                            setState(() {
                              userData.percentageProtein = val;
                              total = userData.percentageCarbohydrates! +
                                  userData.percentageProtein! +
                                  userData.percentageFat!;
                              if (total == 100) {
                                is100 = true;
                              } else {
                                is100 = false;
                              }
                              double proteinVal =
                                  ((int.parse(userData.caloriesGoal!) *
                                              userData.percentageProtein!) /
                                          100) /
                                      4;
                              userData.protein = int.parse(proteinVal
                                          .toStringAsFixed(2)
                                          .split('.')[1]) >
                                      0
                                  ? proteinVal.toStringAsFixed(2)
                                  : proteinVal.floor().toString();
                            });
                            BlocProvider.of<CaloriesBloc>(context).add(
                                GetProteinEvent(protein: userData.protein!));
                          },
                          enableOnOutOfConstraintsAnimation: true,
                          onOutOfConstraints: () =>
                              print("This value is too high or too low"),
                        ));
                  },
                ),
                BlocBuilder<CaloriesBloc, CaloriesState>(
                  builder: (context, state) {
                    return showValue(
                        'Fat',
                        state is GetFatData
                            ? '${state.fat}g'
                            : '${userData.fat}g',
                        ValuePicker(
                          initialValue: perFat!,
                          minValue: 0,
                          maxValue: 100,
                          direction: Axis.horizontal,
                          withSpring: true,
                          onChanged: (val) {
                            setState(() {
                              userData.percentageFat = val;
                              total = userData.percentageCarbohydrates! +
                                  userData.percentageProtein! +
                                  userData.percentageFat!;
                              if (total == 100) {
                                is100 = true;
                              } else {
                                is100 = false;
                              }
                              double fatVal =
                                  ((int.parse(userData.caloriesGoal!) *
                                              userData.percentageFat!) /
                                          100) /
                                      9;
                              userData.fat = int.parse(fatVal
                                          .toStringAsFixed(2)
                                          .split('.')[1]) >
                                      0
                                  ? fatVal.toStringAsFixed(2)
                                  : fatVal.floor().toString();
                            });
                            BlocProvider.of<CaloriesBloc>(context)
                                .add(GetFatEvent(fat: userData.fat!));
                          },
                          enableOnOutOfConstraintsAnimation: true,
                          onOutOfConstraints: () =>
                              print("This value is too high or too low"),
                        ));
                  },
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: deviceHeight(context) * 0.12,
            width: deviceWidth(context),
            color: colorIndigo.withOpacity(0.1),
            child: Row(
              children: [
                SizedBox(width: deviceWidth(context) * 0.05),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('% Total', style: textStyle20Bold(colorIndigo)),
                    SizedBox(height: deviceHeight(context) * 0.01),
                    Text('Macronutrients must equal 100%',
                        style: textStyle13(colorIndigo)),
                  ],
                ),
                const Spacer(),
                Text('$total%', style: textStyle20Bold(colorIndigo)),
                SizedBox(width: deviceWidth(context) * 0.07),
              ],
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(2, 2)),
        ]);
  }

  buttons(String icon, Function() onclick) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical:
              (deviceHeight(context) * 0.08 - deviceHeight(context) * 0.042) /
                  2,
          horizontal:
              (deviceWidth(context) * 0.15 - deviceWidth(context) * 0.085) / 2),
      child: GestureDetector(
        onTap: onclick,
        child: Container(
          height: deviceHeight(context) * 0.042,
          width: deviceWidth(context) * 0.085,
          decoration: decoration(colorIndigo, 5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  showValue(String title, String value, ValuePicker valuePicker) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.01),
      child: Container(
        height: deviceHeight(context) * 0.15,
        width: deviceWidth(context),
        decoration: decoration(colorWhite, 10),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.05),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textStyle16Bold(colorIndigo)),
                SizedBox(height: deviceHeight(context) * 0.01),
                Text(value, style: textStyle16(colorIndigo)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: deviceWidth(context) * 0.45,
              child: valuePicker,
            ),
            SizedBox(width: deviceWidth(context) * 0.02),
          ],
        ),
      ),
    );
  }
}
