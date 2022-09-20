import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../models/step_data.dart';
import '../widgets/debug.dart';
import 'database.dart';

class StepsDataHandler {
  static final StepsDataHandler _stepsDataHandler = StepsDataHandler._internal();

  factory StepsDataHandler() {
    return _stepsDataHandler;
  }

  StepsDataHandler._internal();

  static FlutterDatabase? _db;

  Future<FlutterDatabase?> initialize() async {
    _db =
    await $FloorFlutterDatabase.databaseBuilder('stepCount.db').build();
    return _db;
  }

  void generate() async {
    final dbFolder = await getDatabasesPath();
    print('---getDatabasePath---------$dbFolder');
    File source = File(dbFolder + '/stepCount.db');
    print('---source---------${source.path}');

    Directory _appDocDir = Directory('/storage/emulated/0/Download');
    Directory copyTo = Directory(_appDocDir.path + '/NutriMe');
    print('---copyTo---------${copyTo.path}');
    if ((await copyTo.exists())) {
      print("Path----------------------exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
    } else {
      print("not exist");
      if (await Permission.storage.request().isGranted) {
        await copyTo.create(recursive: true);
        print('------isCreated');
      } else {
        print('Please give permission');
      }
    }

    String newStepsCountPath = copyTo.path + "/stepCount.db";
    print('-newStepsCountPath---------$newStepsCountPath');
    await source.copy(newStepsCountPath);
  }

  Future<StepsData> insertSteps(StepsData data) async {
    final stepsInfo = _db!.stepsInfo;
    await stepsInfo.insertAllStepsData(data);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    Debug.printLog("Insert Steps Data Successfully  ==> " " Steps ==> " +
        data.steps.toString() +
        " Target Steps ==> " +
        data.targetSteps.toString() +
        " Calories ==> " +
        data.calorie.toString() +
        " Distance ==> " +
        data.distance.toString() +
        " Duration ==> " +
        data.duration.toString() +
        " CurrentTime ==> " +
        data.dateTime.toString() +
        " Date ==> " +
        data.stepDate.toString() +
        " Time ==> " +
        data.time.toString());
    return data;
  }

  Future<List<StepsData>> getAllStepsData() async {
    final stepsInfo = _db!.stepsInfo;
    final List<StepsData> result = await stepsInfo.getAllStepsData();
    for (var element in result) {
      Debug.printLog("Select Steps Data Successfully  ==> Id=>" +
          element.id.toString() +
          " Steps=>" +
          element.steps.toString() +
          " Target Steps=>" +
          element.targetSteps.toString() +
          " Date=>" +
          element.stepDate.toString() +
          " Time=>" +
          element.time.toString() +
          " DateTime=>" +
          element.dateTime.toString() +
          " Kcal=>" +
          element.calorie.toString() +
          " Duration=>" +
          element.duration.toString() +
          " Distance=>" +
          element.distance.toString());
    }
    return result;
  }

  Future<List<StepsData>> getStepsForCurrentWeek() async {
    final stepsInfo = _db!.stepsInfo;
    var prefDay = 1;
    List<StepsData>? steps;

    if (prefDay == 0) {
      steps = await stepsInfo.getStepsForCurrentWeekSun();
    } else if (prefDay == 1) {
      steps = await stepsInfo.getStepsForCurrentWeekMon();
    } else if (prefDay == -1) {
      steps = await stepsInfo.getStepsForCurrentWeekSat();
    }

    steps!.forEach((element) {
      Debug.printLog("-----------Steps For Week Days ==> " +
          " Steps ==> " +
          element.steps.toString() +
          " Date ==> " +
          element.stepDate.toString() +
          "------------");
    });
    return steps;
  }

  Future<int?> getTotalStepsForLast7Days() async {
    final stepsInfo = _db!.stepsInfo;
    final totalSteps = await stepsInfo.getTotalStepsForLast7Days();
    Debug.printLog("Steps from last 7 days =====> ${totalSteps!.steps}");
    return totalSteps.steps;
  }

  Future<List<StepsData>> getStepsForCurrentMonth() async {
    final stepsInfo = _db!.stepsInfo;
    final steps = await stepsInfo.getStepsForCurrentMonth();
    for (var element in steps) {
      Debug.printLog("-----------Steps For Month Days ==> " " Steps ==> " +
          element.steps.toString() +
          " Date ==> " +
          element.stepDate.toString() +
          "------------");
    }
    return steps;
  }

  Future<int?> getTotalStepsForCurrentMonth() async {
    final stepsInfo = _db!.stepsInfo;
    final totalSteps = await stepsInfo.getTotalStepsForCurrentMonth();
    Debug.printLog(
        "Total Steps from current month =====> ${totalSteps!.steps}");
    return totalSteps.steps;
  }

  Future<int?> getTotalStepsForCurrentWeek() async {
    final stepsInfo = _db!.stepsInfo;
    final totalSteps = await stepsInfo.getTotalStepsForCurrentWeek();
    Debug.printLog("Total Steps from current week =====> ${totalSteps!.steps}");
    return totalSteps.steps;
  }

  Future<List<StepsData>> getLast7DaysStepsData() async {
    final stepsInfo = _db!.stepsInfo;
    final List<StepsData> result = await stepsInfo.getLast7DaysStepsData();
    result.forEach((element) {
      Debug.printLog("Select Steps Data Successfully  ==> Id=>" +
          element.id.toString() +
          " Steps=>" +
          element.steps.toString() +
          " Target Steps=>" +
          element.targetSteps.toString() +
          " Date=>" +
          element.stepDate.toString() +
          " Time=>" +
          element.time.toString() +
          " DateTime=>" +
          element.dateTime.toString() +
          " Kcal=>" +
          element.calorie.toString() +
          " Duration=>" +
          element.duration.toString() +
          " Distance=>" +
          element.distance.toString());
    });
    return result;
  }
}
