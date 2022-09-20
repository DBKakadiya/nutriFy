import 'package:flutter/material.dart';
import 'package:nutrime/screens/bottomBar/diary_setting.dart';
import 'package:nutrime/screens/bottomBar/my_reminders_screen.dart';
import 'package:nutrime/screens/bottomBar/step_counter_screen.dart';
import 'package:nutrime/screens/edit_profile_screen.dart';
import 'package:nutrime/screens/users/goal_screen.dart';
import 'package:nutrime/widgets/animation_widget.dart';

import '../resources/resource.dart';

class SettingScreen extends StatefulWidget {
  static const route = '/Setting-Screen';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
        title: Text('Settings', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight(context) * 0.037),
              settingTitle('My Account', deviceWidth(context) * 0.45),
              SizedBox(height: deviceHeight(context) * 0.01),
              settingsButton(
                  'My Goals',
                  const GoalsScreen()),
              settingsButton(
                  'Edit Profile',
                  const EditProfileScreen()),
              // settingsButton('Delete Account', () => null),
              // settingsButton('Change Password', () => null),
              // settingsButton('Log out', () => null),
              SizedBox(height: deviceHeight(context) * 0.025),
              settingTitle('Settings', deviceWidth(context) * 0.35),
              SizedBox(height: deviceHeight(context) * 0.01),
              // settingsButton('Appearance', () => null),
              settingsButton(
                  'Diary Settings',
                  const DiarySettingScreen()),
              settingsButton(
                  'Reminders',
                  const MyReminderScreen()),
              settingsButton('Privacy center', Container()),
              // settingsButton('Weekly Nutrition settings', () => null),
              settingsButton('Steps', const StepCounterScreen()),
              settingsButton('Push Notification', Container()),
              settingsButton('About us', Container()),
              settingsButton('Contact support', Container()),
              settingsButton('Feedback', Container()),
              SizedBox(height: deviceHeight(context) * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorWhite, width: 2.5) : null,
        boxShadow: [
          if(radius == 5)
            BoxShadow(
                color: colorIndigo.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(2, 2)),
        ]);
  }

  buttons(String icon, Function() onclick) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: (deviceHeight(context) * 0.08 -
              deviceHeight(context) * 0.042) / 2,
          horizontal: (deviceWidth(context) * 0.15 -
              deviceWidth(context) * 0.085) / 2),
      child: GestureDetector(
        onTap: onclick,
        child: Container(
          height: deviceHeight(context) * 0.042,
          width: deviceWidth(context) * 0.085,
          decoration: decoration(colorWhite, 5),
          alignment: Alignment.center,
          child: Image.asset(icon,
              width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  settingTitle(String title, double width) {
    return Container(
      height: deviceHeight(context) * 0.055,
      width: width,
      decoration: decoration(colorIndigo, 30),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title == 'My Account')
            Row(
              children: [
                Image.asset(icUser, color: colorWhite,
                    width: deviceWidth(context) * 0.05),
                SizedBox(width: deviceWidth(context) * 0.03),
              ],
            ),
          Text(title, style: textStyle16Bold(colorWhite)),
        ],
      ),
    );
  }

  settingsButton(String title, Widget screen) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: AnimationWidget(
          message: 'Setting', color: colorBG, widget: Container(
        height: deviceHeight(context) * 0.065,
        decoration: decoration(colorWhite, 6),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(title, style: textStyle16Bold(colorIndigo)),
          ],
        ),
      ), screen: screen),
    );
  }
}
