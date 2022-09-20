import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/resources/resource.dart';

import '../../blocs/date/date_bloc.dart';
import '../../blocs/date/date_event.dart';
import '../../blocs/date/date_state.dart';
import '../../widgets/nutritionTabBar/calories.dart';
import '../../widgets/nutritionTabBar/macros.dart';
import '../../widgets/nutritionTabBar/nutrients.dart';

class NutritionScreen extends StatefulWidget {
  final int index;
  static const route = '/Nutrition-Screen';

  const NutritionScreen({required this.index});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  DateTime selCalorieDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selNutrientDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selMacrosDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget.index,
      child: Scaffold(
        backgroundColor: colorBG,
        appBar: AppBar(
          toolbarHeight: deviceHeight(context) * 0.08,
          backgroundColor: colorWhite,
          elevation: 5,
          shadowColor: colorIndigo.withOpacity(0.25),
          leadingWidth: deviceWidth(context) * 0.15,
          leading: buttons(icBack, () {
            Navigator.of(context).pop();
            BlocProvider.of<DateBloc>(context).add(GetCalorieDateEvent(
                date: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)));
            BlocProvider.of<DateBloc>(context).add(GetNutrientDateEvent(
                date: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)));
            BlocProvider.of<DateBloc>(context).add(GetMacrosDateEvent(
                date: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day)));
          }),
          title: Text('Nutrition', style: textStyle20Bold(colorIndigo)),
          bottom: TabBar(
            indicatorColor: colorIndigo,
            indicatorWeight: 3,
            indicatorPadding:
                EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05),
            labelPadding: EdgeInsets.zero,
            tabs: [
              Tab(
                child: Padding(
                  padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
                  child: Text('Calories', style: textStyle14Bold(colorIndigo)),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
                  child: Text('Nutrients', style: textStyle14Bold(colorIndigo)),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.only(top: deviceHeight(context) * 0.02),
                  child: Text('Macros', style: textStyle14Bold(colorIndigo)),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: deviceHeight(context) * 0.03),
                      Container(
                        height: deviceHeight(context) * 0.07,
                        decoration: decoration(colorGrey, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: deviceWidth(context) * 0.1),
                            arrowButton(icBack, () {
                              selCalorieDate = selCalorieDate
                                  .subtract(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context).add(
                                  GetCalorieDateEvent(date: selCalorieDate));
                            }),
                            const Spacer(),
                            BlocBuilder<DateBloc, DateState>(
                              builder: (context, state) {
                                if (state is GetCalorieDateData) {
                                  print(
                                      '------selCalorieDate11----$selCalorieDate');
                                  return commonText(state.date);
                                }
                                print(
                                    '------selCalorieDate22----$selCalorieDate');
                                return commonText(selCalorieDate);
                              },
                            ),
                            const Spacer(),
                            arrowButton(icNext, () {
                              selCalorieDate =
                                  selCalorieDate.add(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context).add(
                                  GetCalorieDateEvent(date: selCalorieDate));
                            }),
                            SizedBox(width: deviceWidth(context) * 0.1),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight(context) * 0.01),
                    ],
                  ),
                ),
                BlocBuilder<DateBloc, DateState>(
                  builder: (context, state) {
                    if(state is GetCalorieDateData){
                      return Calories(selectedDate: state.date);
                    }
                    return Calories(selectedDate: selCalorieDate);
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: deviceHeight(context) * 0.03),
                      Container(
                        height: deviceHeight(context) * 0.07,
                        decoration: decoration(colorGrey, 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(width: deviceWidth(context) * 0.1),
                            arrowButton(icBack, () {
                              selNutrientDate = selNutrientDate
                                  .subtract(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context).add(
                                  GetNutrientDateEvent(date: selNutrientDate));
                            }),
                            const Spacer(),
                            BlocBuilder<DateBloc, DateState>(
                              builder: (context, state) {
                                if (state is GetNutrientDateData) {
                                  print(
                                      '------selNutrientDate11----$selNutrientDate');
                                  return commonText(state.date);
                                }
                                print(
                                    '------selNutrientDate22----$selNutrientDate');
                                return commonText(selNutrientDate);
                              },
                            ),
                            const Spacer(),
                            arrowButton(icNext, () {
                              selNutrientDate =
                                  selNutrientDate.add(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context).add(
                                  GetNutrientDateEvent(date: selNutrientDate));
                            }),
                            SizedBox(width: deviceWidth(context) * 0.1),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight(context) * 0.01),
                    ],
                  ),
                ),
                BlocBuilder<DateBloc, DateState>(
                  builder: (context, state) {
                    if(state is GetNutrientDateData){
                      return Nutrients(selectedDate: state.date);
                    }
                    return Nutrients(selectedDate: selNutrientDate);
                  },
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.06),
                  child: Column(
                    children: [
                      SizedBox(height: deviceHeight(context) * 0.03),
                      Container(
                        height: deviceHeight(context) * 0.07,
                        decoration: decoration(colorGrey, 30),
                        child: Row(
                          children: [
                            SizedBox(width: deviceWidth(context) * 0.1),
                            arrowButton(icBack, () {
                              selMacrosDate = selMacrosDate
                                  .subtract(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context)
                                  .add(GetMacrosDateEvent(date: selMacrosDate));
                            }),
                            const Spacer(),
                            BlocBuilder<DateBloc, DateState>(
                              builder: (context, state) {
                                if (state is GetMacrosDateData) {
                                  print(
                                      '------selMacrosDate11----$selMacrosDate');
                                  return commonText(state.date);
                                }
                                print(
                                    '------selMacrosDate22----$selMacrosDate');
                                return commonText(selMacrosDate);
                              },
                            ),
                            const Spacer(),
                            arrowButton(icNext, () {
                              selMacrosDate =
                                  selMacrosDate.add(const Duration(days: 1));
                              BlocProvider.of<DateBloc>(context)
                                  .add(GetMacrosDateEvent(date: selMacrosDate));
                            }),
                            SizedBox(width: deviceWidth(context) * 0.1),
                          ],
                        ),
                      ),
                      SizedBox(height: deviceHeight(context) * 0.01),
                    ],
                  ),
                ),
                BlocBuilder<DateBloc, DateState>(
                  builder: (context, state) {
                    if(state is GetMacrosDateData){
                      return Macros(selectedDate: state.date);
                    }
                    return Macros(selectedDate: selMacrosDate);

                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: radius == 4
            ? colorBG
            : radius == 30
                ? colorIndigo
                : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorWhite, width: 2.5) : null,
        boxShadow: [
          BoxShadow(
              color: radius == 5
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.15),
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
          decoration: decoration(colorIndigo, 5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  nutritionData(String title, String value, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(colorGrey, 4),
          child: Row(
            children: [
              SizedBox(width: deviceWidth(context) * 0.04),
              Text(title, style: textStyle16Bold(colorIndigo)),
              const Spacer(),
              Text(value, style: textStyle16Bold(colorIndigo)),
              SizedBox(width: deviceWidth(context) * 0.04),
            ],
          ),
        ),
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
        style: textStyle16Bold(colorWhite));
  }

  arrowButton(String icon, Function() onClick) {
    return IconButton(
        splashRadius: deviceWidth(context) * 0.075,
        splashColor: colorWhite,
        onPressed: onClick,
        icon: Image.asset(icon,
            color: colorWhite, width: deviceWidth(context) * 0.05));
  }
}
