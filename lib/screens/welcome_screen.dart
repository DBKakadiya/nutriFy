import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrime/models/user_data.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:nutrime/screens/starting_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../handler/handler.dart';
import '../resources/resource.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = '/Welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserData userData =  UserData(
      name: '',
      goalReason: '',
      activityLevel: '',
      gender: '',
      age: 0,
      country: '',
      dateOfBirth: '',
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
  DatabaseHelper helper = DatabaseHelper();

  share() async {
    final packageInfo = await PackageInfo.fromPlatform();
    Share.share(
      'Download the ${packageInfo.appName} app from the Play Store to see latest news!\nhttps://play.google.com/store/apps/details?id=' +
          packageInfo.packageName,
    );
  }

  moreApps() async {
    // screenList.contains(isShowMoreApp)
    //     ? Navigator.of(context).pushNamed(MoreAppScreen.route)
    //     :
    await launchUrl(Uri.parse('https://play.google.com/store/apps/'));
  }

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
       if(data!.isNotEmpty){
         setState(() {
           userData = data.first;
         });
       }
        print('----userData1-----$userData');
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
      backgroundColor: colorWhite,
      body: SafeArea(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(imgBgWelcome), fit: BoxFit.cover)),
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    userData.weeklyGoal!.isEmpty
                        ? Navigator.of(context).pushNamed(StartingScreen.route)
                        : Navigator.of(context).pushReplacementNamed(
                            HomeScreen.route,
                            arguments: HomeScreenData(
                                index: 1,
                                date: DateTime(DateTime.now().year, DateTime.now().month,
                                    DateTime.now().day)));
                  },
                  child: Container(
                    height: 50.h,
                    width: 300.w,
                    decoration: BoxDecoration(
                        color: colorIndigo,
                        borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(45.r),
                            right: Radius.circular(45.r)),
                        boxShadow: [
                          BoxShadow(
                              color: colorIndigo.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(2, 2)),
                        ]),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 50.w),
                        Text('Get Started', style: textStyle20Bold(colorWhite)),
                        Row(
                          children: [
                            Image.asset(icStarted,
                                color: colorWhite,
                                width: 30.w),
                            SizedBox(width: 20.w),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    textIcon(icRate, 'Rate', () {}),
                    textIcon(icPrivacy, 'Privacy', () {}),
                    textIcon(icShare, 'Share', share),
                    textIcon(icMore, 'More', moreApps)
                  ],
                ),
                SizedBox(height: 25.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textIcon(String icon, String text, Function() onclick) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        height: 80.h,
        width: 70.w,
        decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: colorIndigo, width: 1.w),
            borderRadius: BorderRadius.circular(10.r)),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(icon,
                width: 25.w),
            Text(text, style: textStyle14(colorBlack))
          ],
        ),
      ),
    );
  }
}
