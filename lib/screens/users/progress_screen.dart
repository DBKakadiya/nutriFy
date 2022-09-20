import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:nutrime/screens/users/display_weight_data_screen.dart';
import 'package:nutrime/screens/users/import_photo_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../handler/handler.dart';
import '../../models/chart_data.dart';
import '../../resources/resource.dart';

class ProgressScreen extends StatefulWidget {
  static const route = '/Progress-Screen';

  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<WeightData> weightData = [];
  TooltipBehavior? _tooltipBehavior;
  DatabaseHelper helper = DatabaseHelper();

  List<ChartData> chartData = [];
  bool? isImport;

  void getWeightData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WeightData>?> userDataList = helper.getWeightList();
      userDataList.then((data) {
        setState(() {
          weightData = data!;
        });
        print('--------weightData-------$weightData');
        for (var i in weightData) {
          chartData.add(ChartData(date: i.date!, weight: int.parse(i.weight!)));
        }
        weightData = List.from(weightData.reversed);
      });
    });
  }

  onLongPressData(String date, Function() onImportReplace,
      Function() onDltPhoto, Function() onDltEntry) {
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
                        height: isImport! ? 160 : 213,
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
                                child: Text(date,
                                    style: textStyle18Bold(colorIndigo))),
                            Column(
                              children: [
                                if (isImport!)
                                  selectOption(Icons.camera_alt, 'Import Photo',
                                      onImportReplace),
                                if (!isImport!)
                                  Column(
                                    children: [
                                      selectOption(Icons.camera_alt,
                                          'Replace Photo', onImportReplace),
                                      Container(
                                          height: 1,
                                          color: colorGrey.withOpacity(0.5)),
                                      selectOption(Icons.delete, 'Delete Photo',
                                          onDltPhoto),
                                    ],
                                  ),
                                Container(
                                    height: 1,
                                    color: colorGrey.withOpacity(0.5)),
                                selectOption(
                                    Icons.delete, 'Delete Entry', onDltEntry),
                              ],
                            ),
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
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      header: 'Weight',
      borderColor: Colors.transparent,
      color: colorIndigo.withOpacity(0.05),
      format: 'point.x : point.y kg',
      canShowMarker: false,
    );
    getWeightData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.15,
        leading: buttons(icBack, () => Navigator.of(context).pop()),
        title: Text('Progress', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
          child: Column(
            children: [
              SizedBox(height: deviceHeight(context) * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // dropDownButtons('Weight', () => null),
                  Padding(
                    padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
                    child: Text('Weight', style: textStyle18Bold(colorIndigo)),
                  ),
                  // dropDownButtons('Period', () => null),
                ],
              ),
              SizedBox(height: deviceHeight(context) * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: deviceHeight(context) * 0.015),
                child: Container(
                  height: deviceHeight(context) * 0.35,
                  decoration: decoration(18),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: SfCartesianChart(
                        tooltipBehavior: _tooltipBehavior,
                        primaryXAxis: DateTimeAxis(),
                        series: <ChartSeries>[
                          LineSeries<ChartData, DateTime>(
                              color: colorIndigo,
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) =>
                                  DateTime.parse(data.date),
                              yValueMapper: (ChartData data, _) => data.weight)
                        ]),
                  ),
                ),
              ),
              SizedBox(height: deviceHeight(context) * 0.03),
              Container(
                height: deviceHeight(context) * 0.065,
                decoration: decoration(4),
                child: Row(
                  children: [
                    SizedBox(width: deviceWidth(context) * 0.04),
                    Text('Entries', style: textStyle16Bold(colorIndigo)),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {},
                        child: Image.asset(icShare,
                            width: deviceWidth(context) * 0.065)),
                    SizedBox(width: deviceWidth(context) * 0.04),
                  ],
                ),
              ),
              SizedBox(height: deviceHeight(context) * 0.025),
              Column(
                children: List.generate(
                    weightData.length,
                    (index) => Padding(
                          padding: EdgeInsets.only(
                              bottom: deviceHeight(context) * 0.025),
                          child: GestureDetector(
                            onTap: () {
                              weightData[index].image!.isEmpty
                                  ? Navigator.of(context).pushNamed(
                                      ImportPhotoScreen.route,
                                      arguments: WeightData(
                                          date: weightData[index].date,
                                          weight: weightData[index].weight,
                                          image: weightData[index].image))
                                  : Navigator.of(context).pushReplacementNamed(
                                      DisplayWeightDataScreen.route,
                                      arguments: weightData[index].image);
                            },
                            onLongPress: () {
                              if (weightData[index].image!.isNotEmpty) {
                                setState(() {
                                  isImport = false;
                                });
                                onLongPressData(
                                    DateFormat('dd - MMM - yyyy').format(
                                        DateTime.parse(
                                            weightData[index].date!)), () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushNamed(
                                      ImportPhotoScreen.route,
                                      arguments: WeightData(
                                          date: weightData[index].date,
                                          weight: weightData[index].weight,
                                          image: weightData[index].image));
                                }, () {
                                  setState(() {
                                    weightData[index].image = '';
                                  });
                                  helper.updateWeightData(weightData[index]);
                                  // BlocProvider.of<WeightBloc>(context)
                                  //     .add(GetImageEvent(image: null));
                                  Navigator.of(context).pop();
                                }, () async {
                                  setState(() {
                                    weightData.removeWhere((element) =>
                                        element.date == weightData[index].date);
                                  });
                                  await helper.deleteWeight(
                                      weightData[index].date!.split(' ')[0]);
                                  Navigator.of(context).pop();
                                });
                              } else {
                                setState(() {
                                  isImport = true;
                                });
                                onLongPressData(
                                    DateFormat('dd - MMM - yyyy').format(
                                        DateTime.parse(
                                            weightData[index].date!)),
                                    () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushNamed(
                                          ImportPhotoScreen.route,
                                          arguments: WeightData(
                                              date: weightData[index].date,
                                              weight: weightData[index].weight,
                                              image: weightData[index].image));
                                    },
                                    () {},
                                    () async {
                                      setState(() {
                                        weightData.removeWhere((element) =>
                                        element.date == weightData[index].date);
                                      });
                                      await helper.deleteWeight(
                                          weightData[index].date!.split(' ')[0]);
                                      Navigator.of(context).pop();
                                    });
                              }
                            },
                            child: Container(
                              height: deviceHeight(context) * 0.085,
                              decoration: decoration(4),
                              child: Row(
                                children: [
                                  SizedBox(width: deviceWidth(context) * 0.04),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          DateFormat('dd-MMM-yyyy').format(
                                              DateTime.parse(
                                                  weightData[index].date!)),
                                          style: textStyle16Bold(colorIndigo)),
                                      Text('${weightData[index].weight} kg',
                                          style: textStyle14(colorIndigo))
                                    ],
                                  ),
                                  const Spacer(),
                                  if (weightData[index].image!.isEmpty)
                                    Container(
                                      height: deviceHeight(context) * 0.04,
                                      width: deviceWidth(context) * 0.12,
                                      alignment: Alignment.center,
                                      child: Image.asset(icPhoto),
                                    ),
                                  if (weightData[index].image!.isNotEmpty)
                                    SizedBox(
                                      height: deviceHeight(context) * 0.07,
                                      width: deviceWidth(context) * 0.12,
                                      child: Image.file(
                                          File(weightData[index].image!),
                                          fit: BoxFit.fill),
                                    ),
                                  SizedBox(width: deviceWidth(context) * 0.04),
                                ],
                              ),
                            ),
                          ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if (radius == 5 || radius == 5.1)
            BoxShadow(
                color: colorIndigo.withOpacity(radius == 5 ? 0.3 : 0.15),
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

  dropDownButtons(String title, Function() onclick) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        height: deviceHeight(context) * 0.045,
        width: deviceWidth(context) * 0.29,
        decoration: decoration(5.1),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            Text(title, style: textStyle16Bold(colorIndigo)),
            Icon(Icons.arrow_drop_down,
                color: colorIndigo, size: deviceWidth(context) * 0.1)
          ],
        ),
      ),
    );
  }

  selectOption(IconData icon, String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth(context) * 0.05),
      child: GestureDetector(
        onTap: onClick,
        child: SizedBox(
          height: 52,
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
