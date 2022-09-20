import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrime/models/goal_data.dart';
import 'package:nutrime/models/user_data.dart';
import 'package:nutrime/resources/resource.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

import '../handler/handler.dart';
import '../handler/preference.dart';
import '../widgets/error_dialog.dart';

class StartingScreen extends StatefulWidget {
  static const route = '/Starting-Screen';

  const StartingScreen({Key? key}) : super(key: key);

  @override
  State<StartingScreen> createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int index = 0;
  int status = 0;
  bool isBackup = false;
  Iterable<bool> foundTrue = [];
  List<UserData> listUser = [
    UserData(
        name: '',
        goalReason: '',
        activityLevel: '',
        gender: '',
        age: 0,
        country: '',
        dateOfBirth: '',
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
        iron: '')
  ];
  List<String> goals = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchController = TextEditingController();
  final TextEditingController _kiloController = TextEditingController();
  final TextEditingController _gramController = TextEditingController();
  final TextEditingController _goalKiloController = TextEditingController();
  final TextEditingController _goalGramController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();
  UserData userData = UserData(
      name: '',
      goalReason: '',
      activityLevel: '',
      gender: '',
      age: 0,
      country: '',
      dateOfBirth: '',
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

  List<bool> selectedGoal = List.generate(goalList.length, (index) => false);
  List<bool> selectedReason =
      List.generate(goalReason.length, (index) => false);
  List<bool> selectedNutrition =
      List.generate(nutritionGoal.length, (index) => false);
  List<bool> selectedActivity =
      List.generate(activityTitles.length, (index) => false);
  List<bool> genderBool = List.generate(gender.length, (index) => false);
  List<bool> weeklyGoalBool =
      List.generate(weeklyGoal.length, (index) => false);

  String selectedCountry = 'India';
  String selectedHeight = 'Height';
  String selectedWeight = 'Weight';
  String goalWeight = 'Weight';

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        if (data!.isNotEmpty) {
          setState(() async {
            userData = data.first;
            listUser = data;
            if (userData.name!.isNotEmpty) {
              _nameController.text = userData.name!;
            }
            if (userData.gender!.isNotEmpty) {
              for (int i = 0; i < gender.length; i++) {
                if (gender[i] == userData.gender) {
                  genderBool[i] = true;
                }
              }
            }
            if (userData.age! > 0) {
              _ageController.text = userData.age!.toString();
            }
            if (userData.country!.isNotEmpty) {
              selectedCountry = userData.country!;
            }
            if (userData.height!.isNotEmpty) {
              selectedHeight = userData.height!;
              _feetController.text = userData.height!.split(' ')[0].toString();
              if (userData.height!.contains('in')) {
                _inchController.text =
                    userData.height!.split(' ')[2].toString();
              }
            }
            if (userData.weight!.isNotEmpty) {
              selectedWeight = userData.weight!;
              _kiloController.text = userData.weight!.split(' ')[0].toString();
              if (userData.weight!.contains('gram')) {
                _gramController.text =
                    userData.weight!.split(' ')[2].toString();
              }
            }
            List<String> goals =
                await SharedPreference().getGoalsList('goalList');
            for (int i = 0; i < goals.length; i++) {
              for (int j = 0; j < selectedGoal.length; j++) {
                if (goals[i] == goalList[j]) {
                  selectedGoal[j] = true;
                  foundTrue = selectedGoal.where((e) => e == true);
                }
              }
            }
            if (userData.goalReason!.isNotEmpty) {
              for (int i = 0; i < goalReason.length; i++) {
                if (goalReason[i] == userData.goalReason) {
                  selectedReason[i] = true;
                }
              }
            }
            if (userData.activityLevel!.isNotEmpty) {
              for (int i = 0; i < activityTitles.length; i++) {
                if (activityTitles[i] == userData.activityLevel) {
                  selectedActivity[i] = true;
                }
              }
            }
            if (userData.goalWeight!.isNotEmpty) {
              selectedWeight = userData.goalWeight!;
              _goalKiloController.text = userData.goalWeight!.split(' ')[0].toString();
              if (userData.goalWeight!.contains('gram')) {
                _goalGramController.text =
                    userData.goalWeight!.split(' ')[2].toString();
              }
            }
            if (userData.weeklyGoal!.isNotEmpty) {
              for (int i = 0; i < weeklyGoal.length; i++) {
                if (weeklyGoal[i] == userData.weeklyGoal) {
                  weeklyGoalBool[i] = true;
                }
              }
            }
          });
          print('----userData2-----$userData');
        }
      });
    });
  }

  setHeightWeight(
      String title,
      TextEditingController controller1,
      String controllerName1,
      TextEditingController controller2,
      String controllerName2,
      Function() onClick) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
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
                        height: deviceHeight(context) * 0.28,
                        width: deviceWidth(context) * 0.78,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(top: deviceHeight(context) * 0.025),
                              child: Text(title, style: textStyle20Bold(colorIndigo)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) * 0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  enterDataField(controller1, controllerName1),
                                  Container(
                                    height: deviceHeight(context) * 0.07,
                                    width: deviceWidth(context) * 0.005,
                                    color: colorWhite,
                                  ),
                                  enterDataField(controller2, controllerName2),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', () => Navigator.of(context).pop()),
                                Container(
                                  height: deviceHeight(context) * 0.07,
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', onClick),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }
       );
  }

  _getBackUp() async {
    setState(() {});
    var activate = await SharedPreference().getBackup('isBackup');
    setState(() {});
    isBackup = activate;
    final androidDeviceInfo = await DeviceInfoPlugin().androidInfo;
    isBackup
        ? null
        : int.parse(androidDeviceInfo.version.release) < 11
            ? restore()
            : null;
    print('---isBackup---$isBackup');
  }

  Future<void> restore() async {
    Directory _appDocDir = Directory('/storage/emulated/0/Download');
    Directory copyFrom = Directory(_appDocDir.path + '/NutriMe');
    File source1 = File(copyFrom.path + '/nutriMe.db');
    File source2 = File(copyFrom.path + '/stepCount.db');
    print('---source1---------$source1');
    print('---source2---------$source2');

    final dbFolder = await getDatabasesPath();
    print('---getDatabasePath---------$dbFolder');
    if ((await copyFrom.exists())) {
      print("Path----------------------exist");
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
        Permission.storage.request().isGranted.then((value) async {
          if (value) {
            String oldPath = dbFolder + "/nutriMe.db";
            String oldStepsCountPath = dbFolder + "/stepCount.db";
            print('-oldPath---------$oldPath');
            print('-oldStepsCountPath---------$oldStepsCountPath');
            File file1 = await source1.copy(oldPath);
            print('-----file1--------$file1');
            File file2 = await source2.copy(oldStepsCountPath);
            print('-----file2--------$file2');
            Navigator.of(context).pushReplacementNamed(HomeScreen.route,
                arguments: HomeScreenData(
                    index: 1,
                    date: DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)));
          }
          print('isGranted11-----$value');
        });
      } else if (status.isGranted) {
        print('----Already Granted');
      }
    } else {
      print("not-------exist");
      if (await Permission.storage.request().isGranted) {
        await copyFrom.create(recursive: true);
        print('------isCreated');
      } else {
        print('Please give permission');
      }
    }
  }

  _getStatusIndex() async {
    var sts = await SharedPreference().getStatus('status');
    var i = await SharedPreference().getIndex('index');
    status = sts;
    index = i;
    setState(() {});
    print('---status---$status');
    print('---index---$index');
  }

  @override
  void initState() {
    _getBackUp();
    _getStatusIndex();
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decorator = DotsDecorator(
      color: colorGrey.withOpacity(0.4),
      activeColor: colorIndigo,
      size: const Size.square(9),
      activeSize: const Size(18, 9),
      spacing: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.007),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorWhite,
      body: WillPopScope(
        onWillPop: () async {
          if (status == 0 && index == 0) {
            return true;
          } else if (status == 1 ||
              status == 2 ||
              status == 4 ||
              status == 5 ||
              status == 6) {
            setState(() {
              status--;
            });
            await SharedPreference().storeIntValue('status', status);
            return false;
          } else if (status == 3 || status == 7 || status == 8) {
            setState(() {
              status--;
              index--;
            });
            await SharedPreference().storeIntValue('status', status);
            await SharedPreference().storeIntValue('index', index);
            return false;
          } else {
            return true;
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (status == 0)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: deviceWidth(context) * 0.04),
                                    child: SizedBox(
                                        height: deviceHeight(context) * 0.25,
                                        width: deviceWidth(context) * 0.6,
                                        child: Image.asset(imgYou1,
                                            fit: BoxFit.fill)),
                                  )
                                ],
                              ),
                              SizedBox(height: deviceHeight(context) * 0.03),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth(context) * 0.08,
                                    vertical: deviceHeight(context) * 0.008),
                                child: editData(Padding(
                                    padding: EdgeInsets.only(
                                        left: deviceWidth(context) * 0.04),
                                    child: TextFormField(
                                      controller: _nameController,
                                      style: textStyle14Bold(colorIndigo),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          hintText: 'Enter your name',
                                          hintStyle: textStyle14Bold(
                                              colorIndigo.withOpacity(0.5)),
                                          border: InputBorder.none),
                                      keyboardType: TextInputType.name,
                                    ))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (status == 1)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: deviceWidth(context) * 0.06),
                          child: Column(
                            children: [
                              SizedBox(height: deviceHeight(context) * 0.03),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: deviceWidth(context) * 0.04),
                                    child: SizedBox(
                                        height: deviceHeight(context) * 0.17,
                                        width: deviceWidth(context) * 0.45,
                                        child: Image.asset(imgYou2,
                                            fit: BoxFit.fill)),
                                  )
                                ],
                              ),
                              SizedBox(height: deviceHeight(context) * 0.03),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth(context) * 0.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: deviceHeight(context) * 0.01),
                              Text(
                                  'Please select which sex we should use to calculator your calorie needs',
                                  style: textStyle18Bold(colorIndigo)),
                              SizedBox(height: deviceHeight(context) * 0.02),
                              SizedBox(
                                width: deviceWidth(context) * 0.9,
                                child: Text('Which one should i choose?',
                                    style: textStyle12Medium(
                                            colorIndigo.withOpacity(0.5))
                                        .copyWith(height: 1.3)),
                              ),
                              SizedBox(height: deviceHeight(context) * 0.02),
                              Text('Gender',
                                  style: textStyle18Bold(colorIndigo)),
                              SizedBox(height: deviceHeight(context) * 0.01),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: List.generate(
                                    gender.length,
                                    (index) => commonField(
                                            gender[index],
                                            genderBool[index],
                                            deviceHeight(context) * 0.06,
                                            deviceWidth(context) * 0.3,
                                            Alignment.center, () {
                                          genderBool = List.filled(
                                              genderBool.length, false,
                                              growable: true);
                                          setState(() {
                                            genderBool[index] =
                                                !genderBool[index];
                                          });
                                        })),
                              ),
                              SizedBox(height: deviceHeight(context) * 0.02),
                              Text('How old are you?',
                                  style: textStyle18Bold(colorIndigo)),
                              SizedBox(height: deviceHeight(context) * 0.01),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: deviceHeight(context) * 0.008),
                                child: editData(Padding(
                                    padding: EdgeInsets.only(
                                        left: deviceWidth(context) * 0.04),
                                    child: TextFormField(
                                      controller: _ageController,
                                      style: textStyle14Bold(colorIndigo),
                                      decoration: InputDecoration(
                                          hintText: 'Age',
                                          hintStyle: textStyle14Bold(
                                              colorIndigo.withOpacity(0.5)),
                                          border: InputBorder.none),
                                      keyboardType: TextInputType.number,
                                    ))),
                              ),
                              Text(
                                  'We use these to calculate an accurate calorie goal.',
                                  style: textStyle12Medium(
                                      colorIndigo.withOpacity(0.5))),
                              SizedBox(height: deviceHeight(context) * 0.03),
                              Text('Where do you live?',
                                  style: textStyle18Bold(colorIndigo)),
                              SizedBox(height: deviceHeight(context) * 0.015),
                              Text('Country',
                                  style: textStyle14Bold(
                                      colorIndigo.withOpacity(0.4))),
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: deviceHeight(context) * 0.008),
                                  child: editData(Row(
                                    children: [
                                      SizedBox(
                                          width: deviceWidth(context) * 0.04),
                                      DropdownButtonHideUnderline(
                                        child: DropdownButton2(
                                            value: selectedCountry,
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedCountry = newValue!;
                                              });
                                            },
                                            icon: Icon(Icons.arrow_drop_down,
                                                color: colorIndigo,
                                                size: deviceWidth(context) *
                                                    0.09),
                                            alignment: Alignment.centerLeft,
                                            dropdownOverButton: false,
                                            dropdownMaxHeight:
                                                deviceHeight(context) *
                                                    0.065 *
                                                    countries.length,
                                            dropdownWidth:
                                                deviceWidth(context) * 0.7,
                                            dropdownDecoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(7),
                                                border: Border.all(
                                                    color: colorIndigo)),
                                            items: countries
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: SizedBox(
                                                  width: deviceWidth(context) *
                                                      0.7,
                                                  child: Text(value,
                                                      style: textStyle14Medium(
                                                          colorIndigo)),
                                                ),
                                              );
                                            }).toList()),
                                      ),
                                    ],
                                  )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              if (status == 2)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: deviceWidth(context) * 0.04),
                                  child: SizedBox(
                                      height: deviceHeight(context) * 0.17,
                                      width: deviceWidth(context) * 0.35,
                                      child: Image.asset(imgYou3,
                                          fit: BoxFit.fill)),
                                )
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.03),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text('How tall are you?',
                                style: textStyle18Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.018),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth(context) * 0.02),
                                child: heightWeight(
                                    selectedHeight,
                                    () => setHeightWeight(
                                            'Height',
                                            _feetController,
                                            'ft',
                                            _inchController,
                                            'in', () {
                                          if (_feetController.text.isEmpty) {
                                            setState(() {
                                              selectedHeight = 'Height';
                                            });
                                            Navigator.of(context).pop();
                                            ErrorDialog().errorDialog(context,
                                                'Please enter valid Height.');
                                          } else {
                                            if ((_feetController
                                                        .text.isNotEmpty &&
                                                    _inchController
                                                        .text.isEmpty) ||
                                                (_feetController
                                                        .text.isNotEmpty &&
                                                    _inchController
                                                        .text.isNotEmpty)) {
                                              if (int.parse(_feetController
                                                          .text) <
                                                      1 ||
                                                  int.parse(_feetController
                                                          .text) >
                                                      11) {
                                                Navigator.of(context).pop();
                                                ErrorDialog().errorDialog(
                                                    context,
                                                    'Please enter valid height.');
                                              } else {
                                                if (_inchController
                                                        .text.isNotEmpty &&
                                                    (int.parse(_inchController
                                                                .text) <
                                                            1 ||
                                                        int.parse(
                                                                _inchController
                                                                    .text) >
                                                            11)) {
                                                  Navigator.of(context).pop();
                                                  ErrorDialog().errorDialog(
                                                      context,
                                                      'Please enter inch between 0 and 12.');
                                                } else {
                                                  setState(() {
                                                    selectedHeight = _feetController
                                                            .text.isEmpty
                                                        ? 'Height'
                                                        : _inchController
                                                                .text.isNotEmpty
                                                            ? '${_feetController.text} ft ${_inchController.text} in'
                                                            : _feetController
                                                                    .text +
                                                                ' ft';
                                                  });
                                                  Navigator.of(context).pop();
                                                }
                                              }
                                            }
                                          }
                                        }))),
                            SizedBox(height: deviceHeight(context) * 0.04),
                            Text('How much do you weight?',
                                style: textStyle18Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.018),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth(context) * 0.02),
                                child: heightWeight(
                                    selectedWeight,
                                    () => setHeightWeight(
                                            'Weight',
                                            _kiloController,
                                            'Kilo',
                                            _gramController,
                                            'Gram', () {
                                          if (_kiloController.text.isEmpty) {
                                            setState(() {
                                              selectedWeight = 'Weight';
                                            });
                                            Navigator.of(context).pop();
                                            ErrorDialog().errorDialog(context,
                                                'Please enter valid Weight.');
                                          } else {
                                            setState(() {
                                              selectedWeight = _kiloController
                                                      .text.isEmpty
                                                  ? 'Weight'
                                                  : _gramController
                                                          .text.isNotEmpty
                                                      ? '${_kiloController.text} kilo ${_gramController.text} gram'
                                                      : '${_kiloController.text} kg';
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        }))),
                            SizedBox(height: deviceHeight(context) * 0.008),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.07),
                              child: Text(
                                  'It’s ok to estimate, you can update this later.',
                                  style: textStyle12Medium(
                                      colorIndigo.withOpacity(0.5))),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (status == 3)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: deviceHeight(context) * 0.835,
                        width: deviceWidth(context),
                        color: colorWhite,
                      ),
                      Positioned(
                          top: 0,
                          child: SizedBox(
                              height: deviceHeight(context) * 0.24,
                              width: deviceWidth(context),
                              child: Image.asset(imgGoal1, fit: BoxFit.fill))),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth(context) * 0.06),
                          child: Column(
                            children: [
                              SizedBox(height: deviceHeight(context) * 0.03),
                              Text('Goals',
                                  style: textStyle22Bold(colorIndigo)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                          top: deviceHeight(context) * 0.19,
                          child: Column(
                            children: [
                              Text('Let’s start with goals.',
                                  style: textStyle18Bold(colorIndigo)),
                              SizedBox(height: deviceHeight(context) * 0.01),
                              SizedBox(
                                width: deviceWidth(context) * 0.9,
                                child: Text(
                                    'Choose up to 3 that are important to you, including a weight loss goal.',
                                    textAlign: TextAlign.center,
                                    style: textStyle12Light(
                                            colorIndigo.withOpacity(0.7))
                                        .copyWith(height: 1.3)),
                              ),
                            ],
                          )),
                      Positioned(
                          top: deviceHeight(context) * 0.3,
                          left: deviceWidth(context) * 0.05,
                          child: Column(
                              children: List.generate(
                                  goalList.length,
                                  (index) => commonField(
                                          goalList[index],
                                          selectedGoal[index],
                                          deviceHeight(context) * 0.06,
                                          deviceWidth(context) * 0.9,
                                          Alignment.centerLeft, () {
                                        print('--==1----${foundTrue.length}');
                                        if (foundTrue.length < 3) {
                                          setState(() {
                                            selectedGoal[index] =
                                                !selectedGoal[index];
                                          });
                                        } else if (foundTrue.length == 3) {
                                          if (selectedGoal[index] == true) {
                                            setState(() {
                                              selectedGoal[index] =
                                                  !selectedGoal[index];
                                            });
                                          }
                                        }
                                        foundTrue = selectedGoal
                                            .where((e) => e == true);
                                        print('--==2----$foundTrue');
                                        print('----------------$selectedGoal');
                                      })))),
                    ],
                  ),
                ),
              if (status == 4)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Goals',
                                    style: textStyle22Bold(colorIndigo)),
                                SizedBox(
                                    height: deviceHeight(context) * 0.2,
                                    width: deviceWidth(context) * 0.65,
                                    child:
                                        Image.asset(imgGoal2, fit: BoxFit.fill))
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.03),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text('Great!', style: textStyle24Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            SizedBox(
                              width: deviceWidth(context) * 0.9,
                              child: Text(
                                  'You’ve just taken a big step on your journey.',
                                  textAlign: TextAlign.center,
                                  style: textStyle16Bold(colorIndigo)
                                      .copyWith(height: 1.3)),
                            ),
                            SizedBox(height: deviceHeight(context) * 0.04),
                            Container(
                              height: deviceHeight(context) * 0.25,
                              decoration: BoxDecoration(
                                  color: colorWhite,
                                  border: Border.all(
                                      color: colorGrey.withOpacity(0.2),
                                      width: 2),
                                  borderRadius: BorderRadius.circular(5)),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth(context) * 0.035),
                                child: Column(
                                  children: [
                                    SizedBox(
                                        height: deviceHeight(context) * 0.02),
                                    Text(
                                        'Did you know that tracking your food is a scientifically proven method to being successful? it\'s called "self-monitoring" and the more consistent you are, the more likely you are to hit your goals.',
                                        style: textStyle14Light(colorIndigo)
                                            .copyWith(height: 1.3)),
                                    const Spacer(),
                                    Text(
                                        'Now, let’s talk about your goal to gain weight.',
                                        style: textStyle16Bold(colorIndigo)),
                                    SizedBox(
                                        height: deviceHeight(context) * 0.02),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (status == 5)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Goals',
                                    style: textStyle22Bold(colorIndigo)),
                                SizedBox(
                                    height: deviceHeight(context) * 0.17,
                                    width: deviceWidth(context) * 0.5,
                                    child:
                                        Image.asset(imgGoal3, fit: BoxFit.fill))
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.02),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.02),
                            Text('Hello!', style: textStyle24Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            SizedBox(
                              width: deviceWidth(context) * 0.9,
                              child: Text(
                                  'What are your reasons for wanting to gain weight?',
                                  style: textStyle16Bold(colorIndigo)
                                      .copyWith(height: 1.3)),
                            ),
                            SizedBox(height: deviceHeight(context) * 0.015),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Select that apply.',
                                    style: textStyle14Bold(
                                        colorIndigo.withOpacity(0.5))),
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.025),
                            Column(
                                children: List.generate(
                                    goalReason.length,
                                    (index) => commonField(
                                            goalReason[index],
                                            selectedReason[index],
                                            deviceHeight(context) * 0.06,
                                            deviceWidth(context) * 0.9,
                                            Alignment.centerLeft, () {
                                          selectedReason = List.filled(
                                              selectedReason.length, false,
                                              growable: true);
                                          setState(() {
                                            selectedReason[index] =
                                                !selectedReason[index];
                                          });
                                        })))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (status == 6)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Goals',
                                    style: textStyle22Bold(colorIndigo)),
                                SizedBox(
                                    height: deviceHeight(context) * 0.17,
                                    width: deviceWidth(context) * 0.5,
                                    child:
                                        Image.asset(imgGoal4, fit: BoxFit.fill))
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.03),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.01),
                            SizedBox(
                              width: deviceWidth(context) * 0.9,
                              child: Text(
                                  'Dialing in your nutrition is a great way to support your fitness.',
                                  style: textStyle16Bold(colorIndigo)
                                      .copyWith(height: 1.3)),
                            ),
                            SizedBox(height: deviceHeight(context) * 0.025),
                            Column(
                                children: List.generate(
                                    nutritionGoal.length,
                                    (index) => commonField(
                                        nutritionGoal[index],
                                        selectedNutrition[index],
                                        deviceHeight(context) * 0.08,
                                        deviceWidth(context) * 0.9,
                                        Alignment.centerLeft,
                                        () => null)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (status == 7)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Activity Level',
                                    style: textStyle22Bold(colorIndigo)),
                                SizedBox(
                                    height: deviceHeight(context) * 0.17,
                                    width: deviceWidth(context) * 0.45,
                                    child: Image.asset(imgActivityLevel,
                                        fit: BoxFit.fill))
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.03),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text('What is your baseline activity level?',
                                style: textStyle18Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.01),
                            SizedBox(
                              width: deviceWidth(context) * 0.9,
                              child: Text(
                                  'Not including workouts - we count that separately.',
                                  style: textStyle12Medium(
                                          colorIndigo.withOpacity(0.5))
                                      .copyWith(height: 1.3)),
                            ),
                            SizedBox(height: deviceHeight(context) * 0.025),
                            SizedBox(
                              height: deviceHeight(context) * 0.5,
                              child: SingleChildScrollView(
                                child: Column(
                                    children: List.generate(
                                        activityTitles.length,
                                        (index) => activityField(
                                                activityTitles[index],
                                                activitySubTitles[index],
                                                deviceHeight(context) * 0.12,
                                                selectedActivity[index], () {
                                              selectedActivity = List.filled(
                                                  selectedActivity.length,
                                                  false,
                                                  growable: true);
                                              setState(() {
                                                selectedActivity[index] =
                                                    !selectedActivity[index];
                                              });
                                            }))),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              if (status == 8)
                SizedBox(
                  height: deviceHeight(context) - deviceHeight(context) * 0.167,
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(left: deviceWidth(context) * 0.06),
                        child: Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Weekly Goal',
                                    style: textStyle22Bold(colorIndigo)),
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: deviceWidth(context) * 0.04),
                                  child: SizedBox(
                                      height: deviceHeight(context) * 0.17,
                                      width: deviceWidth(context) * 0.35,
                                      child: Image.asset(imgWeeklyGoal,
                                          fit: BoxFit.fill)),
                                )
                              ],
                            ),
                            SizedBox(height: deviceHeight(context) * 0.03),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.01),
                            Text('What\'s your goal weight?',
                                style: textStyle18Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.018),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: deviceWidth(context) * 0.02),
                                child: heightWeight(
                                    goalWeight,
                                    () => setHeightWeight(
                                            'Goal Weight',
                                            _goalKiloController,
                                            'Kilo',
                                            _goalGramController,
                                            'Gram', () {
                                          if (_goalKiloController
                                              .text.isEmpty) {
                                            setState(() {
                                              goalWeight = 'Weight';
                                            });
                                            Navigator.of(context).pop();
                                            ErrorDialog().errorDialog(context,
                                                'Please enter valid Weight.');
                                          } else {
                                            setState(() {
                                              goalWeight = _goalKiloController
                                                      .text.isEmpty
                                                  ? 'Weight'
                                                  : _goalGramController
                                                          .text.isNotEmpty
                                                      ? '${_goalKiloController.text} kilo ${_goalGramController.text} gram'
                                                      : '${_goalKiloController.text} kg';
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        }))),
                            SizedBox(height: deviceHeight(context) * 0.008),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: deviceWidth(context) * 0.07),
                              child: Text(
                                  'Don’t worry. this doesn\'t affect your daily calorie goal and you can always change it later.',
                                  style: textStyle12Medium(
                                      colorIndigo.withOpacity(0.5))),
                            ),
                            SizedBox(height: deviceHeight(context) * 0.04),
                            Text('What is your weekly goal?',
                                style: textStyle18Bold(colorIndigo)),
                            SizedBox(height: deviceHeight(context) * 0.018),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                  weeklyGoal.length,
                                  (index) => commonField(
                                          weeklyGoal[index],
                                          weeklyGoalBool[index],
                                          deviceHeight(context) * 0.06,
                                          deviceWidth(context) * 0.9,
                                          Alignment.centerLeft, () {
                                        weeklyGoalBool = List.filled(
                                            weeklyGoalBool.length, false,
                                            growable: true);
                                        setState(() {
                                          weeklyGoalBool[index] =
                                              !weeklyGoalBool[index];
                                        });
                                      })),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              SizedBox(
                height: deviceHeight(context) * 0.13,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DotsIndicator(
                      dotsCount: 4,
                      position: index.toDouble(),
                      decorator: decorator,
                    ),
                    commonButton('NEXT', () async {
                      if (status == 0) {
                        if (_nameController.text.isEmpty) {
                          ErrorDialog()
                              .errorDialog(context, 'Please enter your name.');
                        } else {
                          userData.name = _nameController.text;
                          listUser.first.name!.isEmpty
                              ? await helper.insertUserData(userData)
                              : await helper.updateUserData(userData);
                          setState(() {
                            status++;
                          });
                          await SharedPreference()
                              .storeIntValue('status', status);
                        }
                      } else if (status == 1) {
                        print('------selectedGoal------------$genderBool');
                        if ((!genderBool.contains(true) &&
                                _ageController.text.isEmpty) ||
                            (!genderBool.contains(true) &&
                                _ageController.text.isNotEmpty)) {
                          ErrorDialog()
                              .errorDialog(context, 'Please select gender.');
                        } else if (genderBool.contains(true) &&
                            _ageController.text.isEmpty) {
                          ErrorDialog().errorDialog(context,
                              'Please enter a valid age between 18 and 100 years old.');
                        } else if (genderBool.contains(true) &&
                            _ageController.text.isNotEmpty) {
                          if (int.parse(_ageController.text) > 17 &&
                              int.parse(_ageController.text) < 100) {
                            userData.gender = gender[
                                genderBool.indexOf(genderBool.contains(true))];
                            userData.age = int.parse(_ageController.text);
                            userData.dateOfBirth = '';
                            userData.country = selectedCountry;
                            await helper.updateUserData(userData);
                            setState(() {
                              status++;
                            });
                            await SharedPreference()
                                .storeIntValue('status', status);
                          } else {
                            ErrorDialog().errorDialog(context,
                                'Please enter a valid age between 18 and 100 years old.');
                          }
                        }
                      } else if (status == 2) {
                        if ((_feetController.text.isEmpty &&
                                _kiloController.text.isEmpty) ||
                            (_feetController.text.isEmpty &&
                                _kiloController.text.isNotEmpty)) {
                          ErrorDialog()
                              .errorDialog(context, 'Please enter height.');
                        } else if (_feetController.text.isNotEmpty &&
                            _kiloController.text.isEmpty) {
                          ErrorDialog()
                              .errorDialog(context, 'Please enter weight.');
                        } else if (_feetController.text.isNotEmpty &&
                            _kiloController.text.isNotEmpty) {
                          userData.height = selectedHeight;
                          userData.weight = selectedWeight;
                          userData.currentWeight = selectedWeight;
                          await helper.updateUserData(userData);
                          setState(() {
                            status++;
                            index++;
                          });
                          await SharedPreference()
                              .storeIntValue('status', status);
                          await SharedPreference()
                              .storeIntValue('index', index);
                        }
                      } else if (status == 3) {
                        print('-----status--$status');
                        if (foundTrue.isNotEmpty) {
                          for (int i = 0; i < selectedGoal.length; i++) {
                            if (selectedGoal[i] == true) {
                              goals.add(goalList[i]);
                              await helper
                                  .insertGoals(Goals(goal: goalList[i]));
                            }
                          }
                          print('----goalList---------$goals');
                          SharedPreference().storeListValue('goalList', goals);
                          setState(() {
                            status++;
                          });
                          await SharedPreference()
                              .storeIntValue('status', status);
                        } else {
                          ErrorDialog().errorDialog(context,
                              'Please select at least one response to continue.');
                        }
                      } else if (status == 4) {
                        setState(() {
                          status++;
                        });
                        await SharedPreference()
                            .storeIntValue('status', status);
                      } else if (status == 5) {
                        if (selectedReason.contains(true)) {
                          userData.goalReason = goalReason[selectedReason
                              .indexOf(selectedReason.contains(true))];
                          await helper.updateUserData(userData);
                          setState(() {
                            status++;
                          });
                          await SharedPreference()
                              .storeIntValue('status', status);
                        } else {
                          ErrorDialog().errorDialog(context,
                              'Please select at least one response to continue.');
                        }
                      } else if (status == 6) {
                        setState(() {
                          status++;
                          index++;
                        });
                        await SharedPreference()
                            .storeIntValue('status', status);
                        await SharedPreference().storeIntValue('index', index);
                      } else if (status == 7) {
                        if (selectedActivity.contains(true)) {
                          userData.activityLevel = activityTitles[
                              selectedActivity
                                  .indexOf(selectedActivity.contains(true))];
                          await helper.updateUserData(userData);
                          setState(() {
                            status++;
                            index++;
                          });
                          await SharedPreference()
                              .storeIntValue('status', status);
                          await SharedPreference()
                              .storeIntValue('index', index);
                        } else {
                          ErrorDialog().errorDialog(
                              context, 'Please select an activity level.');
                        }
                      } else if (status == 8) {
                        print(
                            '------weeklyGoalBool------------$weeklyGoalBool');
                        if ((_goalKiloController.text.isEmpty &&
                                !weeklyGoalBool.contains(true)) ||
                            (_goalKiloController.text.isEmpty &&
                                weeklyGoalBool.contains(true))) {
                          ErrorDialog().errorDialog(
                              context, 'Please set your goal Weight.');
                        } else if (_goalKiloController.text.isNotEmpty &&
                            !weeklyGoalBool.contains(true)) {
                          ErrorDialog().errorDialog(
                              context, 'Please select your weekly goal.');
                        } else if (weeklyGoalBool.contains(true) &&
                            _goalKiloController.text.isNotEmpty) {
                          userData.goalWeight = goalWeight;
                          userData.weeklyGoal = weeklyGoal[weeklyGoalBool
                              .indexOf(weeklyGoalBool.contains(true))];
                          userData.startDate = DateTime.now().toString();
                          userData.caloriesGoal = '2000';
                          userData.percentageCarbohydrates = 50;
                          double carbVal = ((int.parse(userData.caloriesGoal!) *
                                      userData.percentageCarbohydrates!) /
                                  100) /
                              4;
                          print('----carbVal------$carbVal');
                          userData.carbohydrates = int.parse(carbVal
                                      .toStringAsFixed(2)
                                      .split('.')[1]) >
                                  0
                              ? carbVal.toStringAsFixed(2)
                              : carbVal.floor().toString();
                          userData.percentageProtein = 20;
                          double proteinVal =
                              ((int.parse(userData.caloriesGoal!) *
                                          userData.percentageProtein!) /
                                      100) /
                                  4;
                          print('----proteinVal------$proteinVal');
                          userData.protein = int.parse(proteinVal
                                      .toStringAsFixed(2)
                                      .split('.')[1]) >
                                  0
                              ? proteinVal.toStringAsFixed(2)
                              : proteinVal.floor().toString();
                          userData.percentageFat = 30;
                          double fatVal = ((int.parse(userData.caloriesGoal!) *
                                      userData.percentageFat!) /
                                  100) /
                              9;
                          print('----fatVal------$fatVal');
                          userData.fat = int.parse(
                                      fatVal.toStringAsFixed(2).split('.')[1]) >
                                  0
                              ? fatVal.toStringAsFixed(2)
                              : fatVal.floor().toString();
                          userData.satFat =
                              (((int.parse(userData.caloriesGoal!) * 10) /
                                          100) /
                                      9)
                                  .floor()
                                  .toString();
                          userData.cholesterol = '300';
                          userData.potassium = '3500';
                          userData.fiber =
                              ((int.parse(userData.caloriesGoal!) * 14) / 1000)
                                  .floor()
                                  .toString();
                          userData.sodium = '2300';
                          userData.sugars =
                              (((int.parse(userData.caloriesGoal!) * 10) /
                                          100) /
                                      4)
                                  .floor()
                                  .toString();
                          userData.vitaminA = '100';
                          userData.vitaminC = '100';
                          userData.calcium = '100';
                          userData.iron = '100';
                          await helper.updateUserData(userData);
                          SharedPreference()
                              .storeBoolValue('isBackup', isBackup);
                          Navigator.of(context).pushReplacementNamed(
                              HomeScreen.route,
                              arguments: HomeScreenData(
                                  index: 1,
                                  date: DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day)));
                        }
                      }
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: color, width: 1) : null);
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: onClick,
      child: Text(title, style: textStyle16Medium(colorIndigo)),
    ));
  }

  commonField(String title, bool isSelect, double height, double width,
      AlignmentGeometry alignment, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.008),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              color: colorWhite,
              border: Border.all(
                  color: isSelect
                      ? colorIndigo.withOpacity(0.8)
                      : colorGrey.withOpacity(0.2),
                  width: 2),
              borderRadius: BorderRadius.circular(5)),
          alignment: alignment,
          child: Padding(
            padding: width == deviceWidth(context) * 0.3
                ? EdgeInsets.zero
                : EdgeInsets.only(left: deviceWidth(context) * 0.04),
            child: Text(title,
                style: isSelect
                    ? textStyle14Bold(colorIndigo).copyWith(height: 1.3)
                    : textStyle14Medium(colorIndigo.withOpacity(0.6))
                        .copyWith(height: 1.3)),
          ),
        ),
      ),
    );
  }

  commonButton(String title, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.065,
        width: deviceWidth(context) * 0.6,
        decoration: BoxDecoration(
            color: colorIndigo,
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(45), right: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                  color: colorIndigo.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(2, 2)),
            ]),
        alignment: Alignment.center,
        child: Text(title, style: textStyle20Bold(colorWhite)),
      ),
    );
  }

  activityField(String title, String subtitle, double height, bool isSelect,
      Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.008),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: height,
          width: deviceWidth(context) * 0.9,
          decoration: BoxDecoration(
              color: colorWhite,
              border: Border.all(
                  color: isSelect
                      ? colorIndigo.withOpacity(0.8)
                      : colorGrey.withOpacity(0.2),
                  width: 2),
              borderRadius: BorderRadius.circular(5)),
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: deviceWidth(context) * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(title, style: textStyle16Bold(colorIndigo)),
                Text(subtitle,
                    style: textStyle12Medium(colorIndigo.withOpacity(0.5))
                        .copyWith(height: 1.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  editData(Widget widget) {
    return Container(
      height: deviceHeight(context) * 0.06,
      width: deviceWidth(context) * 0.9,
      decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: colorGrey.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(5)),
      alignment: Alignment.centerLeft,
      child: widget,
    );
  }

  heightWeight(String title, Function() onClick) {
    return GestureDetector(
        onTap: onClick,
        child: editData(Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.04),
            Text(title, style: textStyle14Medium(colorIndigo.withOpacity(0.6))),
            const Spacer(),
            Icon(Icons.arrow_drop_down,
                color: colorIndigo, size: deviceWidth(context) * 0.09),
            SizedBox(width: deviceWidth(context) * 0.04),
          ],
        )));
  }

  enterDataField(TextEditingController controller, String title) {
    return Container(
      height: deviceHeight(context) * 0.06,
      width: deviceWidth(context) * 0.3,
      decoration: decoration(colorIndigo, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceHeight(context) * 0.04,
            width: deviceWidth(context) * 0.1,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
              inputFormatters: [
                LengthLimitingTextInputFormatter(3),
              ],
              decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: textStyle16Bold(colorIndigo.withOpacity(0.6)),
                  border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: colorIndigo, width: 1))),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(title, style: textStyle16Bold(colorIndigo)),
        ],
      ),
    );
  }

  Widget cancelSave(String text, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Expanded(
        child: Container(
          height: deviceHeight(context) * 0.07,
          width: ((deviceWidth(context) * 0.78) / 2) -
              deviceWidth(context) * 0.0025,
          decoration: BoxDecoration(
              color: colorIndigo.withOpacity(0.2),
              borderRadius: text == 'SAVE'
                  ? const BorderRadius.only(bottomRight: Radius.circular(20))
                  : const BorderRadius.only(bottomLeft: Radius.circular(20))),
          alignment: Alignment.center,
          child: Text(text,
              style:
                  textStyle16Bold(text == 'SAVE' ? colorIndigo : colorWhite)),
        ),
      ),
    );
  }
}
