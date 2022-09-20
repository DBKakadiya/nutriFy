import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/screens/users/addtional_nutrition_goal_screen.dart';
import 'package:nutrime/screens/users/set_calorie_carbs_protein_fat_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';

class GoalsScreen extends StatefulWidget {
  static const route = '/Goals';

  const GoalsScreen({Key? key}) : super(key: key);

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
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
  final TextEditingController _startingWeightController =
      TextEditingController();
  final TextEditingController _currentWeightController =
      TextEditingController();
  final TextEditingController _goalWeightController = TextEditingController();
  String? selectDate;
  String? selectedWeeklyGoal;
  String? selectedActivity;

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
          _startingWeightController.text = userData.weight!.split(' ')[0];
          _currentWeightController.text = userData.currentWeight!.split(' ')[0];
          _goalWeightController.text = userData.goalWeight!.split(' ')[0];
          selectDate = userData.startDate;
          selectedWeeklyGoal = userData.weeklyGoal;
          selectedActivity = userData.activityLevel;
        });
      });
    });
  }

  startDate() {
    showDatePicker(
        context: context,
        initialDate: DateTime.parse(userData.startDate!),
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: colorIndigo,
                  onPrimary: colorWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    textStyle: textStyle14Bold(colorIndigo),
                    // primary: colorRed, // button text color
                  ),
                ),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print('-------pickedDate---$pickedDate');
      setState(() {
        selectDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
      BlocProvider.of<ProfileBloc>(context)
          .add(GetStartDateEvent(date: selectDate!));
    });
  }

  updateStartingWeight(Function() onCancel, Function() onSave) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                child: StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    content: SizedBox(
                      height: deviceHeight(context) * 0.27,
                      width: deviceWidth(context) * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(top: deviceHeight(context) * 0.025),
                            child: Text('Starting Weight',
                                style: textStyle20Bold(colorIndigo)),
                          ),
                          enterDataField(_startingWeightController, 'kg on'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cancelSave('CANCEL', onCancel),
                              Container(
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
                ),
              ));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  updateWeight(String title, TextEditingController controller,
      Function() onCancel, Function() onSave) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                child: StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    contentPadding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    content: SizedBox(
                      height: deviceHeight(context) * 0.27,
                      width: deviceWidth(context) * 0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.only(top: deviceHeight(context) * 0.025),
                            child: Text(title, style: textStyle20Bold(colorIndigo)),
                          ),
                          enterDataField(controller, 'kg'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cancelSave('CANCEL', onCancel),
                              Container(
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
                )
              ));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  updateWeeklyGoal(Function() onCancel, Function() onSave) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: 480,
                        width: deviceWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text('Weekly Goal',
                                  style: textStyle18Bold(colorIndigo)),
                            ),
                            SizedBox(
                                height: 370,
                                child: ListView.builder(
                                    itemCount: weeklyGoals.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 55 / 14,
                                          horizontal: deviceWidth(context) * 0.03),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedWeeklyGoal = weeklyGoals[index];
                                          });
                                        },
                                        child: Container(
                                          height: 45,
                                          width: deviceWidth(context) * 0.7,
                                          decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                  colorGrey.withOpacity(0.25),
                                                  width: 1.5)),
                                          // alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 45,
                                                width: deviceWidth(context) * 0.1,
                                                child: FittedBox(
                                                  child: Radio(
                                                    value: weeklyGoals[index],
                                                    groupValue: selectedWeeklyGoal,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedWeeklyGoal =
                                                        weeklyGoals[index];
                                                      });
                                                    },
                                                    fillColor:
                                                    MaterialStateProperty.all(
                                                        colorIndigo),
                                                    activeColor: colorIndigo,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                weeklyGoals[index],
                                                style: textStyle14(colorBlack),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', onCancel),
                                Container(
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', onSave)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  updateActivity(Function() onCancel, Function() onSave) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: 470,
                        width: deviceWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text('Activity Level',
                                  style: textStyle18Bold(colorIndigo)),
                            ),
                            SizedBox(
                                height: 350,
                                child: ListView.builder(
                                    itemCount: activityTitles.length,
                                    itemBuilder: (context, index) => Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 30 / 8,
                                          horizontal: deviceWidth(context) * 0.03),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedActivity =
                                            activityTitles[index];
                                          });
                                        },
                                        child: Container(
                                          height: 80,
                                          width: deviceWidth(context) * 0.7,
                                          decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                  colorGrey.withOpacity(0.25),
                                                  width: 1.5)),
                                          // alignment: Alignment.centerLeft,
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              // SizedBox(
                                              //     width: deviceWidth(context) *
                                              //         0.02),
                                              SizedBox(
                                                height: 45,
                                                width: deviceWidth(context) * 0.1,
                                                child: FittedBox(
                                                  child: Radio(
                                                    value: activityTitles[index],
                                                    groupValue: selectedActivity,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedActivity =
                                                        activityTitles[index];
                                                      });
                                                    },
                                                    fillColor:
                                                    MaterialStateProperty.all(
                                                        colorIndigo),
                                                    activeColor: colorIndigo,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: deviceWidth(context) * 0.55,
                                                alignment: Alignment.centerLeft,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      activityTitles[index],
                                                      style: textStyle16Bold(
                                                          colorBlack),
                                                    ),
                                                    const SizedBox(height: 3),
                                                    Text(
                                                      activitySubTitles[index],
                                                      style: textStyle11(colorGrey),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', onCancel),
                                Container(
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', onSave)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
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
        title: Text('Goals', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight(context) * 0.025),
              goalButton(
                  'Starting Weight',
                  '${userData.weight!.split(' ')[0]} kg on ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(userData.startDate!))}',
                  () => updateStartingWeight(() {
                        setState(() {
                          _startingWeightController.text =
                              userData.weight!.split(' ')[0];
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_startingWeightController.text.isEmpty) {
                          setState(() {
                            _startingWeightController.text =
                                userData.weight!.split(' ')[0];
                          });
                          Navigator.of(context).pop();
                          ErrorDialog().errorDialog(context, 'Please add weight');
                        } else {
                          if (int.parse(_startingWeightController.text) < 0 ||
                              int.parse(_startingWeightController.text) >
                                  300) {
                            setState(() {
                              _startingWeightController.text =
                                  userData.weight!.split(' ')[0];
                            });
                            Navigator.of(context).pop();
                            ErrorDialog().errorDialog(context, 'Please enter valid weight');
                          } else {
                            setState(() {
                              userData.weight = _startingWeightController
                                      .text.isEmpty
                                  ? 'Weight'
                                  : _startingWeightController.text + ' kg';
                              userData.startDate = selectDate!;
                            });
                            await helper.updateUserData(userData);
                            Navigator.of(context).pop();
                          }
                        }
                      })),
              goalButton(
                  'Current Weight',
                  '${userData.currentWeight!.split(' ')[0]} kg',
                  () => updateWeight(
                          'Current Weight', _currentWeightController, () {
                        setState(() {
                          _currentWeightController.text =
                              userData.currentWeight!.split(' ')[0];
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_currentWeightController.text.isEmpty) {
                          setState(() {
                            _currentWeightController.text =
                                userData.currentWeight!.split(' ')[0];
                          });
                          Navigator.of(context).pop();
                          ErrorDialog().errorDialog(context, 'Please add weight');
                        } else {
                          if (int.parse(_currentWeightController.text) < 0 ||
                              int.parse(_currentWeightController.text) >
                                  300) {
                            setState(() {
                              _currentWeightController.text =
                                  userData.currentWeight!.split(' ')[0];
                            });
                            Navigator.of(context).pop();
                            ErrorDialog().errorDialog(context, 'Please enter valid weight');
                          } else {
                            setState(() {
                              userData.currentWeight =
                                  _currentWeightController.text.isEmpty
                                      ? 'Weight'
                                      : _currentWeightController.text + ' kg';
                            });
                            await helper.updateUserData(userData);
                            Navigator.of(context).pop();
                          }
                        }
                      })),
              goalButton(
                  'Goal Weight',
                  '${userData.goalWeight!.split(' ')[0]} kg',
                  () =>
                      updateWeight('Goal Weight', _goalWeightController, () {
                        setState(() {
                          _goalWeightController.text =
                              userData.goalWeight!.split(' ')[0];
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_goalWeightController.text.isEmpty) {
                          setState(() {
                            _goalWeightController.text =
                                userData.goalWeight!.split(' ')[0];
                          });
                          Navigator.of(context).pop();
                          ErrorDialog().errorDialog(context, 'Please add weight');
                        } else {
                          if (int.parse(_goalWeightController.text) < 0 ||
                              int.parse(_goalWeightController.text) > 300) {
                            setState(() {
                              _goalWeightController.text =
                                  userData.goalWeight!.split(' ')[0];
                            });
                            Navigator.of(context).pop();
                            ErrorDialog().errorDialog(context, 'Please enter valid weight');
                          } else {
                            setState(() {
                              userData.goalWeight =
                                  _goalWeightController.text.isEmpty
                                      ? 'Weight'
                                      : _goalWeightController.text + ' kg';
                            });
                            await helper.updateUserData(userData);
                            Navigator.of(context).pop();
                          }
                        }
                      })),
              goalButton(
                  'Weekly Goal',
                  userData.weeklyGoal!,
                  () => updateWeeklyGoal(() {
                        setState(() {
                          selectedWeeklyGoal = userData.weeklyGoal!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        setState(() {
                          userData.weeklyGoal = selectedWeeklyGoal;
                        });
                        await helper.updateUserData(userData);
                        Navigator.of(context).pop();
                      })),
              goalButton(
                  'Activity Level',
                  userData.activityLevel!,
                  () => updateActivity(() {
                        setState(() {
                          selectedActivity = userData.activityLevel!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        setState(() {
                          userData.activityLevel = selectedActivity;
                        });
                        await helper.updateUserData(userData);
                        Navigator.of(context).pop();
                      })),
              shadowTitle('Nutrition Goals', deviceWidth(context) * 0.4),
              nutritionGoals(
                  'Calorie, carbs, protein and fat Goals',
                  'Customize your default or daily goals.',
                  () => Navigator.of(context)
                      .pushNamed(SetCalorieCPFScreen.route)),
              // nutritionGoals('Calorie goal by meal', 'Stay on track with a calorie goal for each meal.', () => null),
              // nutritionGoals('Show Carbs, Protein and Fat by meal', 'View carbs, protein and fat by gram or percent.', () => null),
              fitnessGoals(
                  'Additional Nutrient Goals',
                  () => Navigator.of(context)
                      .pushNamed(AdditionalNutritionScreen.route)),
              shadowTitle('Fitness Goals', deviceWidth(context) * 0.37),
              fitnessGoals('Workouts / Week', () => null),
              fitnessGoals('Minutes / Workout', () => null),
              nutritionGoals(
                  'Exercise Calories',
                  'Decide whether to adjust daily goals when you exercise',
                  () => null),
              SizedBox(height: deviceHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: radius == 30 ? colorIndigo : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorIndigo, width: 1) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: colorIndigo.withOpacity(0.3),
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
          decoration: decoration(5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  shadowTitle(String title, double width) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.03),
      child: Container(
        height: deviceHeight(context) * 0.055,
        width: width,
        decoration: decoration(30),
        alignment: Alignment.center,
        child: Text(title, style: textStyle16Bold(colorWhite)),
      ),
    );
  }

  goalButton(String title, String answer, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: Container(
        height: deviceHeight(context) * 0.065,
        decoration: decoration(6),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(title, style: textStyle14Medium(colorBlack)),
            const Spacer(),
            TextButton(
                onPressed: onClick,
                child: Text(answer,
                    style: textStyle14Medium(Colors.blue.shade800))),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }

  nutritionGoals(String title, String subTitle, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.085,
          width: deviceWidth(context),
          decoration: decoration(6),
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle16Medium(colorBlack)),
              Text(subTitle, style: textStyle11(colorBlack.withOpacity(0.5)))
            ],
          ),
        ),
      ),
    );
  }

  fitnessGoals(String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(6),
          child: Row(
            children: [
              SizedBox(width: deviceWidth(context) * 0.03),
              Text(title, style: textStyle16Medium(colorBlack)),
            ],
          ),
        ),
      ),
    );
  }

  Widget cancelSave(String text, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 55,
        width:
            ((deviceWidth(context) * 0.8) / 2) - deviceWidth(context) * 0.005,
        decoration: BoxDecoration(
            color: colorIndigo.withOpacity(0.2),
            borderRadius: text == 'SAVE'
                ? const BorderRadius.only(bottomRight: Radius.circular(20))
                : const BorderRadius.only(bottomLeft: Radius.circular(20))),
        alignment: Alignment.center,
        child: Text(text,
            style: textStyle16Bold(text == 'SAVE' ? colorIndigo : colorWhite)),
      ),
    );
  }

  enterDataField(TextEditingController controller, String title) {
    return Container(
      height: deviceHeight(context) * 0.06,
      width: controller == _startingWeightController
          ? deviceWidth(context) * 0.6
          : deviceWidth(context) * 0.3,
      decoration: decoration(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceHeight(context) * 0.04,
            width: deviceWidth(context) * 0.1,
            child: TextFormField(
              controller: controller,
              style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
              cursorColor: colorIndigo,
              autofocus: true,
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: textStyle16Bold(colorIndigo.withOpacity(0.6)),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: colorIndigo, width: 1))),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(title, style: textStyle16Bold(colorIndigo)),
          if (controller == _startingWeightController)
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: startDate,
                  child: Text(
                      DateFormat('dd-MMM-yyyy').format(DateTime.parse(
                          state is GetStartDateData
                              ? state.date
                              : selectDate!)),
                      style: textStyle16Medium(Colors.blue.shade700)),
                );
              },
            )
        ],
      ),
    );
  }
}

