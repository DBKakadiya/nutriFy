import 'dart:convert';

import 'package:nutrime/models/cardio_exercise_data.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:nutrime/models/quickAdd_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/models/strength_exercise_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_data.dart';

class SharedPreference {
  static const String _prefShowAd = 'is_show';

//-------int-----------
  Future<void> storeIntValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  getStatus(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? status = prefs.getInt(key) ?? 0;
    return status;
  }

  getIndex(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? index = prefs.getInt(key) ?? 0;
    return index;
  }

  getTargetStep(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? targetSteps = prefs.getInt(key) ?? 6000;
    return targetSteps;
  }

  getCurrentStep(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? currentSteps = prefs.getInt(key) ?? 0;
    return currentSteps;
  }

  getTotalStep(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? totalSteps = prefs.getInt(key) ?? 0;
    return totalSteps;
  }

  getOldTime(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? oldTime = prefs.getInt(key) ?? 0;
    return oldTime;
  }

//-------double-----------
  Future<void> storeDoubleValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  getDistance(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? steps = prefs.getDouble(key) ?? 0;
    return steps;
  }

  getCalories(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? oldCalories = prefs.getDouble(key) ?? 0;
    return oldCalories;
  }

//-------String-----------
  Future<void> storeStringValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  getDate(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? duration = prefs.getString(key) ??
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString();
    return duration;
  }

  getDuration(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? duration = prefs.getString(key) ?? "00h 0";
    return duration;
  }

//-------Bool-----------
  Future<void> storeBoolValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getBackup(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? backup = prefs.getBool(key) ?? false;
    return backup;
  }

  getPlay(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? stepBool = prefs.getBool(key) ?? true;
    return stepBool;
  }

//-------List String-----------
  Future<void> storeListValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  getGoalsList(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? periodDates = prefs.getStringList(key) ?? [];
    return periodDates;
  }

  // getMealsList(key) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   List<String>? meals = prefs.getStringList(key) ?? [];
  //   return meals;
  // }

//------------------
  static setSplashInterstitialAd(bool isShow) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_prefShowAd, isShow);
    print("===1534646 ===${SharedPreference.getSplashInterstitialAd()}");
  }

  static Future<bool> getSplashInterstitialAd() async {
    final pref = await SharedPreferences.getInstance();
    print('getdata========');
    print(pref.getBool(_prefShowAd));
    return pref.getBool(_prefShowAd) ?? false;
  }

//----------------------
}
