import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/blocs/date/date_bloc.dart';
import 'package:nutrime/blocs/date/date_event.dart';
import 'package:nutrime/blocs/date/date_state.dart';
import 'package:nutrime/models/goal_data.dart';
import 'package:nutrime/models/user_data.dart';
import 'package:nutrime/screens/bottomBar/diary_screen.dart';
import 'package:nutrime/screens/user_screen.dart';
import 'package:nutrime/widgets/notes_Exercise_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../handler/handler.dart';
import '../handler/preference.dart';
import '../resources/resource.dart';
import 'bottomBar/add_water_screen.dart';
import 'bottomBar/dashboard_screen.dart';
import 'bottomBar/diary_setting.dart';
import 'bottomBar/more_screen.dart';
import 'bottomBar/plans_screen.dart';
import 'exit_screen.dart';

class HomeScreenData {
  final int index;
  final DateTime date;

  HomeScreenData({required this.index, required this.date});
}

class HomeScreen extends StatefulWidget {
  final HomeScreenData data;
  static const route = '/Home-Screen';

  const HomeScreen({required this.data});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  DateTime selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DatabaseHelper helper = DatabaseHelper();
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
      iron: '');
  List<String> goals = [];
  List<String> mealData = [];
  List<String> recipeData = [];
  List<String> foodData = [];
  List<String> quickAddData = [];
  List<String> cardioData = [];
  List<String> strengthData = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> listNoteFuture = helper.getUserDataList();
      listNoteFuture.then((data) {
        setState(() {
          userData = data!.first;
        });
        print('---userData------${userData.toString()}');
      });
    });
  }

  getGoalsData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Goals>?> listNoteFuture = helper.getGoalsList();
      listNoteFuture.then((data) async {
        print('---goals------${data.toString()}');
        for (int i = 0; i < data!.length; i++) {
          goals.add(data[i].goal!);
          await SharedPreference().storeListValue('goalList', goals);
        }
        setState(() {});
      });
    });
  }

  // getMealData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<MealData>?> mealDataList = helper.getMealList();
  //     mealDataList.then((data) async {
  //       print('---mealData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String meal = jsonEncode(data[i].toMap());
  //         mealData.add(meal);
  //         await SharedPreference().storeListValue('mealData', mealData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }
  //
  // getRecipeData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<RecipeData>?> recipeDataList = helper.getRecipeList();
  //     recipeDataList.then((data) async {
  //       print('---recipeData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String recipe = jsonEncode(data[i].toMap());
  //         recipeData.add(recipe);
  //         await SharedPreference().storeListValue('recipeData', recipeData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }
  //
  // getFoodData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<FoodData>?> foodDataList = helper.getFoodList();
  //     foodDataList.then((data) async {
  //       print('---foodData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String meal = jsonEncode(data[i].toMap());
  //         foodData.add(meal);
  //         await SharedPreference().storeListValue('foodData', foodData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }
  //
  // getQuickAddData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<QuickAddData>?> quickAddDataList = helper.getQuickAddList();
  //     quickAddDataList.then((data) async {
  //       print('---quickAddData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String quickAdd = jsonEncode(data[i].toMap());
  //         quickAddData.add(quickAdd);
  //         await SharedPreference().storeListValue('quickAddData', quickAddData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }
  //
  // getCardioData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<CardioData>?> cardioDataList = helper.getCardioExerciseList();
  //     cardioDataList.then((data) async {
  //       print('---cardioData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String cardio = jsonEncode(data[i].toMap());
  //         cardioData.add(cardio);
  //         await SharedPreference().storeListValue('cardioData', cardioData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }
  //
  // getStrengthData() {
  //   final Future<Database> dbFuture = helper.initializeDatabase();
  //   dbFuture.then((database) {
  //     Future<List<StrengthData>?> strengthDataList = helper.getStrengthExerciseList();
  //     strengthDataList.then((data) async {
  //       print('---strengthData------${data.toString()}');
  //       for (int i = 0; i < data!.length; i++) {
  //         String strength = jsonEncode(data[i].toMap());
  //         strengthData.add(strength);
  //         await SharedPreference().storeListValue('strengthData', strengthData);
  //       }
  //       setState(() {});
  //     });
  //   });
  // }

  // getUserGoals() async {
  //   setState(() {});
  //   List<String> goal = await SharedPreference().getGoalsList('goalList');
  //   setState(() {});
  //   goals = goal;
  //   print('------goal------$goals');
  // }

  @override
  void initState() {
    getUserData();
    getGoalsData();
    // getUserGoals();
    // getMealData();
    // getRecipeData();
    // getFoodData();
    // getQuickAddData();
    // getCardioData();
    // getStrengthData();
    setState(() {
      _selectedIndex = widget.data.index;
      selectedDate = widget.data.date;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBG,
      appBar: _selectedIndex == 1
          ? AppBar(
              toolbarHeight: deviceHeight(context) * 0.08,
              backgroundColor: colorBG,
              elevation: 5,
              shadowColor: colorIndigo.withOpacity(0.25),
              leadingWidth: deviceWidth(context) * 0.18,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(UserScreen.route);
                },
                child: buttons(icUser),
              ),
              title: Text('NutriMe', style: textStyle24Bold(colorIndigo)),
            )
          : _selectedIndex == 2
              ? AppBar(
                  toolbarHeight: deviceHeight(context) * 0.08,
                  backgroundColor: colorBG,
                  elevation: 5,
                  shadowColor: colorIndigo.withOpacity(0.25),
                  leading: Container(),
                  leadingWidth: deviceWidth(context) * 0.03,
                  title: Text('Diary', style: textStyle24Bold(colorIndigo)),
                  actions: [
                    Padding(
                      padding:
                          EdgeInsets.only(right: deviceWidth(context) * 0.03),
                      child: PopupMenuButton(
                          icon: buttons(icMoreVert),
                          offset: Offset(-deviceWidth(context) * 0.02,
                              deviceHeight(context) * 0.065),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: colorIndigo, width: 1),
                              borderRadius: BorderRadius.circular(7)),
                          itemBuilder: (context) => [
                                menuItem('Add Water', () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      AddWaterScreen.route,
                                      arguments: AddWaterData(
                                          selDate: DateFormat('yyyy-MM-dd')
                                              .format(selectedDate),
                                          type: 'Add'));
                                }),
                                menuItem('Add Note', () {
                                  Navigator.of(context).pop();
                                  return showDialog(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, setState) =>
                                                Dialogs(
                                                    type: 'Notes',
                                                    selDate: selectedDate));
                                      });
                                }),
                                menuItem('Diary Settings', () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context)
                                      .pushNamed(DiarySettingScreen.route);
                                }),
                              ]),
                    )
                  ],
                )
              : _selectedIndex == 3
                  ? AppBar(
                      toolbarHeight: deviceHeight(context) * 0.08,
                      backgroundColor: colorBG,
                      elevation: 5,
                      shadowColor: colorIndigo.withOpacity(0.25),
                      leading: Container(),
                      leadingWidth: deviceWidth(context) * 0.03,
                      title: Text('Plan', style: textStyle24Bold(colorIndigo)),
                    )
                  : null,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pushNamed(ExitScreen.route);
              return true;
            },
            child: _selectedIndex == 1
                ? const DashboardScreen()
                : _selectedIndex == 2
                    ? SingleChildScrollView(
                        child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: Container(
                                height: 50,
                                decoration: decoration(colorIndigo, 5),
                                child: Row(
                                  children: [
                                    SizedBox(width: deviceWidth(context) * 0.1),
                                    arrowButton(icBack, () {
                                      selectedDate = selectedDate
                                          .subtract(const Duration(days: 1));
                                      BlocProvider.of<DateBloc>(context).add(
                                          GetDiaryDateEvent(
                                              date: selectedDate));
                                    }),
                                    const Spacer(),
                                    BlocBuilder<DateBloc, DateState>(
                                      builder: (context, state) {
                                        if (state is GetDiaryDateData) {
                                          print(
                                              '------selectedDate11----$selectedDate');
                                          return commonText(state.date);
                                        }
                                        print(
                                            '------selectedDate22----$selectedDate');
                                        return commonText(selectedDate);
                                      },
                                    ),
                                    const Spacer(),
                                    arrowButton(icNext, () {
                                      selectedDate = selectedDate
                                          .add(const Duration(days: 1));
                                      BlocProvider.of<DateBloc>(context).add(
                                          GetDiaryDateEvent(
                                              date: selectedDate));
                                    }),
                                    SizedBox(width: deviceWidth(context) * 0.1)
                                  ],
                                ),
                              ),
                            ),
                            DiaryScreen(selectedDate: selectedDate)
                          ],
                        ),
                      ))
                    : _selectedIndex == 3
                        ? const PlansScreen()
                        : _selectedIndex == 4
                            ? const MoreScreen()
                            : Container()),
      ),
      bottomNavigationBar: Stack(
        children: [
          Container(
            height: deviceHeight(context) * 0.11,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: colorIndigo.withOpacity(0.3),
                    offset: const Offset(0.0, -0.5),
                    blurRadius: 10,
                  )
                ]),
          ),
          getBottomSheet(),
        ],
      ),
    );
  }

  commonText(DateTime date) {
    DateTime todayDate =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    return Text(
        date.difference(todayDate) == -const Duration(days: 1)
            ? 'Yesterday'
            : date.difference(todayDate) == const Duration(days: 0)
                ? 'Today'
                : date.difference(todayDate) == const Duration(days: 1)
                    ? 'Tomorrow'
                    : DateFormat('dd MMM yyyy').format(date),
        style: textStyle16Bold(colorIndigo));
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  buttons(String icon) {
    return Padding(
      padding: icon == icUser
          ? EdgeInsets.symmetric(
              vertical: (deviceHeight(context) * 0.08 -
                      deviceHeight(context) * 0.042) /
                  2,
              horizontal:
                  (deviceWidth(context) * 0.18 - deviceWidth(context) * 0.085) /
                      2)
          : EdgeInsets.zero,
      child: Container(
        height: deviceHeight(context) * 0.042,
        width: deviceWidth(context) * 0.085,
        decoration: decoration(colorIndigo, 5),
        alignment: Alignment.center,
        child: Image.asset(icon,
            width: icon == icMoreVert
                ? deviceWidth(context) * 0.055
                : deviceWidth(context) * 0.04),
      ),
    );
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        height: 40,
        padding: EdgeInsets.zero,
        child: InkWell(
          splashColor: colorWhite,
          onTap: onClick,
          child: Container(
              width: 160,
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 10),
              child: Text(title, style: textStyle16Medium(colorIndigo))),
        ));
  }

  arrowButton(String icon, Function() onClick) {
    return IconButton(
        splashRadius: deviceWidth(context) * 0.075,
        splashColor: colorWhite,
        onPressed: onClick,
        icon: Image.asset(icon, width: deviceWidth(context) * 0.05));
  }

  Widget bottomIcon(String icon, String title, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: deviceWidth(context) * 0.2,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              color: _selectedIndex == index
                  ? colorIndigo
                  : colorIndigo.withOpacity(0.4),
              width: deviceWidth(context) * 0.08,
            ),
            SizedBox(height: deviceHeight(context) * 0.01),
            Text(title,
                style: textStyle12Bold(_selectedIndex == index
                    ? colorIndigo
                    : colorIndigo.withOpacity(0.4)))
          ],
        ),
      ),
    );
  }

  Widget getBottomSheet() {
    return Container(
      height: deviceHeight(context) * 0.11,
      decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bottomIcon(icDashBoard, 'Dashboard', 1),
          bottomIcon(icDiary, 'Diary', 2),
          bottomIcon(icPlans, 'Plans', 3),
          bottomIcon(icHomeMore, 'More', 4),
        ],
      ),
    );
  }
}
