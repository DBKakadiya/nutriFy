import 'package:flutter/material.dart';
import 'package:nutrime/screens/bottomBar/my_reminders_screen.dart';
import 'package:nutrime/screens/bottomBar/nutrition_screen.dart';
import 'package:nutrime/screens/bottomBar/step_counter_screen.dart';
import 'package:nutrime/screens/users/goal_screen.dart';
import 'package:nutrime/screens/users/progress_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/animation_widget.dart';
import '../setting_screen.dart';
import '../users/add_friends_screen.dart';
import '../users/recipes_meals_foods_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
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

  getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> listNoteFuture = helper.getUserDataList();
      listNoteFuture.then((data) {
        setState(() {
          userData = data!.first;
        });
        print('---userData------${userData.toString()}');
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
    return Stack(
      children: [
        SizedBox(height: deviceHeight(context) * 0.845),
        SizedBox(
            height: deviceHeight(context) * 0.17,
            child: Image.asset(icUserBG,
                fit: BoxFit.fill, width: deviceWidth(context))),
        Positioned(
            top: (deviceHeight(context) * 0.12 / 2) -
                (deviceHeight(context) * 0.042 / 2),
            child: SizedBox(
              width: deviceWidth(context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: deviceHeight(context) * 0.042,
                      width: deviceWidth(context) * 0.085,
                      decoration: const BoxDecoration(
                          color: colorWhite, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Image.asset(icUserId,
                          width: deviceWidth(context) * 0.05)),
                  Text(userData.name!, style: textStyle20Bold(colorWhite)),
                  SizedBox(
                    width: deviceWidth(context) * 0.085,
                  )
                ],
              ),
            )),
        Positioned(
          top: deviceHeight(context) * 0.12,
          left: deviceWidth(context) * 0.05,
          child: Container(
            height: deviceHeight(context) * 0.735,
            width: deviceWidth(context) * 0.9,
            decoration: const BoxDecoration(
                color: colorBG,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7), topRight: Radius.circular(7))),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.035,
                    vertical: 10),
                child: Column(
                  children: [
                    // userIdButton(
                    //     icRecipeDiscovery, 'Recipe Discovery', () => null),
                    userIdButton(
                        icProgress,
                        'Progress',
                        const ProgressScreen()),
                    // userIdButton(icWorkout, 'Workout Routines', () => null),
                    userIdButton(
                        icGoal,
                        'Goals',
                        const GoalsScreen()),
                    userIdButton(
                        icNutrition,
                        'Nutrition',
                        const NutritionScreen(index: 1)),
                    userIdButton(icRecipeMealFoods, 'Meals, Recipes & Foods',
                        const MealsRecipesFoods(index: 0)),
                    userIdButton(icSteps, 'Steps', const StepCounterScreen()),
                    // userIdButton(icFriends, 'Friends', () => Navigator.of(context).pushNamed(AddFriendsScreen.route)),
                    userIdButton(
                        icReminder,
                        'Reminders',
                        const MyReminderScreen()),
                    userIdButton(
                        icSetting,
                        'Settings',
                        const SettingScreen()),
                    userIdButton(icHelp, 'Help', Container()),
                    userIdButton(icUserPrivacy, 'Privacy Center', Container()),
                    SizedBox(height: deviceHeight(context) * 0.02)
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius));
  }

  userIdButton(String icon, String title, Widget screen) {
    return AnimationWidget(
        message: 'More',
        color: colorBG,
        widget: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            height: 53,
            decoration: decoration(colorWhite, 6),
            child: Row(
              children: [
                SizedBox(width: deviceWidth(context) * 0.03),
                Image.asset(icon, width: deviceWidth(context) * 0.06),
                SizedBox(width: deviceWidth(context) * 0.05),
                Text(title, style: textStyle16Bold(colorIndigo)),
              ],
            ),
          ),
        ),
        screen: screen);
  }
}
