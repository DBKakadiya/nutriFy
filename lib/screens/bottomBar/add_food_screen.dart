import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:nutrime/models/meal_data.dart';
import 'package:nutrime/models/quickAdd_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/screens/create_screen/create_meal.dart';
import 'package:nutrime/screens/create_screen/create_recipe.dart';

import '../../resources/resource.dart';
import '../create_screen/create_food.dart';
import '../create_screen/quick_add.dart';

class AddFoodScreenData {
  final String foodType;
  final String selDate;

  AddFoodScreenData({required this.foodType, required this.selDate});
}

class AddFoodScreen extends StatefulWidget {
  final AddFoodScreenData data;
  static const route = '/Add-Food';

  const AddFoodScreen({required this.data});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  String selectedType = 'Breakfast';

  List<String> foodTypes = [
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack',
  ];

  @override
  void initState() {
    setState(() {
      selectedType = widget.data.foodType;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: colorBG,
        appBar: AppBar(
            toolbarHeight: deviceHeight(context) * 0.08,
            backgroundColor: colorWhite,
            elevation: 5,
            shadowColor: colorIndigo.withOpacity(0.25),
            leadingWidth: deviceWidth(context) * 0.15,
            leading: buttons(icBack, () => Navigator.of(context).pop()),
            title: DropdownButtonHideUnderline(
              child: DropdownButton2(
                  value: selectedType,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedType = newValue!;
                    });
                  },
                  icon: Icon(Icons.arrow_drop_down,
                      color: colorIndigo, size: deviceWidth(context) * 0.09),
                  alignment: Alignment.centerLeft,
                  dropdownOverButton: false,
                  dropdownMaxHeight:
                      deviceHeight(context) * 0.065 * foodTypes.length,
                  dropdownWidth: deviceWidth(context) * 0.35,
                  dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: colorIndigo)),
                  items:
                      foodTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: textStyle20Bold(colorIndigo)),
                    );
                  }).toList()),
            ),
            bottom: TabBar(
              indicatorColor: colorIndigo,
              indicatorWeight: 2.5,
              indicatorPadding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.03),
              labelPadding: EdgeInsets.zero,
              tabs: [
                Tab(
                  child: Text('My Meals', style: textStyle14Bold(colorIndigo)),
                ),
                Tab(
                  child:
                      Text('My Recipes', style: textStyle14Bold(colorIndigo)),
                ),
                Tab(
                  child: Text('My Foods', style: textStyle14Bold(colorIndigo)),
                ),
              ],
            )),
        body: TabBarView(children: [
          Stack(
            children: [
              commonContainer(colorMyMeals),
              Positioned(
                top: 0,
                child: Container(
                  height: deviceHeight(context) * 0.32,
                  width: deviceWidth(context),
                  decoration: const BoxDecoration(
                      color: colorBG,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(60))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageButton(
                              imgCreateMeal,
                              colorTextMyMeal,
                              'Create a Meal',
                              () => Navigator.of(context).pushNamed(
                                  CreateMeal.route,
                                  arguments: CreateMealData(
                                      action: 'Add',
                                      mealData: MealData(
                                          id: 0,
                                          type: selectedType,
                                          date: widget.data.selDate,
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
                                          direction: '')))),
                          SizedBox(width: deviceWidth(context) * 0.045),
                          imageButton(
                              imgQuickAdd,
                              colorTextMyMeal,
                              'Quick Add',
                              () => Navigator.of(context).pushNamed(
                                  QuickAddScreen.route,
                                  arguments: QuickAddScreenData(
                                      action: 'Add',
                                      quickAddData: QuickAddData(
                                          id: 0,
                                          type: selectedType,
                                          date: widget.data.selDate,
                                          calorie: '',
                                          carbohydrates: '',
                                          fat: '',
                                          protein: '',
                                          time: '')))),
                          // SizedBox(width: deviceWidth(context) * 0.045),
                          // imageButton(imgCopyMeal, colorTextMyMeal,
                          //     'Copy Previous Meal',() {}),
                        ],
                      ),
                      SizedBox(height: deviceHeight(context) * 0.05)
                    ],
                  ),
                ),
              ),
              belowText(
                  'Log Your Go-To Meals Faster',
                  'Create and save your favourite meals to profile quickly again and again.',
                  colorTextMyMeal),
              centerImage(imgMeals)
            ],
          ),
          Stack(
            children: [
              commonContainer(colorMyRecipes),
              Positioned(
                top: 0,
                child: Container(
                  height: deviceHeight(context) * 0.32,
                  width: deviceWidth(context),
                  decoration: const BoxDecoration(
                      color: colorBG,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(60))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageButton(imgCreateRecipe, colorTextMyRecipes,
                              'Create a Recipes', () {
                                Navigator.of(context).pushNamed(
                                    CreateRecipe.route,
                                    arguments: CreateRecipeData(
                                        action: 'Add',
                                        recipeData: RecipeData(
                                            id: 0,
                                            type: selectedType,
                                            date: widget.data.selDate,
                                            recipeName: '',
                                            servings: 0,
                                            ingredients: '',
                                            calorie: '',
                                            time: '')));
                              }),
                          // SizedBox(width: deviceWidth(context) * 0.045),
                          // imageButton(imgDiscoverRecipe,
                          //     colorTextMyRecipes, 'Discover Recipes',() {}),
                        ],
                      ),
                      SizedBox(height: deviceHeight(context) * 0.05)
                    ],
                  ),
                ),
              ),
              belowText(
                  'Mom’s Meatloaf Isn’t In The Database (Yet).',
                  'Let’s do this. search the database to profile your first food',
                  colorTextMyRecipes),
              centerImage(imgRecipes)
            ],
          ),
          Stack(
            children: [
              commonContainer(colorMyFoods),
              Positioned(
                top: 0,
                child: Container(
                  height: deviceHeight(context) * 0.32,
                  width: deviceWidth(context),
                  decoration: const BoxDecoration(
                      color: colorBG,
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(60))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          imageButton(
                              imgCreateFood, colorTextMyFoods, 'Create a Food',
                              () {
                            Navigator.of(context).pushNamed(CreateFood.route,
                                arguments: CreateFoodData(
                                    action: 'Add', foodData: FoodData(
                                    id: 0,
                                    type: selectedType,
                                    date: widget.data.selDate,
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
                          }),
                          SizedBox(width: deviceWidth(context) * 0.045),
                          imageButton(
                              imgQuickAdd,
                              colorTextMyFoods,
                              'Quick Add',
                              () => Navigator.of(context).pushNamed(
                                  QuickAddScreen.route,
                                  arguments: QuickAddScreenData(
                                      action: 'Add',
                                      quickAddData: QuickAddData(
                                          id: 0,
                                          type: selectedType,
                                          date: widget.data.selDate,
                                          calorie: '',
                                          carbohydrates: '',
                                          fat: '',
                                          protein: '',
                                          time: '')))),
                        ],
                      ),
                      SizedBox(height: deviceHeight(context) * 0.05)
                    ],
                  ),
                ),
              ),
              belowText(
                  'When 14 Million Foods Isn’t Enough.',
                  'Can’t find it in our database? create your own food for easy logging.',
                  colorTextMyFoods),
              centerImage(imgFoodDonuts)
            ],
          ),
        ]),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 30 ? Border.all(color: colorIndigo, width: 1) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: colorIndigo.withOpacity(0.3),
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
          child: Image.asset(icon,
              width: icon == icMoreVert
                  ? deviceWidth(context) * 0.055
                  : deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  commonContainer(Color color) {
    return Container(
      height: deviceHeight(context) * 704,
      width: deviceWidth(context),
      color: color,
    );
  }

  imageButton(String icon, Color iconColor, String title, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.15,
        width: deviceWidth(context) * 0.37,
        decoration: decoration(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(icon,
                color: iconColor, width: deviceWidth(context) * 0.1),
            Text(title, style: textStyle14Bold(colorIndigo))
          ],
        ),
      ),
    );
  }

  centerImage(String image) {
    return Positioned(
        top: deviceHeight(context) * 0.25,
        child: SizedBox(
          width: deviceWidth(context),
          child: Container(
            height: deviceHeight(context) * 0.14,
            width: deviceWidth(context) * 0.28,
            decoration: BoxDecoration(
                color: colorWhite,
                shape: BoxShape.circle,
                boxShadow: [
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
          ),
        ));
  }

  belowText(String text, String subText, Color color) {
    return Positioned(
        top: deviceHeight(context) * 0.4,
        child: SizedBox(
          width: deviceWidth(context),
          child: SizedBox(
            height:
                deviceHeight(context) * 0.704 - deviceHeight(context) * 0.32,
            width: deviceWidth(context) * 0.28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: deviceWidth(context) * 0.85,
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: textStyle20Bold(color))),
                SizedBox(height: deviceHeight(context) * 0.015),
                SizedBox(
                  width: deviceWidth(context) * 0.7,
                  child: Text(subText,
                      textAlign: TextAlign.center,
                      style: textStyle12(color).copyWith(height: 1.3)),
                )
              ],
            ),
          ),
        ));
  }
}
