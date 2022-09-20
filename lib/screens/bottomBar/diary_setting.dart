import 'package:flutter/material.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/bottomBar/custom_meal_name_screen.dart';
import 'package:nutrime/screens/bottomBar/edit_reminder_screen.dart';

import '../users/goal_screen.dart';

class DiarySettingScreen extends StatefulWidget {
  static const route = '/Diary-Setting';

  const DiarySettingScreen({Key? key}) : super(key: key);

  @override
  State<DiarySettingScreen> createState() => _DiarySettingScreenState();
}

class _DiarySettingScreenState extends State<DiarySettingScreen> {
  bool isBreakfast = false;
  bool isLunch = false;
  bool isDinner = false;
  bool isSnack = false;
  bool isWeekly = false;

  List<String> typesReminder = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snacks',
  ];

  List<TimeOfDay> timeReminder = [
    const TimeOfDay(hour: 9, minute: 10),
    const TimeOfDay(hour: 13, minute: 00),
    const TimeOfDay(hour: 20, minute: 00),
    const TimeOfDay(hour: 17, minute: 10),
  ];

  List<bool> boolReminder = [false, false, false, false];

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
    title: Text('Diary Settings', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: deviceHeight(context) * 0.02),
          shadowTitle('Diary', deviceWidth(context) * 0.25),
          commonField(
              'Customize Meal Names',
              () => Navigator.of(context)
                  .pushNamed(CustomMealNameScreen.route)),
          commonField('Edit Goals',
              () => Navigator.of(context).pushNamed(GoalsScreen.route)),
          SizedBox(height: deviceHeight(context) * 0.02),
          shadowTitle('Reminders', deviceWidth(context) * 0.35),
          Column(
            children: List.generate(
                typesReminder.length,
                (index) => reminderField(
                    '${typesReminder[index]} (${timeReminder[index].hour}:${timeReminder[index].minute} ${timeReminder[index].period.name})',
                    () {
                      Navigator.of(context).pushNamed(
                          EditReminderScreen.route,
                          arguments: EditReminderData(
                              foodType: typesReminder[index],
                              time: timeReminder[index]));
                    },
                    boolReminder[index],
                    (val) async {
                      if (boolReminder[index] == false) {
                        setState(() {
                          boolReminder[index] = true;
                        });
                        // await onBreakfastReminder();
                      } else {
                        setState(() {
                          boolReminder[index] = false;
                        });
                        // await disableBreakfastNotification();
                      }
                    })),
          ),
          SizedBox(height: deviceHeight(context) * 0.02),
          Padding(
            padding: EdgeInsets.only(
                top: deviceHeight(context) * 0.012,
                bottom: deviceHeight(context) * 0.012,
                left: deviceWidth(context) * 0.08),
            child: Text('Weight', style: textStyle16Bold(colorIndigo)),
          ),
          reminderField('Weekly on Mondays (6:45 am)', () {}, isWeekly,
              (val) async {
            if (isWeekly == false) {
              setState(() {
                isWeekly = true;
              });
              // await onWeeklyReminder();
            } else {
              setState(() {
                isWeekly = false;
              });
              // await disableWeeklyNotification();
            }
          }),
          SizedBox(height: deviceHeight(context) * 0.1),
        ],
      ),
    ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: radius == 7 ? colorIndigo : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 30 ? Border.all(color: colorIndigo, width: 1) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: colorIndigo.withOpacity(0.30),
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
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: Container(
        height: deviceHeight(context) * 0.045,
        width: width,
        decoration: decoration(7),
        alignment: Alignment.center,
        child: Text(title, style: textStyle16Bold(colorWhite)),
      ),
    );
  }

  commonField(String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          width: deviceWidth(context),
          decoration: decoration(30),
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.04),
          alignment: Alignment.centerLeft,
          child: Text(title, style: textStyle14(colorIndigo)),
        ),
      ),
    );
  }

  reminderField(String title, Function() onClick, bool isReminder,
      Function(bool) onChanged) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          width: deviceWidth(context),
          decoration: decoration(30),
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.04),
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textStyle14(colorIndigo)),
              Padding(
                padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
                child: Switch(
                  value: isReminder,
                  onChanged: onChanged,
                  activeColor: colorIndigo,
                  activeTrackColor: colorIndigo.withOpacity(0.15),
                  inactiveThumbColor: colorIndigo.withOpacity(0.5),
                  inactiveTrackColor: colorIndigo.withOpacity(0.15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
