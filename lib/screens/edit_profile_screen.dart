import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/blocs/profile/profile_bloc.dart';
import 'package:nutrime/screens/users/goal_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../blocs/profile/profile_event.dart';
import '../blocs/profile/profile_state.dart';
import '../handler/handler.dart';
import '../models/user_data.dart';
import '../resources/resource.dart';
import '../widgets/error_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  static const route = '/Edit-Profile';

  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _feetController = TextEditingController();
  final TextEditingController _inchController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();
  String? selectedGender;
  String? selectedCountry;
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

  void getUserData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<UserData>?> userDataList = helper.getUserDataList();
      userDataList.then((data) {
        print('--------data-----$data');
        setState(() {
          userData = data!.first;
          _nameController.text = userData.name!;
          selectedGender = userData.gender;
          print('-----birth----------${userData.dateOfBirth}');
          if (userData.dateOfBirth!.isEmpty) {
            print('----------isBirthEmpty');
            userData.dateOfBirth =
                '${DateTime.now().year - userData.age!}-09-09';
          }
          _feetController.text = userData.height!.split(' ')[0];
          _inchController.text = userData.height!.split(' ')[2];
          selectedCountry = userData.country;
        });
      });
    });
  }

  editName(Function() onCancel, Function() onSave) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setStateForDialog) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: deviceHeight(context) * 0.25,
                        width: deviceWidth(context) * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: deviceHeight(context) * 0.03),
                              child: Text('Edit your name',
                                  style: textStyle16Bold(colorIndigo)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) * 0.05),
                              child: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Your Name or Skip';
                                      } else if (value.length < 2) {
                                        return 'Enter at least 2 character or Skip';
                                      } else if (!RegExp("^[a-zA-Z]")
                                          .hasMatch(value)) {
                                        return 'Enter name Not a Number or Skip';
                                      } else {
                                        return null;
                                      }
                                    },
                                    style: textStyle16Bold(
                                        colorIndigo.withOpacity(0.6)),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: colorWhite,
                                      hintText: 'First Name',
                                      hintStyle: textStyle16Bold(
                                          colorIndigo.withOpacity(0.4)),
                                      focusedBorder: OutlineInputBorder(
                                          gapPadding: 0,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                              color:
                                                  colorIndigo.withOpacity(0.7),
                                              width: 1.5)),
                                      enabledBorder: OutlineInputBorder(
                                          gapPadding: 0,
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          borderSide: BorderSide(
                                              color:
                                                  colorGrey.withOpacity(0.25),
                                              width: 1.5)),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                deviceWidth(context) * 0.045),
                                        child: Image.asset(icUserId),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                          maxWidth:
                                              deviceWidth(context) * 0.14),
                                    ),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', onCancel),
                                Container(
                                  height: deviceHeight(context) * 0.07,
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', onSave)
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
        });
  }

  updateGender() {
    showGeneralDialog(
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
                        height: deviceHeight(context) * 0.3,
                        width: deviceWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(top: deviceHeight(context) * 0.03),
                              child:
                              Text('Gender', style: textStyle16Bold(colorIndigo)),
                            ),
                            Column(
                              children: List.generate(
                                  gender.length,
                                      (index) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = gender[index];
                                          });
                                        },
                                        child: Container(
                                          height: deviceHeight(context) * 0.055,
                                          width: deviceWidth(context) * 0.7,
                                          decoration: BoxDecoration(
                                              color: colorWhite,
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                  colorGrey.withOpacity(0.25),
                                                  width: 1.5)),
                                          // alignment: Alignment.centerLeft,
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                  width:
                                                  deviceWidth(context) * 0.02),
                                              SizedBox(
                                                height:
                                                deviceHeight(context) * 0.045,
                                                width: deviceWidth(context) * 0.09,
                                                child: FittedBox(
                                                  child: Radio(
                                                    value: gender[index],
                                                    groupValue: selectedGender,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        selectedGender =
                                                        gender[index];
                                                      });
                                                    },
                                                    fillColor:
                                                    MaterialStateProperty.all(
                                                        colorIndigo),
                                                    activeColor: colorIndigo,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: deviceWidth(context) * 0.55,
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  gender[index],
                                                  style:
                                                  textStyle13Medium(colorBlack),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (index == 0)
                                        SizedBox(
                                            height: deviceHeight(context) * 0.02)
                                    ],
                                  )),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', () {
                                  selectedGender = userData.gender!;
                                  Navigator.of(context).pop();
                                }),
                                Container(
                                  height: deviceHeight(context) * 0.07,
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', () async {
                                  userData.gender = selectedGender;
                                  BlocProvider.of<ProfileBloc>(context)
                                      .add(GetGenderEvent(gender: userData.gender!));
                                  await helper.updateUserData(userData);
                                  Navigator.of(context).pop();
                                })
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

  birthDatePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.parse(DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(userData.dateOfBirth!))),
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: colorIndigo,
                  onPrimary: colorWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    textStyle: textStyle14Bold(colorIndigo),
                    // primary: colorRed, // button text color
                  ),
                ),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print('-------pickedDate---$pickedDate');
      setState(() {
        userData.dateOfBirth = DateFormat('yyyy-MM-dd').format(pickedDate);
        userData.age = DateTime.now().year - pickedDate.year;
        helper.updateUserData(userData);
      });
    });
  }

  updateHeight(Function() onCancel, Function() onSave) {
    showGeneralDialog(
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
                        width: deviceWidth(context) * 0.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(top: deviceHeight(context) * 0.025),
                              child:
                              Text('Height', style: textStyle20Bold(colorIndigo)),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: deviceWidth(context) * 0.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  enterDataField(_feetController, 'ft'),
                                  Container(
                                    height: deviceHeight(context) * 0.07,
                                    width: deviceWidth(context) * 0.005,
                                    color: colorWhite,
                                  ),
                                  enterDataField(_inchController, 'in'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                cancelSave('CANCEL', onCancel),
                                cancelSave('SAVE', onSave),
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

  updateCountry() {
    showGeneralDialog(
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
                        height: deviceHeight(context) * 0.7,
                        width: deviceWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                              EdgeInsets.only(top: deviceHeight(context) * 0.03),
                              child:
                              Text('Location', style: textStyle16Bold(colorIndigo)),
                            ),
                            SizedBox(
                                height: deviceHeight(context) * 0.55,
                                child: ListView.builder(
                                    itemCount: countries.length,
                                    itemBuilder: (context, index) => Column(
                                      children: [
                                        if (index == 0)
                                          SizedBox(
                                              height: deviceHeight(context) * 0.01),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedCountry = countries[index];
                                            });
                                          },
                                          child: Container(
                                            height: deviceHeight(context) * 0.055,
                                            width: deviceWidth(context) * 0.7,
                                            decoration: BoxDecoration(
                                                color: colorWhite,
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                border: Border.all(
                                                    color:
                                                    colorGrey.withOpacity(0.25),
                                                    width: 1.5)),
                                            // alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                    width: deviceWidth(context) *
                                                        0.02),
                                                SizedBox(
                                                  height:
                                                  deviceHeight(context) * 0.045,
                                                  width:
                                                  deviceWidth(context) * 0.09,
                                                  child: FittedBox(
                                                    child: Radio(
                                                      value: countries[index],
                                                      groupValue: selectedCountry,
                                                      onChanged: (val) {
                                                        setState(() {
                                                          selectedCountry =
                                                          countries[index];
                                                        });
                                                      },
                                                      fillColor:
                                                      MaterialStateProperty.all(
                                                          colorIndigo),
                                                      activeColor: colorIndigo,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width:
                                                  deviceWidth(context) * 0.55,
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    countries[index],
                                                    style: textStyle13Medium(
                                                        colorBlack),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (index != countries.length - 1)
                                          SizedBox(
                                              height: deviceHeight(context) * 0.02)
                                      ],
                                    ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                cancelSave('CANCEL', () {
                                  selectedCountry = userData.gender!;
                                  Navigator.of(context).pop();
                                }),
                                Container(
                                  height: deviceHeight(context) * 0.07,
                                  width: deviceWidth(context) * 0.005,
                                  color: colorWhite,
                                ),
                                cancelSave('SAVE', () async {
                                  userData.country = selectedCountry;
                                  BlocProvider.of<ProfileBloc>(context).add(
                                      GetLocationEvent(location: userData.country!));
                                  await helper.updateUserData(userData);
                                  Navigator.of(context).pop();
                                })
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
        });
  }

  @override
  void initState() {
    getUserData();
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
        title: Text('Edit Profile', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _nameController.text = userData.name!;
            });
          },
          child: SizedBox(
            height: deviceHeight(context) * 0.853,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
              child: Column(
                children: [
                  SizedBox(height: deviceHeight(context) * 0.02),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return profilesButton(
                          'User Name',
                          userData.name!,
                          () => editName(() {
                                setState(() {
                                  _nameController.text = userData.name!;
                                });
                                Navigator.of(context).pop();
                              }, () async {
                                setState(() {
                                  userData.name = _nameController.text;
                                });
                                await helper.updateUserData(userData);
                                Navigator.of(context).pop();
                              }));
                    },
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return profilesButton(
                          'Gender',
                          state is GetGenderData
                              ? state.gender
                              : userData.gender!,
                          updateGender);
                    },
                  ),
                  profilesButton(
                      'Date of Birth',
                      DateFormat('MMM dd, yyyy')
                          .format(DateTime.parse(userData.dateOfBirth!)),
                      birthDatePicker),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return profilesButton(
                          'Height',
                          userData.height!,
                          () => updateHeight(() {
                                setState(() {
                                  _feetController.text =
                                      userData.height!.split(' ')[0];
                                });
                                Navigator.of(context).pop();
                              }, () async {
                                if (_feetController.text.isEmpty) {
                                  ErrorDialog().errorDialog(
                                      context, 'Please enter Height');
                                } else {
                                  setState(() {
                                    userData.height = _feetController
                                            .text.isEmpty
                                        ? 'Height'
                                        : _inchController.text.isNotEmpty
                                            ? '${_feetController.text} ft ${_inchController.text} in'
                                            : _feetController.text + ' ft';
                                  });
                                  await helper.updateUserData(userData);
                                  Navigator.of(context).pop();
                                }
                              }));
                    },
                  ),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, state) {
                      return profilesButton(
                          'Location',
                          state is GetLocationData
                              ? state.location
                              : userData.country!,
                          updateCountry);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: deviceHeight(context) * 0.012),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(GoalsScreen.route);
                      },
                      child: Container(
                        height: deviceHeight(context) * 0.09,
                        width: deviceWidth(context),
                        decoration: decoration(6),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: deviceWidth(context) * 0.03),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Goals', style: textStyle16Bold(colorBlack)),
                              Text(
                                  'Update your weight, nutrition and fitness goals',
                                  style: textStyle13(colorGrey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: deviceHeight(context) * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorIndigo, width: 1) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: colorIndigo.withOpacity(0.15),
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

  profilesButton(String title, String val, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.01),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.065,
          decoration: decoration(6),
          child: Row(
            children: [
              SizedBox(width: deviceWidth(context) * 0.03),
              Text(title, style: textStyle14Medium(colorBlack)),
              const Spacer(),
              Text(val, style: textStyle16Medium(Colors.blue.shade800)),
              SizedBox(width: deviceWidth(context) * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: onClick,
      child: Text(title, style: textStyle16Medium(colorIndigo)),
    ));
  }

  Widget cancelSave(String text, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.07,
        width:
            ((deviceWidth(context) * 0.8) / 2) - deviceWidth(context) * 0.005,
        decoration: BoxDecoration(
            color: colorIndigo.withOpacity(0.2),
            borderRadius: text == 'SAVE'
                ? const BorderRadius.only(bottomRight: Radius.circular(20))
                : const BorderRadius.only(bottomLeft: Radius.circular(20))),
        alignment: Alignment.center,
        child: Text(text,
            style: textStyle16Bold(text == 'SAVE' ? colorIndigo : colorWhite)),
      ),
    );
  }

  enterDataField(TextEditingController controller, String title) {
    return Container(
      height: deviceHeight(context) * 0.06,
      width: deviceWidth(context) * 0.3,
      decoration: decoration(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: deviceHeight(context) * 0.04,
            width: deviceWidth(context) * 0.1,
            child: TextFormField(
              controller: controller,
              style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
              cursorColor: colorIndigo,
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
}
