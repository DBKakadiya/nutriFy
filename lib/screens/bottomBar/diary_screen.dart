import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/meal_data.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:nutrime/models/water_data.dart';
import 'package:nutrime/screens/bottomBar/update_exercise_screen.dart';
import 'package:nutrime/screens/create_screen/create_food.dart';
import 'package:nutrime/screens/create_screen/create_recipe.dart';
import 'package:nutrime/screens/create_screen/quick_add.dart';
import 'package:nutrime/widgets/animation_widget.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/date/date_bloc.dart';
import '../../blocs/date/date_state.dart';
import '../../handler/handler.dart';
import '../../models/cardio_exercise_data.dart';
import '../../models/food_data.dart';
import '../../models/notes_data.dart';
import '../../models/quickAdd_data.dart';
import '../../models/strength_exercise_data.dart';
import '../../models/user_data.dart';
import '../../resources/resource.dart';
import '../../widgets/notes_Exercise_dialog.dart';
import '../create_screen/create_meal.dart';
import 'add_food_screen.dart';
import 'add_note_screen.dart';
import 'add_water_screen.dart';
import 'nutrition_screen.dart';

class DiaryScreen extends StatefulWidget {
  final DateTime selectedDate;

  const DiaryScreen({required this.selectedDate});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen>
    with SingleTickerProviderStateMixin {
  DatabaseHelper helper = DatabaseHelper();
  WaterData waterData = WaterData(date: '', water: '');
  NotesData notesData = NotesData(date: '', foodNote: '', exerciseNote: '');
  List<MealData> breakfastMealData = [];
  List<MealData> lunchMealData = [];
  List<MealData> dinnerMealData = [];
  List<MealData> snackMealData = [];
  List<RecipeData> breakfastRecipeData = [];
  List<RecipeData> lunchRecipeData = [];
  List<RecipeData> dinnerRecipeData = [];
  List<RecipeData> snackRecipeData = [];
  List<FoodData> breakfastFoodData = [];
  List<FoodData> lunchFoodData = [];
  List<FoodData> dinnerFoodData = [];
  List<FoodData> snackFoodData = [];
  List<QuickAddData> breakfastQuickAddData = [];
  List<QuickAddData> lunchQuickAddData = [];
  List<QuickAddData> dinnerQuickAddData = [];
  List<QuickAddData> snackQuickAddData = [];
  List<CardioData> cardioData = [];
  List<StrengthData> strengthData = [];
  int totalFoodValue = 0;
  int breakfastFoodVal = 0;
  int lunchFoodVal = 0;
  int dinnerFoodVal = 0;
  int snackFoodVal = 0;
  int totalExerciseVal = 0;
  int cardioExerciseVal = 0;
  int strengthExerciseVal = 0;
  int remainingVal = 0;
  AnimationController? animationController;
  Animation<double>? scaleAnimation;
  UserData userData = UserData(
    name: '',
    goalReason: '',
    activityLevel: '',
    gender: '',
    age: 0,
    dateOfBirth: '',
    country: '',
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
    iron: '',
  );

  getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
        });
      });
    });
  }

  getMealData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--meal--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              breakfastMealData.add(ele);
              print(
                  '--breakfastMealData----mealData22----${breakfastMealData.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              lunchMealData.add(ele);
              print(
                  '--lunchMealData----mealData22----${lunchMealData.toString()}');
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              dinnerMealData.add(ele);
              print(
                  '--dinnerMealData----mealData22----${dinnerMealData.toString()}');
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              snackMealData.add(ele);
              print(
                  '--snackMealData----mealData22----${snackMealData.toString()}');
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            } else {
              setState(() {
                breakfastMealData = [];
                lunchMealData = [];
                dinnerMealData = [];
                snackMealData = [];
              });
            }
          }
        } else {
          print('--meal--else----remain');
          setState(() {
            remainingVal = int.parse(userData.caloriesGoal!);
          });
        }
        setState(() {
          totalFoodValue =
              breakfastFoodVal + lunchFoodVal + dinnerFoodVal + snackFoodVal;
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue11------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  getRecipeData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<RecipeData>?> recipeDataList = helper.getRecipeList();
      recipeDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--recipe--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              breakfastRecipeData.add(ele);
              print(
                  '--breakfastRecipeData----recipeData22----${breakfastRecipeData.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              lunchRecipeData.add(ele);
              print(
                  '--lunchRecipeData----recipeData22----${lunchRecipeData.toString()}');
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              dinnerRecipeData.add(ele);
              print(
                  '--dinnerRecipeData----recipeData22----${dinnerRecipeData.toString()}');
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              snackRecipeData.add(ele);
              print(
                  '--snackRecipeData----recipeData22----${snackRecipeData.toString()}');
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            } else {
              setState(() {
                breakfastFoodData = [];
                lunchFoodData = [];
                dinnerFoodData = [];
                snackFoodData = [];
              });
            }
          }
        } else {
          print('--recipe--else----remain');
          if (breakfastMealData.isEmpty &&
              lunchMealData.isEmpty &&
              dinnerMealData.isEmpty &&
              snackMealData.isEmpty) {
            setState(() {
              remainingVal = int.parse(userData.caloriesGoal!);
            });
          }
        }
        setState(() {
          totalFoodValue = totalFoodValue +
              (breakfastFoodVal + lunchFoodVal + dinnerFoodVal + snackFoodVal);
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue22------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  getFoodData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FoodData>?> foodDataList = helper.getFoodList();
      foodDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--food--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              breakfastFoodData.add(ele);
              print(
                  '--breakfastFoodData----foodData22----${breakfastFoodData.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              lunchFoodData.add(ele);
              print(
                  '--lunchFoodData----foodData22----${lunchFoodData.toString()}');
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              dinnerFoodData.add(ele);
              print(
                  '--dinnerFoodData----foodData22----${dinnerFoodData.toString()}');
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              snackFoodData.add(ele);
              print(
                  '--snackFoodData----foodData22----${snackFoodData.toString()}');
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            } else {
              setState(() {
                breakfastFoodData = [];
                lunchFoodData = [];
                dinnerFoodData = [];
                snackFoodData = [];
              });
            }
          }
        } else {
          print('--food--else----remain');
          if (breakfastMealData.isEmpty &&
              lunchMealData.isEmpty &&
              dinnerMealData.isEmpty &&
              snackMealData.isEmpty &&
              breakfastRecipeData.isEmpty &&
              lunchRecipeData.isEmpty &&
              dinnerRecipeData.isEmpty &&
              snackRecipeData.isEmpty) {
            setState(() {
              remainingVal = int.parse(userData.caloriesGoal!);
            });
          }
        }
        setState(() {
          totalFoodValue = totalFoodValue +
              (breakfastFoodVal + lunchFoodVal + dinnerFoodVal + snackFoodVal);
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue33------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  getQuickAddData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<QuickAddData>?> quickAddDataList = helper.getQuickAddList();
      quickAddDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          breakfastFoodVal = 0;
          lunchFoodVal = 0;
          dinnerFoodVal = 0;
          snackFoodVal = 0;
          remainingVal = int.parse(userData.caloriesGoal!);
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--quickAdd--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[0]) {
              print('----ele11------${ele.toString()}');
              breakfastQuickAddData.add(ele);
              print(
                  '--breakfastMealData----quickAddData22----${breakfastQuickAddData.toString()}');
              setState(() {
                breakfastFoodVal = breakfastFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[1]) {
              lunchQuickAddData.add(ele);
              print(
                  '--lunchMealData----quickAddData22----${lunchQuickAddData.toString()}');
              setState(() {
                lunchFoodVal = lunchFoodVal + int.parse(ele.calorie!);
              });
              print('--lunchFoodVal------${lunchFoodVal.toString()}');
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[2]) {
              dinnerQuickAddData.add(ele);
              print(
                  '--dinnerMealData----quickAddData22----${dinnerQuickAddData.toString()}');
              setState(() {
                dinnerFoodVal = dinnerFoodVal + int.parse(ele.calorie!);
              });
            } else if (ele.date == DateFormat('yyyy-MM-dd').format(date) &&
                ele.type == titles[3]) {
              snackQuickAddData.add(ele);
              print(
                  '--snackMealData----quickAddData22----${snackQuickAddData.toString()}');
              setState(() {
                snackFoodVal = snackFoodVal + int.parse(ele.calorie!);
              });
            } else {
              setState(() {
                breakfastQuickAddData = [];
                lunchQuickAddData = [];
                dinnerQuickAddData = [];
                snackQuickAddData = [];
              });
            }
          }
        } else {
          print('--meal--else----remain');
          if (breakfastMealData.isEmpty &&
              lunchMealData.isEmpty &&
              dinnerMealData.isEmpty &&
              snackMealData.isEmpty &&
              breakfastRecipeData.isEmpty &&
              lunchRecipeData.isEmpty &&
              dinnerRecipeData.isEmpty &&
              snackRecipeData.isEmpty &&
              breakfastFoodData.isEmpty &&
              lunchFoodData.isEmpty &&
              dinnerFoodData.isEmpty &&
              snackFoodData.isEmpty) {
            setState(() {
              remainingVal = int.parse(userData.caloriesGoal!);
            });
          }
        }
        setState(() {
          totalFoodValue = totalFoodValue +
              (breakfastFoodVal + lunchFoodVal + dinnerFoodVal + snackFoodVal);
          remainingVal = remainingVal - totalFoodValue;
        });
        print(
            '--totalFoodValue44------${totalFoodValue.toString()}------$remainingVal');
      });
    });
  }

  getCardioData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CardioData>?> cardioDataList = helper.getCardioExerciseList();
      cardioDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          cardioExerciseVal = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--cardio--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              setState(() {
                cardioData = [];
              });
              print('--cardio--isEnter');
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(date)) {
                  print('--cardio--ele------${i.toString()}');
                  cardioData.add(i);
                  setState(() {
                    cardioExerciseVal =
                        cardioExerciseVal + int.parse(i.calorie!);
                    remainingVal = remainingVal + cardioExerciseVal;
                  });
                }
              }
              break;
            } else {
              setState(() {
                cardioData = [];
              });
            }
          }
        } else {
          print('--cardio--else----remain');
          if (breakfastMealData.isEmpty &&
              lunchMealData.isEmpty &&
              dinnerMealData.isEmpty &&
              snackMealData.isEmpty &&
              breakfastRecipeData.isEmpty &&
              lunchRecipeData.isEmpty &&
              dinnerRecipeData.isEmpty &&
              snackRecipeData.isEmpty &&
              breakfastFoodData.isEmpty &&
              lunchFoodData.isEmpty &&
              dinnerFoodData.isEmpty &&
              snackFoodData.isEmpty &&
              breakfastQuickAddData.isEmpty &&
              lunchQuickAddData.isEmpty &&
              dinnerQuickAddData.isEmpty &&
              snackQuickAddData.isEmpty) {
            setState(() {
              remainingVal = int.parse(userData.caloriesGoal!);
            });
          }
        }
      });
    });
  }

  getStrengthData(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<StrengthData>?> strengthDataList =
          helper.getStrengthExerciseList();
      strengthDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          strengthExerciseVal = 0;
        });
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--strength--selDate22--------${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              setState(() {
                strengthData = [];
              });
              print('--strength--isEnter');
              for (var i in data) {
                if (i.date == DateFormat('yyyy-MM-dd').format(date)) {
                  strengthData.add(i);
                  setState(() {
                    strengthExerciseVal =
                        strengthExerciseVal + int.parse(i.calorie!);
                    remainingVal = remainingVal + strengthExerciseVal;
                  });
                }
              }
              break;
            } else {
              setState(() {
                strengthData = [];
              });
            }
          }
        } else {
          print('--strength--else----remain');
          if (breakfastMealData.isEmpty &&
              lunchMealData.isEmpty &&
              dinnerMealData.isEmpty &&
              snackMealData.isEmpty &&
              breakfastRecipeData.isEmpty &&
              lunchRecipeData.isEmpty &&
              dinnerRecipeData.isEmpty &&
              snackRecipeData.isEmpty &&
              breakfastFoodData.isEmpty &&
              lunchFoodData.isEmpty &&
              dinnerFoodData.isEmpty &&
              snackFoodData.isEmpty &&
              breakfastQuickAddData.isEmpty &&
              lunchQuickAddData.isEmpty &&
              dinnerQuickAddData.isEmpty &&
              snackQuickAddData.isEmpty &&
              cardioData.isEmpty) {
            setState(() {
              remainingVal = int.parse(userData.caloriesGoal!);
            });
          }
        }
        setState(() {
          totalExerciseVal = cardioExerciseVal + strengthExerciseVal;
        });
      });
    });
  }

  getWaterDataView(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WaterData>?> listNoteFuture = helper.getWaterList();
      listNoteFuture.then((data) {
        print('-------data-------$data');
        print('--water--selDate11----$date');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--water--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('--water--isEnter');
              setState(() {
                waterData = ele;
              });
              break;
            } else {
              setState(() {
                waterData = WaterData(date: '', water: '');
              });
            }
          }
        }
        print('----waterData---------${waterData.toString()}');
      });
    });
  }

  getNoteDataView(DateTime date) {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NotesData>?> listNoteFuture = helper.getNoteList();
      listNoteFuture.then((data) {
        print('-------data-------$data');
        print('--note--selDate11----$date');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            print('--note--selDate22----${ele.date}');
            if (ele.date == DateFormat('yyyy-MM-dd').format(date)) {
              print('--note--isEnter');
              setState(() {
                notesData = ele;
              });
              break;
            } else {
              setState(() {
                notesData = NotesData(date: '', foodNote: '', exerciseNote: '');
              });
            }
          }
        }
        print('----notesData--------${notesData.toString()}');
      });
    });
  }

  onLongPressData(Function() onDltEntry) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: 115,
                        width: deviceWidth(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                height: 55,
                                width: deviceWidth(context),
                                decoration: BoxDecoration(
                                    color: colorIndigo.withOpacity(0.1),
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(20))),
                                alignment: Alignment.center,
                                child: Text('Diary',
                                    style: textStyle18Bold(colorIndigo))),
                            selectOption(
                                Icons.delete, 'Delete Entry', onDltEntry),
                          ],
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  @override
  void initState() {
    getUserData();
    getMealData(widget.selectedDate);
    getRecipeData(widget.selectedDate);
    getFoodData(widget.selectedDate);
    getQuickAddData(widget.selectedDate);
    getCardioData(widget.selectedDate);
    getStrengthData(widget.selectedDate);
    getWaterDataView(widget.selectedDate);
    getNoteDataView(widget.selectedDate);
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation = CurvedAnimation(
        parent: animationController!, curve: Curves.elasticInOut);

    animationController!.addListener(() {
      setState(() {});
    });

    animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DateBloc, DateState>(
      listener: (context, state) {
        if (state is GetDiaryDateData) {
          print('------isDiary');
          getMealData(state.date);
          getRecipeData(state.date);
          getFoodData(state.date);
          getQuickAddData(state.date);
          getCardioData(state.date);
          getStrengthData(state.date);
          getWaterDataView(state.date);
          getNoteDataView(state.date);
        }
      },
      builder: (context, state) => state is GetDiaryDateData
          ? commonWidget(state.date)
          : commonWidget(widget.selectedDate),
    );
  }

  commonWidget(DateTime date) {
    return Column(
      children: [
        Text('Calories Remaining', style: textStyle18Bold(colorIndigo)),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            caloriesData(
                userData.caloriesGoal!.characters.length == 4
                    ? '${userData.caloriesGoal!.substring(0, 1)},${userData.caloriesGoal!.substring(1)}'
                    : userData.caloriesGoal!,
                'Goal'),
            caloriesData('-', ''),
            caloriesData(
                totalFoodValue.toString().characters.length == 4
                    ? '${totalFoodValue.toString().substring(0, 1)},${totalFoodValue.toString().substring(1)}'
                    : totalFoodValue.toString(),
                'Food'),
            caloriesData('+', ''),
            caloriesData(
                totalExerciseVal.toString().characters.length == 4
                    ? '${totalExerciseVal.toString().substring(0, 1)},${totalExerciseVal.toString().substring(1)}'
                    : totalExerciseVal.toString(),
                'Exercise'),
            caloriesData('=', ''),
            caloriesData(
                remainingVal.toString().characters.length == 4
                    ? '${remainingVal.toString().substring(0, 1)},${remainingVal.toString().substring(1)}'
                    : remainingVal.toString(),
                'Remaining'),
          ],
        ),
        const SizedBox(height: 30),
        imageData(
            titles[0],
            images[0],
            date,
            () => Navigator.of(context).pushNamed(AddFoodScreen.route,
                arguments: AddFoodScreenData(
                    foodType: titles[0],
                    selDate: DateFormat('yyyy-MM-dd').format(date))),
            AddFoodScreen(
                data: AddFoodScreenData(
                    foodType: titles[0],
                    selDate: DateFormat('yyyy-MM-dd').format(date)))),
        imageData(
            titles[1],
            images[1],
            date,
            () => Navigator.of(context).pushNamed(AddFoodScreen.route,
                arguments: AddFoodScreenData(
                    foodType: titles[1],
                    selDate: DateFormat('yyyy-MM-dd').format(date))),
            AddFoodScreen(
                data: AddFoodScreenData(
                    foodType: titles[1],
                    selDate: DateFormat('yyyy-MM-dd').format(date)))),
        imageData(
            titles[2],
            images[2],
            date,
            () => Navigator.of(context).pushNamed(AddFoodScreen.route,
                arguments: AddFoodScreenData(
                    foodType: titles[2],
                    selDate: DateFormat('yyyy-MM-dd').format(date))),
            AddFoodScreen(
                data: AddFoodScreenData(
                    foodType: titles[2],
                    selDate: DateFormat('yyyy-MM-dd').format(date)))),
        imageData(
            titles[3],
            images[3],
            date,
            () => Navigator.of(context).pushNamed(AddFoodScreen.route,
                arguments: AddFoodScreenData(
                    foodType: titles[3],
                    selDate: DateFormat('yyyy-MM-dd').format(date))),
            AddFoodScreen(
                data: AddFoodScreenData(
                    foodType: titles[3],
                    selDate: DateFormat('yyyy-MM-dd').format(date)))),
        imageData(
            titles[4],
            images[4],
            date,
            () => showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, setState) =>
                          Dialogs(type: 'Exercise', selDate: date));
                }),
            Container()),
        imageData(
            titles[5],
            images[5],
            date,
            () => Navigator.of(context).pushNamed(AddWaterScreen.route,
                arguments: AddWaterData(
                    selDate: DateFormat('yyyy-MM-dd').format(date),
                    type: 'Add')),
            AddWaterScreen(
                data: AddWaterData(
                    selDate: DateFormat('yyyy-MM-dd').format(date),
                    type: 'Add'))),
        if (notesData.foodNote!.isNotEmpty ||
            notesData.exerciseNote!.isNotEmpty)
          imageData('Notes', imgNotes, date, () {}, Container()),
        const SizedBox(height: 25),
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
            child: AnimationWidget(
                message: 'Nutrition',
                color: colorBG,
                widget: diaryData('Nutrition', imgNutrition),
                screen: const NutritionScreen(index: 1))),
        Padding(
            padding:
                EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
            child: GestureDetector(
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (context, setState) =>
                              Dialogs(type: 'Notes', selDate: date));
                    }),
                child: diaryData('Notes', imgNotes))),
        const SizedBox(height: 30),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 57,
            width: deviceWidth(context) * 0.85,
            decoration: BoxDecoration(
                color: colorIndigo,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(45), right: Radius.circular(45)),
                boxShadow: [
                  BoxShadow(
                      color: colorIndigo.withOpacity(0.5),
                      blurRadius: 5,
                      offset: const Offset(2, 2)),
                ]),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imgCompleteDiary,
                    color: colorWhite, width: deviceWidth(context) * 0.07),
                SizedBox(width: deviceWidth(context) * 0.03),
                Text('Complete Diary', style: textStyle20Bold(colorWhite)),
                SizedBox(width: deviceWidth(context) * 0.03),
              ],
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorIndigo, width: 1) : null);
  }

  buttons(String icon) {
    return Container(
      height: deviceHeight(context) * 0.042,
      width: deviceWidth(context) * 0.085,
      decoration: decoration(5),
      alignment: Alignment.center,
      child: Image.asset(icon,
          width: icon == icMoreVert
              ? deviceWidth(context) * 0.055
              : deviceWidth(context) * 0.04),
    );
  }

  caloriesData(String value, String title) {
    return Column(
      children: [
        Text(value, style: textStyle18Bold(colorIndigo)),
        SizedBox(height: deviceHeight(context) * 0.01),
        Text(title, style: textStyle14Bold(colorIndigo.withOpacity(0.5))),
      ],
    );
  }

  imageData(String title, String image, DateTime date, Function() onClick,
      Widget screen) {
    bool firstFour = (title == titles[0] &&
        breakfastMealData.isEmpty &&
        breakfastRecipeData.isEmpty &&
        breakfastFoodData.isEmpty &&
        breakfastQuickAddData.isEmpty) ||
        (title == titles[1] &&
            lunchMealData.isEmpty &&
            lunchRecipeData.isEmpty &&
            lunchFoodData.isEmpty &&
            lunchQuickAddData.isEmpty) ||
        (title == titles[2] &&
            dinnerMealData.isEmpty &&
            dinnerRecipeData.isEmpty &&
            dinnerFoodData.isEmpty &&
            dinnerQuickAddData.isEmpty) ||
        (title == titles[3] &&
            snackMealData.isEmpty &&
            snackRecipeData.isEmpty &&
            snackFoodData.isEmpty &&
            snackQuickAddData.isEmpty);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: title == titles[0] &&
                  (breakfastMealData.isNotEmpty ||
                      breakfastRecipeData.isNotEmpty ||
                      breakfastFoodData.isNotEmpty ||
                      breakfastQuickAddData.isNotEmpty)
              ? 55 +
                  (76.5 *
                      (breakfastMealData.length +
                          breakfastRecipeData.length +
                          breakfastFoodData.length +
                          breakfastQuickAddData.length))
              : title == titles[1] &&
                      (lunchMealData.isNotEmpty ||
                          lunchRecipeData.isNotEmpty ||
                          lunchFoodData.isNotEmpty ||
                          lunchQuickAddData.isNotEmpty)
                  ? 55 +
                      (76.5 *
                          (lunchMealData.length +
                              lunchRecipeData.length +
                              lunchFoodData.length +
                              lunchQuickAddData.length))
                  : title == titles[2] &&
                          (dinnerMealData.isNotEmpty ||
                              dinnerRecipeData.isNotEmpty ||
                              dinnerFoodData.isNotEmpty ||
                              dinnerQuickAddData.isNotEmpty)
                      ? 55 +
                          (76.5 *
                              (dinnerMealData.length +
                                  dinnerRecipeData.length +
                                  dinnerFoodData.length +
                                  dinnerQuickAddData.length))
                      : title == titles[3] &&
                              (snackMealData.isNotEmpty ||
                                  snackRecipeData.isNotEmpty ||
                                  snackFoodData.isNotEmpty ||
                                  snackQuickAddData.isNotEmpty)
                          ? 55 +
                              (76.5 *
                                  (snackMealData.length +
                                      snackRecipeData.length +
                                      snackFoodData.length +
                                      snackQuickAddData.length))
                          : title == titles[4] &&
                                  (cardioData.isNotEmpty ||
                                      strengthData.isNotEmpty)
                              ? 55 +
                                  (76.5 *
                                      (cardioData.length + strengthData.length))
                              : title == titles[5] &&
                                      waterData.water!.isNotEmpty
                                  ? 55 + 76.5
                                  : title == 'Notes' &&
                                          notesData.foodNote!.isNotEmpty &&
                                          notesData.exerciseNote!.isNotEmpty
                                      ? 55 + (76.5 * 2)
                                      : title == 'Notes' &&
                                              (notesData.foodNote!.isNotEmpty ||
                                                  notesData
                                                      .exerciseNote!.isNotEmpty)
                                          ? 55 + 76.5
                                          : 140,
          width: deviceWidth(context),
          decoration: BoxDecoration(
              border: Border.all(color: colorIndigo, width: 1),
              color: colorWhite,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 45,
                width: deviceWidth(context),
                decoration: const BoxDecoration(
                    color: colorIndigo,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8))),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.03),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: textStyle16Bold(colorWhite)),
                      if (title != 'Exercise' && title != 'Notes')
                        AnimationWidget(
                            message: 'AddItem',
                            color: colorIndigo,
                            widget: Image.asset(icAddItem,
                                color: colorWhite,
                                width: deviceWidth(context) * 0.06),
                            screen: screen),
                      if (title == 'Exercise')
                        GestureDetector(
                          onTap: onClick,
                          child: Image.asset(icAddItem,
                              color: colorWhite,
                              width: deviceWidth(context) * 0.06),
                        )
                    ],
                  ),
                ),
              ),
              if (!firstFour)
                const Spacer(),
              if (firstFour)
                AnimationWidget(
                    message: 'AddItemImage',
                    color: colorWhite,
                    widget: Container(
                      height: 140-47,
                      width: deviceWidth(context),
                      decoration: const BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 70,
                          width: title == titles[2]
                              ? deviceWidth(context) * 0.17
                              : deviceWidth(context) * 0.2,
                          child: Image.asset(image, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    screen: screen),
              if (title == titles[0] && breakfastMealData.isNotEmpty)
                mealViewData(breakfastMealData, breakfastRecipeData,
                    breakfastFoodData, breakfastQuickAddData),
              if (title == titles[0] && breakfastRecipeData.isNotEmpty)
                recipeViewData(breakfastRecipeData, breakfastFoodData,
                    breakfastQuickAddData),
              if (title == titles[0] && breakfastFoodData.isNotEmpty)
                foodViewData(breakfastFoodData, breakfastQuickAddData),
              if (title == titles[0] && breakfastQuickAddData.isNotEmpty)
                quickAddViewData(breakfastQuickAddData),
              if (title == titles[1] && (lunchMealData.isNotEmpty))
                mealViewData(lunchMealData, lunchRecipeData, lunchFoodData,
                    lunchQuickAddData),
              if (title == titles[1] && lunchRecipeData.isNotEmpty)
                recipeViewData(
                    lunchRecipeData, lunchFoodData, lunchQuickAddData),
              if (title == titles[1] && lunchFoodData.isNotEmpty)
                foodViewData(lunchFoodData, lunchQuickAddData),
              if (title == titles[1] && lunchQuickAddData.isNotEmpty)
                quickAddViewData(lunchQuickAddData),
              if (title == titles[2] && (dinnerMealData.isNotEmpty))
                mealViewData(dinnerMealData, dinnerRecipeData, dinnerFoodData,
                    dinnerQuickAddData),
              if (title == titles[2] && dinnerRecipeData.isNotEmpty)
                recipeViewData(
                    dinnerRecipeData, dinnerFoodData, dinnerQuickAddData),
              if (title == titles[2] && dinnerFoodData.isNotEmpty)
                foodViewData(dinnerFoodData, dinnerQuickAddData),
              if (title == titles[2] && dinnerQuickAddData.isNotEmpty)
                quickAddViewData(dinnerQuickAddData),
              if (title == titles[3] && (snackMealData.isNotEmpty))
                mealViewData(snackMealData, snackRecipeData, snackFoodData,
                    snackQuickAddData),
              if (title == titles[3] && snackRecipeData.isNotEmpty)
                recipeViewData(
                    snackRecipeData, snackFoodData, snackQuickAddData),
              if (title == titles[3] && snackFoodData.isNotEmpty)
                foodViewData(snackFoodData, snackQuickAddData),
              if (title == titles[3] && snackQuickAddData.isNotEmpty)
                quickAddViewData(snackQuickAddData),
              if (title == titles[4] &&
                  cardioData.isEmpty &&
                  strengthData.isEmpty)
                SizedBox(
                  height: 60,
                  width: deviceWidth(context) * 0.14,
                  child: Image.asset(image, fit: BoxFit.fill),
                ),
              if (title == titles[4] &&
                  (cardioData.isNotEmpty || strengthData.isNotEmpty))
                Column(
                  children: [
                    if (cardioData.isNotEmpty)
                      Column(
                        children: List.generate(
                            cardioData.length,
                            (index) => Column(
                                  children: [
                                    InkWell(
                                      splashColor: colorBG,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            UpdateExerciseScreen.route,
                                            arguments: UpdateExerciseData(
                                                type: 'Cardio',
                                                exerciseData:
                                                    cardioData[index]));
                                      },
                                      onLongPress: () {
                                        onLongPressData(() {
                                          for (int i = 0;
                                              i < cardioData.length;
                                              i++) {
                                            if (cardioData[i].id ==
                                                cardioData[index].id) {
                                              helper.deleteCardioExercise(
                                                  cardioData[index].id!);
                                              setState(() {
                                                totalExerciseVal =
                                                    totalExerciseVal -
                                                        int.parse(
                                                            cardioData[index]
                                                                .calorie!);
                                                remainingVal = remainingVal -
                                                    int.parse(cardioData[index]
                                                        .calorie!);
                                                cardioData
                                                    .remove(cardioData[index]);
                                              });
                                            }
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Container(
                                        height:
                                            cardioData.length == 1 ? 80 : 75,
                                        width: deviceWidth(context),
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  deviceWidth(context) * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      cardioData[index]
                                                          .description!,
                                                      style: textStyle14Bold(
                                                          colorIndigo)),
                                                  SizedBox(
                                                      height: deviceHeight(
                                                              context) *
                                                          0.01),
                                                  Text(
                                                      '${cardioData[index].time!} minutes',
                                                      style: textStyle12(
                                                          colorIndigo)),
                                                ],
                                              ),
                                              Text(cardioData[index].calorie!,
                                                  style: textStyle14Bold(
                                                      colorIndigo)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index != cardioData.length - 1)
                                      Container(
                                        height: 1,
                                        color: colorIndigo,
                                      ),
                                    if (index == cardioData.length - 1 &&
                                        strengthData.isNotEmpty)
                                      Container(
                                        height: 1,
                                        color: colorIndigo,
                                      ),
                                  ],
                                )),
                      ),
                    if (strengthData.isNotEmpty)
                      Column(
                        children: List.generate(
                            strengthData.length,
                            (index) => Column(
                                  children: [
                                    InkWell(
                                      splashColor: colorBG,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            UpdateExerciseScreen.route,
                                            arguments: UpdateExerciseData(
                                                type: 'Strength',
                                                exerciseData:
                                                    strengthData[index]));
                                      },
                                      onLongPress: () {
                                        onLongPressData(() {
                                          for (int i = 0;
                                              i < strengthData.length;
                                              i++) {
                                            if (strengthData[i].id ==
                                                strengthData[index].id) {
                                              helper.deleteCardioExercise(
                                                  strengthData[index].id!);
                                              setState(() {
                                                totalExerciseVal =
                                                    totalExerciseVal -
                                                        int.parse(
                                                            strengthData[index]
                                                                .calorie!);
                                                remainingVal = remainingVal -
                                                    int.parse(
                                                        strengthData[index]
                                                            .calorie!);
                                                strengthData.remove(
                                                    strengthData[index]);
                                              });
                                            }
                                          }
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Container(
                                        height:
                                            strengthData.length == 1 ? 80 : 75,
                                        width: deviceWidth(context),
                                        color: Colors.transparent,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  deviceWidth(context) * 0.04),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      strengthData[index]
                                                          .description!,
                                                      style: textStyle14Bold(
                                                          colorIndigo)),
                                                  SizedBox(
                                                      height: deviceHeight(
                                                              context) *
                                                          0.01),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          '${strengthData[index].hashOfSet!} Sets, ${strengthData[index].repetitionSet!} reps',
                                                          style: textStyle12(
                                                              colorIndigo)),
                                                      if (strengthData[index]
                                                          .weightPerRepetition!
                                                          .isNotEmpty)
                                                        Text(
                                                            ' ${strengthData[index].weightPerRepetition!} kg',
                                                            style: textStyle12(
                                                                colorIndigo)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Text(strengthData[index].calorie!,
                                                  style: textStyle14Bold(
                                                      colorIndigo)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (index != strengthData.length - 1)
                                      Container(
                                        height: 1,
                                        color: colorIndigo,
                                      ),
                                  ],
                                )),
                      ),
                  ],
                ),
              if (title == titles[5] && waterData.water!.isEmpty)
                AnimationWidget(
                    message: 'AddWater',
                    color: colorWhite,
                    widget: Container(
                      height: 140-47,
                      width: deviceWidth(context),
                      decoration: const BoxDecoration(
                          color: colorWhite,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))
                      ),
                      child: Center(
                        child: SizedBox(
                          height: 60,
                          width: deviceWidth(context) * 0.14,
                          child: Image.asset(image, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    screen: screen),
              if (title == titles[5] && waterData.water!.isNotEmpty)
                InkWell(
                  splashColor: colorBG,
                  onTap: () {
                    Navigator.of(context).pushNamed(AddWaterScreen.route,
                        arguments: AddWaterData(
                            selDate: DateFormat('yyyy-MM-dd').format(date),
                            type: 'Update'));
                  },
                  child: Container(
                    height: 68,
                    width: deviceWidth(context),
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: deviceWidth(context) * 0.04),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(waterData.water!,
                              style: textStyle16Bold(colorIndigo)),
                          Image.asset(image, width: deviceWidth(context) * 0.07)
                        ],
                      ),
                    ),
                  ),
                ),
              if (title == 'Notes' &&
                  (notesData.foodNote!.isNotEmpty ||
                      notesData.exerciseNote!.isNotEmpty))
                Column(
                  children: [
                    if (notesData.foodNote!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AddNoteScreen.route,
                              arguments: AddNoteData(
                                  noteType: 'Food Notes',
                                  selDate: DateFormat('yyyy-MM-dd')
                                      .format(widget.selectedDate)));
                        },
                        child: Container(
                          height: 67.5,
                          width: deviceWidth(context),
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth(context) * 0.04),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Food',
                                    style: textStyle14Bold(colorIndigo)),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Text(notesData.foodNote!,
                                    style: textStyle12(colorIndigo)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (notesData.foodNote!.isNotEmpty &&
                        notesData.exerciseNote!.isNotEmpty)
                      Container(
                        height: 1,
                        color: colorIndigo,
                      ),
                    if (notesData.exerciseNote!.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AddNoteScreen.route,
                              arguments: AddNoteData(
                                  noteType: 'Exercise Notes',
                                  selDate: DateFormat('yyyy-MM-dd')
                                      .format(widget.selectedDate)));
                        },
                        child: Container(
                          height: 67.5,
                          width: deviceWidth(context),
                          color: Colors.transparent,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: deviceWidth(context) * 0.04),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Exercise',
                                    style: textStyle14Bold(colorIndigo)),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Text(notesData.exerciseNote!,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyle12(colorIndigo)),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              if (!firstFour)
                const Spacer()
            ],
          ),
        ),
      ),
    );
  }

  diaryData(String title, String icon) {
    return Container(
      height: deviceHeight(context) * 0.065,
      decoration: decoration(4),
      child: Row(
        children: [
          SizedBox(width: deviceWidth(context) * 0.04),
          Text(title, style: textStyle16Bold(colorIndigo)),
          const Spacer(),
          Image.asset(icon, width: deviceWidth(context) * 0.05),
          SizedBox(width: deviceWidth(context) * 0.04),
        ],
      ),
    );
  }

  mealViewData(List<MealData> mealData, List<RecipeData> recipeData,
      List<FoodData> foodData, List<QuickAddData> quickAddData) {
    return Column(
      children: List.generate(
          mealData.length,
          (index) => Column(
                children: [
                  InkWell(
                    splashColor: colorBG,
                    onTap: () {
                      Navigator.of(context).pushNamed(CreateMeal.route,
                          arguments: CreateMealData(
                              action: 'Update', mealData: mealData[index]));
                    },
                    onLongPress: () {
                      onLongPressData(() {
                        for (int i = 0; i < mealData.length; i++) {
                          if (mealData[i].id == mealData[index].id) {
                            helper.deleteMeal(mealData[index].id!);
                            setState(() {
                              totalFoodValue = totalFoodValue -
                                  int.parse(mealData[index].calorie!);
                              remainingVal = remainingVal +
                                  int.parse(mealData[index].calorie!);
                              mealData.remove(mealData[index]);
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: mealData.length == 1 ? 80 : 75,
                      width: deviceWidth(context),
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(mealData[index].name!,
                                        style: textStyle16Bold(colorIndigo)),
                                    if (mealData[index].time != null)
                                      Text(' (${mealData[index].time!})',
                                          style: textStyle12Bold(colorIndigo)
                                              .copyWith(letterSpacing: 1)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Row(
                                  children: [
                                    if (mealData[index]
                                        .carbohydrates!
                                        .isNotEmpty)
                                      Text(
                                          '${mealData[index].carbohydrates!}g Carbs',
                                          style: textStyle11(colorIndigo)),
                                    if (mealData[index].fat!.isNotEmpty)
                                      Text(',',
                                          style: textStyle12(colorIndigo)),
                                    if (mealData[index].fat!.isNotEmpty)
                                      Text('${mealData[index].fat!}g Fat',
                                          style: textStyle11(colorIndigo)),
                                    if (mealData[index].protein!.isNotEmpty)
                                      Text(',',
                                          style: textStyle12(colorIndigo)),
                                    if (mealData[index].protein!.isNotEmpty)
                                      Text(
                                          '${mealData[index].protein!}g Protein',
                                          style: textStyle11(colorIndigo)),
                                  ],
                                ),
                              ],
                            ),
                            Text(mealData[index].calorie!,
                                style: textStyle14Bold(colorIndigo)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != mealData.length - 1)
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                  if (index == mealData.length - 1 &&
                      (recipeData.isNotEmpty ||
                          foodData.isNotEmpty ||
                          quickAddData.isNotEmpty))
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                ],
              )),
    );
  }

  recipeViewData(List<RecipeData> recipeData, List<FoodData> foodData,
      List<QuickAddData> quickAddData) {
    return Column(
      children: List.generate(
          recipeData.length,
          (index) => Column(
                children: [
                  InkWell(
                    splashColor: colorBG,
                    onTap: () {
                      Navigator.of(context).pushNamed(CreateRecipe.route,
                          arguments: CreateRecipeData(
                              action: 'Update', recipeData: recipeData[index]));
                    },
                    onLongPress: () {
                      onLongPressData(() {
                        for (int i = 0; i < recipeData.length; i++) {
                          if (recipeData[i].id == recipeData[index].id) {
                            helper.deleteRecipe(recipeData[index].id!);
                            setState(() {
                              totalFoodValue = totalFoodValue -
                                  int.parse(recipeData[index].calorie!);
                              remainingVal = remainingVal +
                                  int.parse(recipeData[index].calorie!);
                              recipeData.remove(recipeData[index]);
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: recipeData.length == 1 ? 80 : 75,
                      width: deviceWidth(context),
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(recipeData[index].recipeName!,
                                        style: textStyle16Bold(colorIndigo)),
                                    if (recipeData[index].time != null)
                                      Text(' (${recipeData[index].time!})',
                                          style: textStyle12Bold(colorIndigo)
                                              .copyWith(letterSpacing: 1)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Text('${recipeData[index].servings!} Servings',
                                    style: textStyle11(colorIndigo)),
                              ],
                            ),
                            Text(recipeData[index].calorie!,
                                style: textStyle14Bold(colorIndigo)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != recipeData.length - 1)
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                  if (index == recipeData.length - 1 &&
                      (foodData.isNotEmpty || quickAddData.isNotEmpty))
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                ],
              )),
    );
  }

  foodViewData(List<FoodData> foodData, List<QuickAddData> quickAddData) {
    return Column(
      children: List.generate(
          foodData.length,
          (index) => Column(
                children: [
                  InkWell(
                    splashColor: colorBG,
                    onTap: () {
                      Navigator.of(context).pushNamed(CreateFood.route,
                          arguments: CreateFoodData(
                              action: 'Update', foodData: foodData[index]));
                    },
                    onLongPress: () {
                      onLongPressData(() {
                        for (int i = 0; i < foodData.length; i++) {
                          if (foodData[i].id == foodData[index].id) {
                            helper.deleteFood(foodData[index].id!);
                            setState(() {
                              totalFoodValue = totalFoodValue -
                                  int.parse(foodData[index].calorie!);
                              remainingVal = remainingVal +
                                  int.parse(foodData[index].calorie!);
                              foodData.remove(foodData[index]);
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: foodData.length == 1 ? 80 : 75,
                      width: deviceWidth(context),
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(foodData[index].description!,
                                        style: textStyle16Bold(colorIndigo)),
                                    if (foodData[index].time != null)
                                      Text(' (${foodData[index].time!})',
                                          style: textStyle12Bold(colorIndigo)
                                              .copyWith(letterSpacing: 1)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Row(
                                  children: [
                                    if (foodData[index].brandName!.isNotEmpty)
                                      Text(foodData[index].brandName!,
                                          style: textStyle11(colorIndigo)),
                                    if (foodData[index].brandName!.isNotEmpty)
                                      Text(', ',
                                          style: textStyle12(colorIndigo)),
                                    if (foodData[index].servingSize! > 0)
                                      Text(
                                          '${foodData[index].servingSize!} ${foodData[index].servingUnit!}',
                                          style: textStyle11(colorIndigo)),
                                  ],
                                ),
                              ],
                            ),
                            Text(foodData[index].calorie!,
                                style: textStyle14Bold(colorIndigo)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != foodData.length - 1)
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                  if (index == foodData.length - 1 && quickAddData.isNotEmpty)
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                ],
              )),
    );
  }

  quickAddViewData(List<QuickAddData> quickAddData) {
    return Column(
      children: List.generate(
          quickAddData.length,
          (index) => Column(
                children: [
                  InkWell(
                    splashColor: colorBG,
                    onTap: () {
                      Navigator.of(context).pushNamed(QuickAddScreen.route,
                          arguments: QuickAddScreenData(
                              action: 'Update',
                              quickAddData: quickAddData[index]));
                    },
                    onLongPress: () {
                      onLongPressData(() {
                        for (int i = 0; i < quickAddData.length; i++) {
                          if (quickAddData[i].id == quickAddData[index].id) {
                            helper.deleteQuickAdd(quickAddData[index].id!);
                            setState(() {
                              totalFoodValue = totalFoodValue -
                                  int.parse(quickAddData[index].calorie!);
                              remainingVal = remainingVal +
                                  int.parse(quickAddData[index].calorie!);
                              quickAddData.remove(quickAddData[index]);
                            });
                          }
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      height: quickAddData.length == 1 ? 80 : 75,
                      width: deviceWidth(context),
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Quick Add',
                                        style: textStyle16Bold(colorIndigo)),
                                    if (quickAddData[index].time != null)
                                      Text(' (${quickAddData[index].time!})',
                                          style: textStyle12Bold(colorIndigo)
                                              .copyWith(letterSpacing: 1)),
                                  ],
                                ),
                                SizedBox(height: deviceHeight(context) * 0.01),
                                Row(
                                  children: [
                                    if (quickAddData[index]
                                        .carbohydrates!
                                        .isNotEmpty)
                                      Text(
                                          '${quickAddData[index].carbohydrates!}g Carbs',
                                          style: textStyle11(colorIndigo)),
                                    if (quickAddData[index].fat!.isNotEmpty)
                                      Text(',',
                                          style: textStyle12(colorIndigo)),
                                    if (quickAddData[index].fat!.isNotEmpty)
                                      Text('${quickAddData[index].fat!}g Fat',
                                          style: textStyle11(colorIndigo)),
                                    if (quickAddData[index].protein!.isNotEmpty)
                                      Text(',',
                                          style: textStyle12(colorIndigo)),
                                    if (quickAddData[index].protein!.isNotEmpty)
                                      Text(
                                          '${quickAddData[index].protein!}g Protein',
                                          style: textStyle11(colorIndigo)),
                                  ],
                                ),
                              ],
                            ),
                            Text(quickAddData[index].calorie!,
                                style: textStyle14Bold(colorIndigo)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (index != quickAddData.length - 1)
                    Container(
                      height: 1,
                      color: colorIndigo,
                    ),
                ],
              )),
    );
  }

  selectOption(IconData icon, String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth(context) * 0.05),
      child: GestureDetector(
        onTap: onClick,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Icon(icon, color: colorIndigo),
              SizedBox(width: deviceWidth(context) * 0.03),
              Text(title, style: textStyle14Medium(colorIndigo))
            ],
          ),
        ),
      ),
    );
  }
}
