import 'package:flutter/material.dart';
import 'package:nutrime/models/cardio_exercise_data.dart';
import 'package:nutrime/models/strength_exercise_data.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/bottomBar/add_exercise_screen.dart';
import 'package:nutrime/screens/bottomBar/update_exercise_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';

class ExerciseData {
  final String exerciseType;
  final String selDate;

  ExerciseData({required this.exerciseType, required this.selDate});
}

class ExerciseScreen extends StatefulWidget {
  final ExerciseData data;
  static const route = '/Exercise-Screen';

  const ExerciseScreen({required this.data});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<CardioData> cardioData = [];
  List<StrengthData> strengthData = [];

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
    getCardioData();
    getStrengthData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
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
                title: Text(widget.data.exerciseType,
                    style: textStyle20Bold(colorIndigo)),
                // actions: [buttons(icMoreVert, () => null)],
                bottom: TabBar(
                  indicatorColor: colorIndigo,
                  indicatorWeight: 3,
                  indicatorPadding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.02),
                  labelPadding: EdgeInsets.zero,
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight(context) * 0.02),
                        child: Text('Most Used',
                            style: textStyle14Bold(colorIndigo)),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight(context) * 0.02),
                        child: Text('My Exercise',
                            style: textStyle14Bold(colorIndigo)),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: deviceHeight(context) * 0.02),
                        child: Text('Browse All',
                            style: textStyle14Bold(colorIndigo)),
                      ),
                    ),
                  ],
                )),
        body: TabBarView(children: [
          if (widget.data.exerciseType == 'Cardio')
            cardioData.isEmpty
                ? Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth(context) * 0.06,
                  right: deviceWidth(context) * 0.06,
                  top: 30),
              child: Text(
                  'Once you start adding exercises to your diary, your most used list will show a summary of the exercises you do frequently.',
                  style: textStyle14(colorIndigo)
                      .copyWith(height: 1.3)),
            )
                : Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                      itemCount: cardioData.length,
                      itemBuilder: (context, index) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  UpdateExerciseScreen.route,
                                  arguments: UpdateExerciseData(
                                      type: widget.data.exerciseType,
                                      exerciseData:
                                      cardioData[index]));
                            },
                            child: Container(
                              height: 60,
                              width: deviceWidth(context),
                              decoration: decoration(0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5),
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.05),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(cardioData[index].description!,
                                      style: textStyle16Bold(
                                          colorIndigo)),
                                  Text(
                                      '${cardioData[index].time!} minutes',
                                      style:
                                      textStyle14(colorIndigo)),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
          if (widget.data.exerciseType == 'Strength')
            strengthData.isEmpty
                ? Padding(
              padding: EdgeInsets.only(
                  left: deviceWidth(context) * 0.06,
                  right: deviceWidth(context) * 0.06,
                  top: 30),
              child: Text(
                  'Once you start adding exercises to your diary, your most used list will show a summary of the exercises you do frequently.',
                  style: textStyle14(colorIndigo)
                      .copyWith(height: 1.3)),
            )
                : Column(
                  children: [
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                      itemCount: strengthData.length,
                      itemBuilder: (context, index) =>
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  UpdateExerciseScreen.route,
                                  arguments: UpdateExerciseData(
                                      type: widget.data.exerciseType,
                                      exerciseData:
                                      strengthData[index]));
                            },
                            child: Container(
                              height: 60,
                              width: deviceWidth(context),
                              decoration: decoration(0),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5),
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.05),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      strengthData[index]
                                          .description!,
                                      style: textStyle16Bold(
                                          colorIndigo)),
                                  Row(
                                    children: [
                                      Text(
                                          '${strengthData[index].hashOfSet!} sets, ${strengthData[index].repetitionSet!} reps',
                                          style: textStyle14(
                                              colorIndigo)),
                                      if (strengthData[index]
                                          .weightPerRepetition!
                                          .isNotEmpty)
                                        Text(
                                            ', ${strengthData[index].weightPerRepetition!} kg',
                                            style: textStyle14(
                                                colorIndigo)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
          Padding(
            padding: EdgeInsets.only(
                left: deviceWidth(context) * 0.06,
                right: deviceWidth(context) * 0.06,
                top: 30),
            child: Text(
                'Want to add your custom exercises quickly? Your my exercise list will show you any custom exercises you created earlier.',
                style:
                textStyle14(colorIndigo).copyWith(height: 1.3)),
          ),
          const Center(child: Text('Browse all')),
        ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: deviceHeight(context) * 0.01,
              right: deviceWidth(context) * 0.02),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AddExerciseScreen.route,
                  arguments: AddExerciseData(
                      exerciseType: widget.data.exerciseType,
                      selDate: widget.data.selDate));
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
