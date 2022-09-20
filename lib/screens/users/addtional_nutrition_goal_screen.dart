import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/profile/profile_bloc.dart';
import '../../blocs/profile/profile_event.dart';
import '../../blocs/profile/profile_state.dart';
import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';

class AdditionalNutritionScreen extends StatefulWidget {
  static const route = '/Additional-Nutrient';

  const AdditionalNutritionScreen({Key? key}) : super(key: key);

  @override
  State<AdditionalNutritionScreen> createState() => _AdditionalNutritionState();
}

class _AdditionalNutritionState extends State<AdditionalNutritionScreen> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _satFatController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _fiberController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _sugarsController = TextEditingController();
  final TextEditingController _vitaminAController = TextEditingController();
  final TextEditingController _vitaminCController = TextEditingController();
  final TextEditingController _calciumController = TextEditingController();
  final TextEditingController _ironController = TextEditingController();
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

  updateCalories(String title, TextEditingController controller, String valType,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                enterDataField(controller, valType),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                cancelSave('CANCEL', onCancel),
                                cancelSave('SAVE', onSave),
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
        }
      );
  }

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
          _satFatController.text = userData.satFat!;
          _cholesterolController.text = userData.cholesterol!;
          _potassiumController.text = userData.potassium!;
          _fiberController.text = userData.fiber!;
          _sodiumController.text = userData.sodium!;
          _sugarsController.text = userData.sugars!;
          _vitaminAController.text = userData.vitaminA!;
          _vitaminCController.text = userData.vitaminC!;
          _calciumController.text = userData.calcium!;
          _ironController.text = userData.iron!;
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
    title: Text('Additional Nutrient Goals',
        style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: deviceHeight(context) * 0.03),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Saturated Fat',
                  state is GetSatFatData
                      ? state.satFat.length == 4
                          ? '${userData.satFat!.substring(0, 1)},${state.satFat.substring(1)}g'
                          : '${state.satFat}g'
                      : userData.satFat!.length == 4
                          ? '${userData.satFat!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}g'
                          : '${userData.satFat!}g',
                  () => updateCalories(
                          'Saturated Fat', _satFatController, 'g', () {
                        setState(() {
                          _satFatController.text = userData.satFat!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_satFatController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.satFat = _satFatController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetSatFatEvent(satFat: userData.satFat!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Cholesterol',
                  state is GetCholesterolData
                      ? state.cholesterol.length == 4
                          ? '${userData.cholesterol!.substring(0, 1)},${state.cholesterol.substring(1)}mg'
                          : '${state.cholesterol}mg'
                      : userData.cholesterol!.length == 4
                          ? '${userData.cholesterol!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}mg'
                          : '${userData.cholesterol!}mg',
                  () => updateCalories(
                          'Cholesterol', _cholesterolController, 'mg', () {
                        setState(() {
                          _cholesterolController.text =
                              userData.cholesterol!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_cholesterolController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.cholesterol =
                                _cholesterolController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetCholesterolEvent(
                                  cholesterol: userData.cholesterol!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Potassium',
                  state is GetPotassiumData
                      ? state.potassium.length == 4
                          ? '${userData.potassium!.substring(0, 1)},${state.potassium.substring(1)}mg'
                          : '${state.potassium}mg'
                      : userData.potassium!.length == 4
                          ? '${userData.potassium!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}mg'
                          : '${userData.potassium!}mg',
                  () => updateCalories(
                          'Potassium', _potassiumController, 'mg', () {
                        setState(() {
                          _potassiumController.text = userData.potassium!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_potassiumController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.potassium = _potassiumController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetPotassiumEvent(
                                  potassium: userData.potassium!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Fiber',
                  state is GetFiberData
                      ? state.fiber.length == 4
                          ? '${userData.fiber!.substring(0, 1)},${state.fiber.substring(1)}g'
                          : '${state.fiber}g'
                      : userData.fiber!.length == 4
                          ? '${userData.fiber!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}g'
                          : '${userData.fiber!}g',
                  () => updateCalories('Fiber', _fiberController, 'g', () {
                        setState(() {
                          _fiberController.text = userData.fiber!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_fiberController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.fiber = _fiberController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context)
                              .add(GetFiberEvent(fiber: userData.fiber!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Sodium',
                  state is GetSodiumData
                      ? state.sodium.length == 4
                          ? '${userData.sodium!.substring(0, 1)},${state.sodium.substring(1)}mg'
                          : '${state.sodium}mg'
                      : userData.sodium!.length == 4
                          ? '${userData.sodium!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}mg'
                          : '${userData.sodium!}mg',
                  () =>
                      updateCalories('Sodium', _sodiumController, 'mg', () {
                        setState(() {
                          _sodiumController.text = userData.sodium!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_sodiumController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.sodium = _sodiumController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetSodiumEvent(sodium: userData.sodium!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Sugars',
                  state is GetSugarsData
                      ? state.sugars.length == 4
                          ? '${userData.sugars!.substring(0, 1)},${state.sugars.substring(1)}g'
                          : '${state.sugars}g'
                      : userData.sugars!.length == 4
                          ? '${userData.sugars!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}g'
                          : '${userData.sugars!}g',
                  () =>
                      updateCalories('Sugars', _sugarsController, 'g', () {
                        setState(() {
                          _sugarsController.text = userData.sugars!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_sugarsController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.sugars = _sugarsController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetSugarsEvent(sugars: userData.sugars!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Vitamin A',
                  state is GetVitaminAData
                      ? state.vitaminA.length == 4
                          ? '${userData.vitaminA!.substring(0, 1)},${state.vitaminA.substring(1)}%Dv'
                          : '${state.vitaminA}%Dv'
                      : userData.vitaminA!.length == 4
                          ? '${userData.vitaminA!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}%Dv'
                          : '${userData.vitaminA!}%Dv',
                  () => updateCalories(
                          'Vitamin A', _vitaminAController, '%Dv', () {
                        setState(() {
                          _vitaminAController.text = userData.vitaminA!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_vitaminAController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.vitaminA = _vitaminAController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetVitaminAEvent(
                                  vitaminA: userData.vitaminA!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Vitamin C',
                  state is GetVitaminCData
                      ? state.vitaminC.length == 4
                          ? '${userData.vitaminC!.substring(0, 1)},${state.vitaminC.substring(1)}%Dv'
                          : '${state.vitaminC}%Dv'
                      : userData.vitaminC!.length == 4
                          ? '${userData.vitaminC!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}%Dv'
                          : '${userData.vitaminC!}%Dv',
                  () => updateCalories(
                          'Vitamin C', _vitaminCController, '%Dv', () {
                        setState(() {
                          _vitaminCController.text = userData.vitaminC!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_vitaminCController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.vitaminC = _vitaminCController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetVitaminCEvent(
                                  vitaminC: userData.vitaminC!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Calcium',
                  state is GetCalciumData
                      ? state.calcium.length == 4
                          ? '${userData.calcium!.substring(0, 1)},${state.calcium.substring(1)}%Dv'
                          : '${state.calcium}%Dv'
                      : userData.calcium!.length == 4
                          ? '${userData.calcium!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}%Dv'
                          : '${userData.calcium!}%Dv',
                  () => updateCalories('Calcium', _calciumController, '%Dv',
                          () {
                        setState(() {
                          _calciumController.text = userData.calcium!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_calciumController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.calcium = _calciumController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context).add(
                              GetCalciumEvent(calcium: userData.calcium!));
                          Navigator.of(context).pop();
                        }
                      }));
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return profilesButton(
                  'Iron',
                  state is GetIronData
                      ? state.iron.length == 4
                          ? '${userData.iron!.substring(0, 1)},${state.iron.substring(1)}%Dv'
                          : '${state.iron}%Dv'
                      : userData.iron!.length == 4
                          ? '${userData.iron!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}%Dv'
                          : '${userData.iron!}%Dv',
                  () => updateCalories('Iron', _ironController, '%Dv', () {
                        setState(() {
                          _ironController.text = userData.iron!;
                        });
                        Navigator.of(context).pop();
                      }, () async {
                        if (_ironController.text.isEmpty) {
                          ErrorDialog().errorDialog(context, 'Please enter numeric value.');
                        } else {
                          setState(() {
                            userData.iron = _ironController.text;
                          });
                          helper.updateUserData(userData);
                          BlocProvider.of<ProfileBloc>(context)
                              .add(GetIronEvent(iron: userData.iron!));
                          Navigator.of(context).pop();
                        }
                      }));
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
      width: deviceWidth(context) * 0.4,
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
