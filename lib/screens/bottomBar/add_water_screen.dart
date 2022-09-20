import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrime/models/water_data.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';

class AddWaterData {
  final String selDate;
  final String type;

  AddWaterData({required this.selDate, required this.type});
}

class AddWaterScreen extends StatefulWidget {
  final AddWaterData data;
  static const route = '/Add-Water';

  const AddWaterScreen({required this.data});

  @override
  State<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends State<AddWaterScreen> {
  final TextEditingController _waterController = TextEditingController();
  String selectedType = 'ml';
  DatabaseHelper helper = DatabaseHelper();
  WaterData waterData = WaterData(date: '', water: '');
  bool check = false;
  bool isFilled = false;
  bool isFocus = false;

  List<String> weightType = [
    'ml',
    'liter',
    'cup(s)',
  ];

  List<String> mlTypes = ['250', '500', '1000'];
  List<String> ltrTypes = ['1', '2', '5'];
  List<String> cupTypes = ['1', '2', '5'];

  getWaterDataView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WaterData>?> listNoteFuture = helper.getWaterList();
      listNoteFuture.then((data) {
        print('-------data-------$data');
        print('--selDate----${widget.data.selDate}');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == widget.data.selDate) {
              setState(() {
                waterData = data.firstWhere(
                    (element) => element.date == widget.data.selDate);
                if (widget.data.type == 'Update') {
                  _waterController.text = waterData.water!.split(' ')[0];
                  _waterController.selection = TextSelection.fromPosition(
                      TextPosition(offset: _waterController.text.length));
                  isFilled = true;
                }
                selectedType = waterData.water!.split(' ')[1];
              });
            }
          }
        }
        check = waterData.water!.isEmpty;
        print('-----check----$check');
        print('----waterData---------${waterData.toString()}');
        print('-----water-------${_waterController.text}');
      });
    });
  }

  @override
  void initState() {
    getWaterDataView();
    Timer(const Duration(milliseconds: 550), () {
      setState(() {
        isFocus = true;
      });
    });
    print('-------type-----------${widget.data.type}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.15,
        leading: buttons(icBack, () {
          FocusManager.instance.primaryFocus?.unfocus();
          Navigator.of(context).pop();
        }),
        title: Text(widget.data.type == 'Add' ? 'Add Water' : 'Edit Total',
            style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () {
                  if (isFilled) {
                    setState(() {
                      waterData.date = widget.data.selDate;
                      waterData.water = check
                          ? '${_waterController.text} $selectedType'
                          : widget.data.type == 'Add'
                              ? '${int.parse(_waterController.text) + int.parse(waterData.water!.split(' ')[0])} $selectedType'
                              : '${_waterController.text} $selectedType';
                    });
                    check
                        ? helper.insertWater(waterData)
                        : helper.updateWaterData(waterData);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (Route<dynamic> route) => false,
                        arguments: HomeScreenData(
                            index: 2,
                            date: DateTime.parse(widget.data.selDate)));
                    FocusManager.instance.primaryFocus?.unfocus();
                  }
                },
                icon: Image.asset(icSaveWeight,
                    color:
                        isFilled ? colorIndigo : colorIndigo.withOpacity(0.2),
                    width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: deviceHeight(context) * 0.07),
            Container(
              height: deviceHeight(context) * 0.25,
              width: deviceWidth(context) * 0.85,
              decoration: decoration(Colors.transparent, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(imgWaterBottles,
                      width: deviceWidth(context) * 0.3),
                  Container(
                    height: deviceHeight(context) * 0.06,
                    width: deviceWidth(context) * 0.44,
                    decoration: decoration(colorGrey.withOpacity(0.5), 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: deviceWidth(context) * 0.015),
                        SizedBox(
                          height: deviceHeight(context) * 0.04,
                          width: deviceWidth(context) * 0.16,
                          child: TextFormField(
                            controller: _waterController,
                            autofocus: isFocus,
                            style:
                                textStyle16Bold(colorIndigo.withOpacity(0.6)),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                            ],
                            onChanged: (val) {
                              if (val.isNotEmpty) {
                                setState(() {
                                  isFilled = true;
                                });
                              } else {
                                setState(() {
                                  isFilled = false;
                                });
                              }
                            },
                            cursorColor: colorIndigo,
                            decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: textStyle16Bold(
                                    colorIndigo.withOpacity(0.6)),
                                border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: colorIndigo, width: 1))),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const Spacer(),
                        Text(selectedType, style: textStyle16Bold(colorIndigo)),
                        PopupMenuButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.arrow_drop_down,
                                color: colorIndigo,
                                size: deviceWidth(context) * 0.08),
                            offset: Offset(-deviceWidth(context) * 0.02,
                                deviceHeight(context) * 0.058),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: colorIndigo, width: 1),
                                borderRadius: BorderRadius.circular(7)),
                            itemBuilder: (context) =>
                                List<PopupMenuItem>.generate(
                                    weightType.length,
                                    (index) => menuItem(weightType[index], () {
                                          setState(() {
                                            selectedType = weightType[index];
                                          });
                                          Navigator.of(context).pop();
                                        })))
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: deviceHeight(context) * 0.02),
            if (selectedType == weightType[0]) initialValue(mlTypes, ' ml'),
            if (selectedType == weightType[1]) initialValue(ltrTypes, ' ltr'),
            if (selectedType == weightType[2]) initialValue(cupTypes, ' cups'),
          ],
        ),
      ),
    ));
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: onClick,
      child: Text(title, style: textStyle16Medium(colorIndigo)),
    ));
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: color, width: 2) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: color.withOpacity(0.3),
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

  initialValue(List<String> list, String type) {
    return SizedBox(
      width: deviceWidth(context) * 0.85,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
              list.length,
              (index) => GestureDetector(
                    onTap: () {
                      _waterController.text = list[index];
                    },
                    child: Container(
                      height: 40,
                      width: deviceWidth(context) * 0.22,
                      decoration: BoxDecoration(
                          border: Border.all(color: colorIndigo, width: 1),
                          borderRadius: BorderRadius.circular(5),
                          color: colorWhite),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+', style: textStyle16Bold(colorIndigo)),
                          Text(list[index],
                              style: textStyle16Bold(colorIndigo)),
                          Text(type, style: textStyle14Bold(colorIndigo)),
                        ],
                      ),
                    ),
                  ))),
    );
  }
}
