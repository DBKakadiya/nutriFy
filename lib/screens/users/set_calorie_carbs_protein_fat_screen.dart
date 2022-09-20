import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrime/blocs/calories/calories_state.dart';
import 'package:nutrime/blocs/profile/profile_event.dart';
import 'package:nutrime/screens/users/updateCPF_percentage_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/calories/calories_bloc.dart';
import '../../blocs/calories/calories_event.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_state.dart';
import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';

class SetCalorieCPFScreen extends StatefulWidget {
  static const route = '/Set-CalorieCPF';

  const SetCalorieCPFScreen({Key? key}) : super(key: key);

  @override
  State<SetCalorieCPFScreen> createState() => _SetCalorieCPFState();
}

class _SetCalorieCPFState extends State<SetCalorieCPFScreen> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _calorieController = TextEditingController();
  int count = 0;
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
          _calorieController.text = userData.caloriesGoal!;
        });
        print('--------carbohydrates------${userData.carbohydrates}');
        print('--------protein------${userData.protein}');
        print('--------fat------${userData.fat}');
      });
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  updateCalorie() {
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
                              padding: EdgeInsets.only(
                                  top: deviceHeight(context) * 0.025),
                              child: Text('Net Calorie Goal',
                                  style: textStyle20Bold(colorIndigo)),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                enterDataField(
                                    _calorieController, 'calories/day'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                cancelSave('CANCEL', () {
                                  _calorieController.text =
                                      userData.caloriesGoal!;
                                  Navigator.of(context).pop();
                                }),
                                cancelSave('SAVE', () async {
                                  if (_calorieController.text.isEmpty) {
                                    setState(() {
                                      _calorieController.text =
                                          userData.caloriesGoal!;
                                    });
                                    Navigator.of(context).pop();
                                    ErrorDialog().errorDialog(context,
                                        'Women are likely to need between 1600 and 2400 calories a day, and men from 2000 to 3000. So please enter a valid goal.');
                                  } else {
                                    if (int.parse(_calorieController.text) <
                                            1600 ||
                                        int.parse(_calorieController.text) >
                                            3000) {
                                      setState(() {
                                        _calorieController.text =
                                            userData.caloriesGoal!;
                                      });
                                      Navigator.of(context).pop();
                                      ErrorDialog().errorDialog(context,
                                          'Women are likely to need between 1600 and 2400 calories a day, and men from 2000 to 3000. So please enter a valid goal.');
                                    } else {
                                      setState(() {
                                        userData.caloriesGoal =
                                            _calorieController.text;
                                        double carbVal = ((int.parse(userData
                                                        .caloriesGoal!) *
                                                    userData
                                                        .percentageCarbohydrates!) /
                                                100) /
                                            4;
                                        double proteinVal = ((int.parse(userData
                                                        .caloriesGoal!) *
                                                    userData
                                                        .percentageProtein!) /
                                                100) /
                                            4;
                                        double fatVal = ((int.parse(userData
                                                        .caloriesGoal!) *
                                                    userData.percentageFat!) /
                                                100) /
                                            9;
                                        userData.carbohydrates = int.parse(
                                                    carbVal
                                                        .toStringAsFixed(2)
                                                        .split('.')[1]) >
                                                0
                                            ? carbVal.toStringAsFixed(2)
                                            : carbVal.floor().toString();
                                        userData.protein = int.parse(proteinVal
                                                    .toStringAsFixed(2)
                                                    .split('.')[1]) >
                                                0
                                            ? proteinVal.toStringAsFixed(2)
                                            : proteinVal.floor().toString();
                                        userData.fat = int.parse(fatVal
                                                    .toStringAsFixed(2)
                                                    .split('.')[1]) >
                                                0
                                            ? fatVal.toStringAsFixed(2)
                                            : fatVal.floor().toString();
                                      });
                                      BlocProvider.of<ProfileBloc>(context).add(
                                          GetCaloriesEvent(
                                              calorie: userData.caloriesGoal!));
                                      BlocProvider.of<CaloriesBloc>(context)
                                          .add(GetCarbsEvent(
                                              carbs: userData.carbohydrates!));
                                      BlocProvider.of<CaloriesBloc>(context)
                                          .add(GetProteinEvent(
                                              protein: userData.protein!));
                                      BlocProvider.of<CaloriesBloc>(context)
                                          .add(GetFatEvent(fat: userData.fat!));
                                      await helper.updateUserData(userData);
                                      Navigator.of(context).pop();
                                    }
                                  }
                                }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
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
        title: Text('Calorie Goals', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight(context) * 0.04),
              Text('Default Goal', style: textStyle18Bold(colorIndigo)),
              SizedBox(height: deviceHeight(context) * 0.02),
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return profilesButton(
                      'Calorie',
                      state is GetCaloriesData
                          ? state.calorie.length == 4
                              ? '${state.calorie.substring(0, 1)},${state.calorie.substring(1)}'
                              : state.calorie
                          : userData.caloriesGoal!.length == 4
                              ? '${userData.caloriesGoal!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}'
                              : userData.caloriesGoal!,
                      updateCalorie);
                },
              ),
              BlocBuilder<CaloriesBloc, CaloriesState>(
                builder: (context, state) {
                  return profilesButton(
                      state is GetCarbsData
                          ? 'Carbohydrates (${state.carbs}g)'
                          : 'Carbohydrates (${userData.carbohydrates}g)',
                      '${userData.percentageCarbohydrates!}%',
                      () => Navigator.of(context)
                          .pushNamed(UpdateCPFScreen.route));
                },
              ),
              BlocBuilder<CaloriesBloc, CaloriesState>(
                builder: (context, state) {
                  return profilesButton(
                      state is GetProteinData
                          ? 'Protein (${state.protein}g)'
                          : 'Protein (${userData.protein}g)',
                      '${userData.percentageProtein!}%',
                      () => Navigator.of(context)
                          .pushNamed(UpdateCPFScreen.route));
                },
              ),
              BlocBuilder<CaloriesBloc, CaloriesState>(
                builder: (context, state) {
                  return profilesButton(
                      state is GetFatData
                          ? 'Fat (${state.fat}g)'
                          : 'Fat (${userData.fat}g)',
                      '${userData.percentageFat!}%',
                      () => Navigator.of(context)
                          .pushNamed(UpdateCPFScreen.route));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: radius == 4 ? colorBG : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4
            ? Border.all(color: colorWhite, width: 1.7)
            : radius == 4.1
                ? Border.all(color: color, width: 1.7)
                : null,
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

  profilesButton(String title, String val, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.01),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(colorGrey, 6),
          child: Row(
            children: [
              SizedBox(width: deviceWidth(context) * 0.03),
              Text(title, style: textStyle14Medium(colorBlack)),
              const Spacer(),
              Text(val, style: textStyle16Medium(Colors.blue.shade800)),
              SizedBox(width: deviceWidth(context) * 0.03),
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
        height: deviceHeight(context) * 0.07,
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
      height: deviceHeight(context) * 0.065,
      width: deviceWidth(context) * 0.5,
      decoration: decoration(colorGrey.withOpacity(0.5), 4.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceHeight(context) * 0.05,
            width: deviceWidth(context) * 0.16,
            child: TextFormField(
              controller: controller,
              style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
              cursorColor: colorIndigo,
              decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: textStyle16Bold(colorIndigo.withOpacity(0.6)),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: colorIndigo, width: 1))),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(title, style: textStyle16Bold(colorIndigo)),
        ],
      ),
    );
  }
}
