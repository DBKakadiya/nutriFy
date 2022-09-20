import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/bottomBar/add_exercise_screen.dart';
import 'package:nutrime/screens/create_screen/create_meal.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../models/cardio_exercise_data.dart';
import '../../models/meal_data.dart';
import '../../models/strength_exercise_data.dart';
import '../../screens/create_screen/create_food.dart';
import '../../screens/create_screen/create_recipe.dart';
import '../../screens/users/my_exercise_screen.dart';
import '../../screens/users/recipes_meals_foods_screen.dart';

class MyItems extends StatefulWidget {
  const MyItems({Key? key}) : super(key: key);

  @override
  State<MyItems> createState() => _MyItemsState();
}

class _MyItemsState extends State<MyItems> {
  DatabaseHelper helper = DatabaseHelper();
  List<MealData> mealData = [];
  List<RecipeData> recipeData = [];
  List<FoodData> foodData = [];
  List<CardioData> cardioData = [];
  List<StrengthData> strengthData = [];

  void getMealData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------mealData-----$data');
        if (data!.isNotEmpty) {
          setState((){
            mealData = data;
          });
        }
      });
    });
  }

  void getRecipeData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<RecipeData>?> recipeDataList = helper.getRecipeList();
      recipeDataList.then((data) {
        print('--------recipeData-----$data');
        if (data!.isNotEmpty) {
          setState((){
            recipeData = data;
          });
        }
      });
    });
  }

  void getFoodData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FoodData>?> foodDataList = helper.getFoodList();
      foodDataList.then((data) {
        print('--------foodData-----$data');
        if (data!.isNotEmpty) {
          setState((){
            foodData = data;
          });
        }
      });
    });
  }

  void getCardioData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CardioData>?> userDataList = helper.getCardioExerciseList();
      userDataList.then((data) {
        print('--------cardioData-----$data');
        setState(() {
          cardioData = data!;
        });
      });
    });
  }

  void getStrengthData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<StrengthData>?> userDataList =
          helper.getStrengthExerciseList();
      userDataList.then((data) {
        print('--------strengthData-----$data');
        setState(() {
          strengthData = data!;
        });
      });
    });
  }

  @override
  void initState() {
    getMealData();
    getRecipeData();
    getFoodData();
    getCardioData();
    getStrengthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<int> itemCount = [
      mealData.length,
      recipeData.length,
      foodData.length,
      cardioData.length,
      strengthData.length
    ];
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 0.68),
        itemCount: 5,
        itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth(context) * 0.02,
                  right: deviceWidth(context) * 0.02,
                  top: deviceHeight(context) * 0.02),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (i == 0 || i == 1 || i == 2) {
                        Navigator.of(context).pushNamed(MealsRecipesFoods.route,
                            arguments: i == 0
                                ? 0
                                : i == 1
                                    ? 1
                                    : 2);
                      }
                      if (i == 3 || i == 4) {
                        Navigator.of(context).pushNamed(MyExercises.route,
                            arguments: i == 3 ? 0 : 1);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          const Spacer(),
                          SizedBox(
                            height: deviceHeight(context) * 0.08,
                            width: i == 0
                                ? deviceWidth(context) * 0.25
                                : deviceWidth(context) * 0.18,
                            child: Image.asset(itemImages[i], fit: BoxFit.fill),
                          ),
                          Text(itemTitles[i],
                              style: textStyle14Bold(colorIndigo)),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              String selType = (DateTime.now().hour > 4 &&
                                      DateTime.now().hour <= 10)
                                  ? titles[0]
                                  : (DateTime.now().hour > 10 &&
                                          DateTime.now().hour <= 15)
                                      ? titles[1]
                                      : (DateTime.now().hour > 15 &&
                                              DateTime.now().hour <= 18)
                                          ? titles[3]
                                          : titles[2];
                              String date = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());
                              if (i == 0) {
                                Navigator.of(context).pushNamed(
                                    CreateMeal.route,
                                    arguments: CreateMealData(
                                        action: 'Add',
                                        mealData: MealData(
                                            id: 0,
                                            type: selType,
                                            date: date,
                                            image: '',
                                            name: '',
                                            calorie: '',
                                            fat: '',
                                            satFat: '',
                                            sodium: '',
                                            cholesterol: '',
                                            carbohydrates: '',
                                            potassium: '',
                                            protein: '',
                                            fiber: '',
                                            sugar: '',
                                            vitaminA: '',
                                            vitaminC: '',
                                            calcium: '',
                                            iron: '',
                                            time: '',
                                            direction: '')));
                              }
                              if (i == 1) {
                                Navigator.of(context).pushNamed(
                                    CreateRecipe.route,
                                    arguments: CreateRecipeData(
                                        action: 'Add',
                                        recipeData: RecipeData(
                                            id: 0,
                                            type: selType,
                                            date: date,
                                            recipeName: '',
                                            servings: 0,
                                            ingredients: '',
                                            calorie: '',
                                            time: '')));
                              }
                              if (i == 2) {
                                Navigator.of(context).pushNamed(
                                    CreateFood.route,
                                    arguments: CreateFoodData(
                                        action: 'Add',
                                        foodData: FoodData(
                                            id: 0,
                                            type: selType,
                                            date: date,
                                            brandName: '',
                                            description: '',
                                            servingSize: 0,
                                            servingUnit: '',
                                            servingContainer: 0,
                                            calorie: '',
                                            fat: '',
                                            satFat: '',
                                            sodium: '',
                                            cholesterol: '',
                                            carbohydrates: '',
                                            potassium: '',
                                            protein: '',
                                            fiber: '',
                                            sugar: '',
                                            vitaminA: '',
                                            vitaminC: '',
                                            calcium: '',
                                            iron: '',
                                            time: '')));
                              }
                              if (i == 3 || i == 4) {
                                Navigator.of(context).pushNamed(
                                    AddExerciseScreen.route,
                                    arguments: AddExerciseData(
                                        exerciseType:
                                            i == 3 ? 'Cardio' : 'Strength',
                                        selDate: DateFormat('yyyy-MM-dd')
                                            .format(DateTime.now())));
                              }
                            },
                            child: Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                  color: colorIndigo,
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(10))),
                              alignment: Alignment.center,
                              child: Text('Add',
                                  style: textStyle12Bold(colorWhite)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: colorIndigo,
                      radius: 10,
                      child: Text('${itemCount[i]}',
                          style: textStyle10Bold(colorWhite)),
                    ),
                  )
                ],
              ),
            ));
  }
}
