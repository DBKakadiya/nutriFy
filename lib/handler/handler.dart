import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:nutrime/models/cardio_exercise_data.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:nutrime/models/meal_data.dart';
import 'package:nutrime/models/notes_data.dart';
import 'package:nutrime/models/quickAdd_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/models/strength_exercise_data.dart';
import 'package:nutrime/models/user_data.dart';
import 'package:nutrime/models/water_data.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../models/goal_data.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper; // Singleton DatabaseHelper
  static Database? _database; // Singleton Database

  String userTable = 'user_table';
  String userName = 'name';
  String userGender = 'gender';
  String userAge = 'age';
  String userDateOfBirth = 'dateOfBirth';
  String userCountry = 'country';
  String userHeight = 'height';
  String userWeight = 'weight';
  String userCurrentWeight = 'currentWeight';
  String userReason = 'goalReason';
  String userActivityLevel = 'activityLevel';
  String userGoalWeight = 'goalWeight';
  String userWeeklyGoal = 'weeklyGoal';
  String userStartDate = 'startDate';
  String userCaloriesGoal = 'caloriesGoal';
  String carbohydrates = 'carbohydrates';
  String percentageCarbohydrates = 'percentageCarbohydrates';
  String protein = 'protein';
  String percentageProtein = 'percentageProtein';
  String fat = 'fat';
  String percentageFat = 'percentageFat';
  String satFat = 'satFat';
  String cholesterol = 'cholesterol';
  String sodium = 'sodium';
  String potassium = 'potassium';
  String fiber = 'fiber';
  String sugars = 'sugars';
  String vitaminA = 'vitaminA';
  String vitaminC = 'vitaminC';
  String calcium = 'calcium';
  String iron = 'iron';

  String userGoalTable = 'userGoal_Table';
  String userGoal = 'goal';

  String weightTable = 'weight_table';
  String weightDate = 'date';
  String weight = 'weight';
  String weightImage = 'image';

  String waterTable = 'water_table';
  String waterDate = 'date';
  String water = 'water';

  String noteTable = 'notes_table';
  String noteDate = 'date';
  String foodNote = 'foodNote';
  String exerciseNote = 'exerciseNote';

  String cardioExerciseTable = 'cardio_exercise_table';
  String cardioExerciseId = 'id';
  String cardioExerciseDate = 'date';
  String cardioExerciseDescription = 'description';
  String cardioExerciseTime = 'time';
  String cardioExerciseCalorie = 'calorie';

  String strengthExerciseTable = 'strength_exercise_table';
  String strengthExerciseId = 'id';
  String strengthExerciseDate = 'date';
  String strengthExerciseDescription = 'description';
  String strengthExerciseHashOfSet = 'hashOfSet';
  String strengthExerciseRepetitionSet = 'repetitionSet';
  String strengthExerciseWeightPerRepetition = 'weightPerRepetition';
  String strengthExerciseTime = 'time';
  String strengthExerciseCalorie = 'calorie';

  String mealTable = 'meal_table';
  String mealId = 'id';
  String mealType = 'type';
  String mealDate = 'date';
  String mealImage = 'image';
  String mealName = 'name';
  String mealCalories = 'calorie';
  String mealFat = 'fat';
  String mealSatFat = 'satFat';
  String mealSodium = 'sodium';
  String mealCholesterol = 'cholesterol';
  String mealCarbohydrates = 'carbohydrates';
  String mealPotassium = 'potassium';
  String mealProtein = 'protein';
  String mealFiber = 'fiber';
  String mealSugar = 'sugar';
  String mealVitaminA = 'vitaminA';
  String mealVitaminC = 'vitaminC';
  String mealCalcium = 'calcium';
  String mealIron = 'iron';
  String mealTime = 'time';
  String mealDirection = 'direction';

  String foodTable = 'food_table';
  String foodId = 'id';
  String foodType = 'type';
  String foodDate = 'date';
  String foodBrandName = 'brandName';
  String foodDescription = 'description';
  String foodServingSize = 'servingSize';
  String foodServingUnit = 'servingUnit';
  String foodServingContainer = 'servingContainer';
  String foodCalories = 'calorie';
  String foodFat = 'fat';
  String foodSatFat = 'satFat';
  String foodSodium = 'sodium';
  String foodCholesterol = 'cholesterol';
  String foodCarbohydrates = 'carbohydrates';
  String foodPotassium = 'potassium';
  String foodProtein = 'protein';
  String foodFiber = 'fiber';
  String foodSugar = 'sugar';
  String foodVitaminA = 'vitaminA';
  String foodVitaminC = 'vitaminC';
  String foodCalcium = 'calcium';
  String foodIron = 'iron';
  String foodTime = 'time';

  String recipeTable = 'recipe_table';
  String recipeId = 'id';
  String recipeType = 'type';
  String recipeDate = 'date';
  String recipeRecipeName = 'recipeName';
  String recipeServings = 'servings';
  String recipeIngredients = 'ingredients';
  String recipeCalories = 'calorie';
  String recipeTime = 'time';

  String quickAddTable = 'quickAdd_table';
  String quickAddId = 'id';
  String quickAddType = 'type';
  String quickAddDate = 'date';
  String quickAddCalories = 'calorie';
  String quickAddCarbohydrates = 'carbohydrates';
  String quickAddFat = 'fat';
  String quickAddProtein = 'protein';
  String quickAddTime = 'time';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> get database async {
    _database ??= await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath() + '/nutriMe.db';
    var todosDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void generate() async {
    final dbFolder = await getDatabasesPath();
    print('---getDatabasePath---------$dbFolder');
    File source1 = File(dbFolder + '/nutriMe.db');
    print('---source1---------${source1.path}');
    File source2 = File(dbFolder + '/stepCount.db');
    print('---source2---------${source2.path}');

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

    String newPath = copyTo.path + "/nutriMe.db";
    print('-newPath---------$newPath');
    String newStepPath = copyTo.path + "/stepCount.db";
    print('-newStepPath---------$newStepPath');
    await source1.copy(newPath);
    await source2.copy(newStepPath);
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $userTable($userName TEXT, $userGender TEXT, $userAge INTEGER, '
        '$userDateOfBirth TEXT, $userCountry TEXT, $userHeight TEXT, $userWeight TEXT,'
        '$userCurrentWeight TEXT, $userReason TEXT, $userActivityLevel TEXT, $userGoalWeight TEXT, '
        '$userWeeklyGoal TEXT, $userStartDate TEXT, $userCaloriesGoal TEXT, '
        '$carbohydrates TEXT, $percentageCarbohydrates INTEGER, $protein TEXT, '
        '$percentageProtein INTEGER, $fat TEXT, $percentageFat INTEGER, '
        '$satFat TEXT, $cholesterol TEXT, $sodium TEXT, $potassium TEXT, $fiber TEXT, '
        '$sugars TEXT, $vitaminA TEXT, $vitaminC TEXT, $calcium TEXT, $iron TEXT)');
    await db.execute('CREATE TABLE $userGoalTable($userGoal TEXT)');
    await db.execute(
        'CREATE TABLE $weightTable($weightDate TEXT, $weight TEXT, $weightImage TEXT)');
    await db.execute('CREATE TABLE $waterTable($weightDate TEXT, $water TEXT)');
    await db.execute(
        'CREATE TABLE $noteTable($noteDate TEXT, $foodNote TEXT, $exerciseNote TEXT)');
    await db.execute(
        'CREATE TABLE $cardioExerciseTable($cardioExerciseId INTEGER, $cardioExerciseDate TEXT, '
        '$cardioExerciseDescription TEXT, $cardioExerciseTime TEXT, $cardioExerciseCalorie TEXT)');
    await db.execute(
        'CREATE TABLE $strengthExerciseTable($strengthExerciseId INTEGER, $strengthExerciseDate TEXT, '
        '$strengthExerciseDescription TEXT, $strengthExerciseHashOfSet TEXT, $strengthExerciseRepetitionSet TEXT, '
        '$strengthExerciseWeightPerRepetition TEXT, $strengthExerciseTime TEXT, $strengthExerciseCalorie TEXT)');
    await db.execute(
        'CREATE TABLE $mealTable($mealId INTEGER, $mealType TEXT, $mealDate TEXT, $mealImage TEXT, '
        '$mealName TEXT, $mealCalories TEXT, $mealFat TEXT, $mealSatFat TEXT, $mealSodium TEXT, '
        '$mealCholesterol TEXT, $mealCarbohydrates TEXT, $mealPotassium TEXT, '
        '$mealProtein TEXT, $mealFiber TEXT, $mealSugar TEXT, $mealVitaminA TEXT, '
        '$mealVitaminC TEXT, $mealCalcium TEXT, $mealIron TEXT, $mealTime TEXT, $mealDirection TEXT)');
    await db.execute(
        'CREATE TABLE $foodTable($foodId INTEGER, $foodType TEXT, $foodDate TEXT, '
        '$foodBrandName TEXT, $foodDescription TEXT, $foodServingSize INTEGER, '
        '$foodServingUnit TEXT, $foodServingContainer INTEGER, $foodCalories TEXT, '
        '$foodFat TEXT, $foodSatFat TEXT, $foodSodium TEXT, $foodCholesterol TEXT, '
        '$foodCarbohydrates TEXT, $foodPotassium TEXT, $foodProtein TEXT, $foodFiber TEXT, '
        '$foodSugar TEXT, $foodVitaminA TEXT, $foodVitaminC TEXT, $foodCalcium TEXT, '
        '$foodIron TEXT, $foodTime TEXT)');
    await db.execute(
        'CREATE TABLE $recipeTable($recipeId INTEGER, $recipeType TEXT, $recipeDate TEXT, '
        '$recipeRecipeName TEXT, $recipeServings INTEGER, $recipeIngredients TEXT, '
        '$recipeCalories TEXT, $recipeTime TEXT)');
    await db.execute(
        'CREATE TABLE $quickAddTable($quickAddId INTEGER, $quickAddType TEXT, $quickAddDate TEXT, '
        '$quickAddCalories TEXT, $quickAddCarbohydrates TEXT, $quickAddFat TEXT, '
        '$quickAddProtein TEXT, $quickAddTime TEXT)');
  }

  //-------------------------
  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database db = await database;
    var result = await db.query(userTable);
    return result;
  }

  Future<List<Map<String, dynamic>>> getGoalMapList() async {
    Database db = await database;
    var result = await db.query(userGoalTable, orderBy: '$userGoal ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getWeightMapList() async {
    Database db = await database;
    var result = await db.query(weightTable, orderBy: '$weightDate ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getWaterMapList() async {
    Database db = await database;
    var result = await db.query(waterTable, orderBy: '$waterDate ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await database;
    var result = await db.query(noteTable, orderBy: '$noteDate ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getCardioExerciseMapList() async {
    Database db = await database;
    var result =
        await db.query(cardioExerciseTable, orderBy: '$cardioExerciseId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getStrengthExerciseMapList() async {
    Database db = await database;
    var result = await db.query(strengthExerciseTable,
        orderBy: '$strengthExerciseId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getMealMapList() async {
    Database db = await database;
    var result = await db.query(mealTable, orderBy: '$mealId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getFoodMapList() async {
    Database db = await database;
    var result = await db.query(foodTable, orderBy: '$foodId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getRecipeMapList() async {
    Database db = await database;
    var result = await db.query(recipeTable, orderBy: '$recipeId ASC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getQuickAddMapList() async {
    Database db = await database;
    var result = await db.query(quickAddTable, orderBy: '$quickAddId ASC');
    return result;
  }

  //-------------------------

//----------------------------------
  Future<int> insertUserData(UserData userData) async {
    Database db = await database;
    var result = await db.insert(userTable, userData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertGoals(Goals goals) async {
    Database db = await database;
    var result = await db.insert(userGoalTable, goals.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertWeight(WeightData weightData) async {
    Database db = await database;
    var result = await db.insert(weightTable, weightData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertWater(WaterData waterData) async {
    Database db = await database;
    var result = await db.insert(waterTable, waterData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertNote(NotesData notesData) async {
    Database db = await database;
    var result = await db.insert(noteTable, notesData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertCardioExercise(CardioData cardioData) async {
    Database db = await database;
    var result = await db.insert(cardioExerciseTable, cardioData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertStrengthExercise(StrengthData strengthData) async {
    Database db = await database;
    var result = await db.insert(strengthExerciseTable, strengthData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertMeal(MealData mealData) async {
    Database db = await database;
    var result = await db.insert(mealTable, mealData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertFood(FoodData foodData) async {
    Database db = await database;
    var result = await db.insert(foodTable, foodData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertRecipe(RecipeData recipeData) async {
    Database db = await database;
    var result = await db.insert(recipeTable, recipeData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> insertQuickAdd(QuickAddData quickAddData) async {
    Database db = await database;
    var result = await db.insert(quickAddTable, quickAddData.toMap());
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

//----------------------------------

//----------------------------------
  Future<int> updateUserData(UserData userData) async {
    var db = await database;
    var result = await db.update(userTable, userData.toMap(),
        where: '$userName = ?', whereArgs: [userData.name]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateWeightData(WeightData weightData) async {
    var db = await database;
    var result = await db.update(weightTable, weightData.toMap(),
        where: '$weightDate = ?', whereArgs: [weightData.date]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateWaterData(WaterData waterData) async {
    var db = await database;
    var result = await db.update(waterTable, waterData.toMap(),
        where: '$waterDate = ?', whereArgs: [waterData.date]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateNotesData(NotesData notesData) async {
    var db = await database;
    var result = await db.update(noteTable, notesData.toMap(),
        where: '$noteDate = ?', whereArgs: [notesData.date]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateCardioExerciseData(CardioData cardioData) async {
    var db = await database;
    var result = await db.update(cardioExerciseTable, cardioData.toMap(),
        where: '$cardioExerciseId = ?', whereArgs: [cardioData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateStrengthExerciseData(StrengthData strengthData) async {
    var db = await database;
    var result = await db.update(strengthExerciseTable, strengthData.toMap(),
        where: '$strengthExerciseId = ?', whereArgs: [strengthData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateMealData(MealData mealData) async {
    var db = await database;
    var result = await db.update(mealTable, mealData.toMap(),
        where: '$mealId = ?', whereArgs: [mealData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateFoodData(FoodData foodData) async {
    var db = await database;
    var result = await db.update(foodTable, foodData.toMap(),
        where: '$foodId = ?', whereArgs: [foodData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateRecipeData(RecipeData recipeData) async {
    var db = await database;
    var result = await db.update(recipeTable, recipeData.toMap(),
        where: '$recipeId = ?', whereArgs: [recipeData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> updateQuickAddData(QuickAddData quickAddData) async {
    var db = await database;
    var result = await db.update(quickAddTable, quickAddData.toMap(),
        where: '$quickAddId = ?', whereArgs: [quickAddData.id]);
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

//----------------------------------

//----------------------------------
  Future<int> deleteUserData(String name) async {
    var db = await database;
    var result =
        await db.rawDelete('DELETE FROM $userTable WHERE $userName = $name');
    return result;
  }

  Future<int> deleteGoals(String goal) async {
    var db = await database;
    var result = await db
        .rawDelete('DELETE FROM $userGoalTable WHERE ($userGoal = $goal)');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteWeight(String date) async {
    var db = await database;
    var result = await db
        .rawDelete('DELETE FROM $weightTable WHERE (${weightDate.split(' ')[0]} = $date)');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteWater(String date) async {
    var db = await database;
    var result = await db
        .rawDelete('DELETE FROM $waterTable WHERE ($waterDate = $date)');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteNote(String date) async {
    var db = await database;
    var result =
        await db.rawDelete('DELETE FROM $noteTable WHERE ($noteDate = $date)');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteCardioExercise(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $cardioExerciseTable WHERE $cardioExerciseId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteStrengthExercise(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $strengthExerciseTable WHERE $strengthExerciseId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteMeal(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $mealTable WHERE $mealId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteFood(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $foodTable WHERE $foodId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteRecipe(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $recipeTable WHERE $recipeId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

  Future<int> deleteQuickAdd(int id) async {
    var db = await database;
    var result = await db.rawDelete(
        'DELETE FROM $quickAddTable WHERE $quickAddId = $id');
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    return result;
  }

//----------------------------------

//----------------------------------

  Future<void> cleanGoals() async {
    try {
      var db = await database;
      await db.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(userGoalTable);
        await batch.commit();
      });
      final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
      int.parse(androidDeviceInfo.version.release) < 11 ? generate() : null;
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

//----------------------------------

//----------------------------------
  Future<List<UserData>?> getUserDataList() async {
    var todoMapList = await getUserMapList();
    int count = todoMapList.length;
    List<UserData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(UserData.fromMap(todoMapList[i]));
    }
    return data;
  }

  Future<List<Goals>?> getGoalsList() async {
    var todoList = await getGoalMapList();
    int count = todoList.length;
    List<Goals>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(Goals.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<WeightData>?> getWeightList() async {
    var todoList = await getWeightMapList();
    int count = todoList.length;
    List<WeightData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(WeightData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<WaterData>?> getWaterList() async {
    var todoList = await getWaterMapList();
    int count = todoList.length;
    List<WaterData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(WaterData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<NotesData>?> getNoteList() async {
    var todoList = await getNoteMapList();
    int count = todoList.length;
    List<NotesData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(NotesData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<CardioData>?> getCardioExerciseList() async {
    var todoList = await getCardioExerciseMapList();
    int count = todoList.length;
    List<CardioData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(CardioData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<StrengthData>?> getStrengthExerciseList() async {
    var todoList = await getStrengthExerciseMapList();
    int count = todoList.length;
    List<StrengthData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(StrengthData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<MealData>?> getMealList() async {
    var todoList = await getMealMapList();
    int count = todoList.length;
    List<MealData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(MealData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<FoodData>?> getFoodList() async {
    var todoList = await getFoodMapList();
    int count = todoList.length;
    List<FoodData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(FoodData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<RecipeData>?> getRecipeList() async {
    var todoList = await getRecipeMapList();
    int count = todoList.length;
    List<RecipeData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(RecipeData.fromMap(todoList[i]));
    }
    return data;
  }

  Future<List<QuickAddData>?> getQuickAddList() async {
    var todoList = await getQuickAddMapList();
    int count = todoList.length;
    List<QuickAddData>? data = [];
    for (int i = 0; i < count; i++) {
      data.add(QuickAddData.fromMap(todoList[i]));
    }
    return data;
  }

//----------------------------------

}
