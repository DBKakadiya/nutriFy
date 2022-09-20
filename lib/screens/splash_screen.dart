import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrime/screens/welcome_screen.dart';

import '../resources/resource.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4),
        () => Navigator.of(context).pushReplacementNamed(WelcomeScreen.route));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: colorWhite, body: getSplashScreen());
  }

  Widget getSplashScreen() {
    return SafeArea(
      child: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(imgSplashBG), fit: BoxFit.fill)),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imgSplashCircle, width: 250.w),
                SizedBox(
                  height: 15.h,
                ),
                Text('NutriME', style: textStyle36Bold(colorIndigo)),
              ],
            ),
            Positioned(
              bottom: 30.h,
              child: Container(
                  height: 20.h,
                  width: 20.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: CircularProgressIndicator(
                      color: Colors.indigo, strokeWidth: 2.5.w)),
            )
          ],
        ),
      ),
    );
  }
}
