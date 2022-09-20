import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/meal_data.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/create_screen/create_meal.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../models/food_data.dart';
import '../../models/quickAdd_data.dart';
import '../../models/recipe_data.dart';
import '../create_screen/create_food.dart';
import '../create_screen/create_recipe.dart';

class MealsRecipesFoods extends StatefulWidget {
  final int index;
  static const route = '/Meals-Recipes-Foods';

  const MealsRecipesFoods({required this.index});

  @override
  State<MealsRecipesFoods> createState() => _MealsRecipesFoodsState();
}

class _MealsRecipesFoodsState extends State<MealsRecipesFoods>
    with SingleTickerProviderStateMixin {
  DatabaseHelper helper = DatabaseHelper();

  // final TextEditingController _searchController = TextEditingController();
  TabController? _tabController;
  List<MealData> mealData = [];
  List<RecipeData> recipeData = [];
  List<FoodData> foodData = [];
  List<QuickAddData> quickAddData = [];

  void getMealData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------mealData-----$data');
        if (data!.isNotEmpty) {
          setState(() {
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
          setState(() {
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
          setState(() {
            foodData = data;
          });
        }
      });
    });
  }

  @override
  void initState() {
    getMealData();
    getRecipeData();
    getFoodData();
    _tabController = TabController(vsync: this, length: 3);
    setState(() {
      _tabController!.index = widget.index;
    });
    print("Selected Index: " + _tabController!.index.toString());
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: colorBG,
        appBar: AppBar(
            toolbarHeight: deviceHeight(context) * 0.08,
            backgroundColor: colorWhite,
            elevation: 5,
            shadowColor: colorIndigo.withOpacity(0.25),
            leadingWidth: deviceWidth(context) * 0.15,
            leading: buttons(icBack, () => Navigator.of(context).pop()),
            title: Text('Meals, Recipes & Foods',
                style: textStyle20Bold(colorIndigo)),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: colorIndigo,
              indicatorWeight: 2.5,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.04),
              labelPadding: EdgeInsets.zero,
              tabs: [
                Tab(
                  child: Text('Meals', style: textStyle14Bold(colorIndigo)),
                ),
                Tab(
                  child: Text('Recipes', style: textStyle14Bold(colorIndigo)),
                ),
                Tab(
                  child: Text('Foods', style: textStyle14Bold(colorIndigo)),
                ),
              ],
            )),
        body: TabBarView(controller: _tabController, children: [
          if (mealData.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                centerImage(imgMeals),
                const SizedBox(height: 20),
                belowText('Meals',
                    'Make meals that you eat together often to speed up logging.')
              ],
            ),
          if (mealData.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      itemCount: mealData.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(CreateMeal.route,
                                  arguments: CreateMealData(
                                      action: 'Update',
                                      mealData: mealData[index]));
                            },
                            child: Container(
                              height: 60,
                              width: deviceWidth(context),
                              decoration: decoration(0),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) * 0.05),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(mealData[index].name!,
                                      style: textStyle16Bold(colorIndigo)),
                                  Text(mealData[index].calorie!,
                                      style: textStyle16Bold(colorIndigo)),
                                ],
                              ),
                            ),
                          )),
                ),
              ],
            ),
          if (recipeData.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                centerImage(imgRecipes),
                const SizedBox(height: 20),
                belowText('Recipes',
                    'Create recipes to save time logging ingredients in the future.')
              ],
            ),
          if (recipeData.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      itemCount: recipeData.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  CreateRecipe.route,
                                  arguments: CreateRecipeData(
                                      action: 'Update',
                                      recipeData: recipeData[index]));
                            },
                            child: Container(
                              height: 60,
                              width: deviceWidth(context),
                              decoration: decoration(0),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.05),
                              alignment: Alignment.centerLeft,
                              child: Text(recipeData[index].recipeName!,
                                  style: textStyle16Bold(colorIndigo)),
                            ),
                          )),
                ),
              ],
            ),
          if (foodData.isEmpty)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                centerImage(imgFoodDonuts),
                const SizedBox(height: 20),
                belowText('Foods',
                    'Create your own food if you can’t find what you’re looking for in our database.')
              ],
            ),
          if (foodData.isNotEmpty)
            Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                      itemCount: foodData.length,
                      itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(CreateFood.route,
                                  arguments: CreateFoodData(
                                      action: 'Update',
                                      foodData: foodData[index]));
                            },
                            child: Container(
                              height: 60,
                              width: deviceWidth(context),
                              decoration: decoration(0),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.05),
                              alignment: Alignment.centerLeft,
                              child: Text(foodData[index].description!,
                                  style: textStyle16Bold(colorIndigo)),
                            ),
                          )),
                ),
              ],
            ),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: deviceHeight(context) * 0.01,
              right: deviceWidth(context) * 0.02),
          child: GestureDetector(
            onTap: () {
              String selType = (DateTime.now().hour > 4 &&
                      DateTime.now().hour <= 10)
                  ? titles[0]
                  : (DateTime.now().hour > 10 && DateTime.now().hour <= 15)
                      ? titles[1]
                      : (DateTime.now().hour > 15 && DateTime.now().hour <= 18)
                          ? titles[3]
                          : titles[2];
              String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
              if (_tabController!.index == 0) {
                Navigator.of(context).pushNamed(CreateMeal.route,
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
              if (_tabController!.index == 1) {
                Navigator.of(context).pushNamed(CreateRecipe.route,
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
              if (_tabController!.index == 2) {
                Navigator.of(context).pushNamed(CreateFood.route,
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
            },
            child: Container(
              height: deviceHeight(context) * 0.08,
              width: deviceWidth(context) * 0.15,
              decoration: BoxDecoration(
                  color: colorIndigo,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: colorIndigo.withOpacity(0.2),
                        blurRadius: 7,
                        offset: const Offset(1, 1))
                  ]),
              alignment: Alignment.center,
              child: Image.asset(icAdd, width: deviceWidth(context) * 0.08),
            ),
          ),
        ),
      )),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 30 ? Border.all(color: colorIndigo, width: 1) : null,
        boxShadow: [
          if (radius != 30)
            BoxShadow(
                color: colorIndigo.withOpacity(radius == 5 ? 0.3 : 0.1),
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

  centerImage(String image) {
    return Container(
      height: deviceHeight(context) * 0.14,
      width: deviceWidth(context) * 0.28,
      decoration:
          BoxDecoration(color: colorWhite, shape: BoxShape.circle, boxShadow: [
        BoxShadow(
            color: colorGrey.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(2, 2)),
      ]),
      alignment: Alignment.center,
      child: Image.asset(image,
          width: image == imgAllPizza
              ? deviceWidth(context) * 0.22
              : deviceWidth(context) * 0.17),
    );
  }

  belowText(String text, String subText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            textAlign: TextAlign.center, style: textStyle20Bold(colorIndigo)),
        const SizedBox(height: 15),
        SizedBox(
          width: deviceWidth(context) * 0.7,
          child: Text(subText,
              textAlign: TextAlign.center,
              style: textStyle16Medium(colorIndigo.withOpacity(0.5))
                  .copyWith(height: 1.3)),
        )
      ],
    );
  }

// searchBar() {
//   return Padding(
//     padding: EdgeInsets.symmetric(
//         horizontal: deviceWidth(context) * 0.05,
//         vertical: deviceHeight(context) * 0.03),
//     child: Container(
//       height: deviceHeight(context) * 0.07,
//       width: deviceWidth(context),
//       decoration: decoration(30),
//       padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Image.asset(imgSearch, width: deviceWidth(context) * 0.06),
//           SizedBox(
//               width: deviceWidth(context) * 0.65,
//               child: TextFormField(
//                 controller: _searchController,
//                 cursorColor: colorIndigo,
//                 textCapitalization: TextCapitalization.sentences,
//                 decoration: InputDecoration(
//                   hintText: 'Search for an Exercise',
//                   hintStyle: textStyle14(colorGrey.withOpacity(0.7)),
//                   border: InputBorder.none,
//                 ),
//                 keyboardType: TextInputType.text,
//               ))
//         ],
//       ),
//     ),
//   );
// }
}
