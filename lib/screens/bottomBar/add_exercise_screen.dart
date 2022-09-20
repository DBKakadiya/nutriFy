import 'package:flutter/material.dart';
import 'package:nutrime/models/cardio_exercise_data.dart';
import 'package:nutrime/models/strength_exercise_data.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:nutrime/widgets/error_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';

class AddExerciseData {
  final String exerciseType;
  final String selDate;

  AddExerciseData({required this.exerciseType,required this.selDate});
}

class AddExerciseScreen extends StatefulWidget {
  final AddExerciseData data;
  static const route = '/Add-Exercise';

  const AddExerciseScreen({required this.data});

  @override
  State<AddExerciseScreen> createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _hashOfSetController = TextEditingController();
  final TextEditingController _repetitionSetController =
      TextEditingController();
  final TextEditingController _weightPerRepetitionController =
      TextEditingController();
  CardioData cardioData =
      CardioData(id: 0, date: '', description: '', time: '', calorie: '');
  StrengthData strengthData = StrengthData(
      id: 0,
      date: '',
      description: '',
      hashOfSet: '',
      repetitionSet: '',
      weightPerRepetition: '',
      time: '',
      calorie: '');

  void getCardioData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<CardioData>?> userDataList = helper.getCardioExerciseList();
      userDataList.then((data) {
        print('--------data-----$data');
        if (data!.isEmpty) {
          setState(() {
            cardioData.id = 1;
          });
        } else {
          setState(() {
            cardioData.id = data.last.id! + 1;
          });
        }
      });
    });
  }

  void getStrengthData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<StrengthData>?> userDataList =
          helper.getStrengthExerciseList();
      userDataList.then((data) {
        print('--------data-----$data');
        if (data!.isEmpty) {
          setState(() {
            strengthData.id = 1;
          });
        } else {
          setState(() {
            strengthData.id = data.last.id! + 1;
          });
        }
      });
    });
  }

  @override
  void initState() {
    print('---selDate----${widget.data.selDate}');
    getCardioData();
    getStrengthData();
    super.initState();
  }

  void cardioDataSave() {
    if (_exerciseController.text.isEmpty) {
      ErrorDialog().errorDialog(context, 'Please enter the description for this exercise.');
    } else if ((_exerciseController.text.isNotEmpty &&
            _minutesController.text.isEmpty &&
            _calorieController.text.isEmpty) ||
        (_exerciseController.text.isNotEmpty &&
            _minutesController.text.isEmpty &&
            _calorieController.text.isNotEmpty)) {
      ErrorDialog().errorDialog(context, 'Please enter the number of minutes you spent exercising.');
    } else if (_exerciseController.text.isNotEmpty &&
        _minutesController.text.isNotEmpty &&
        _calorieController.text.isEmpty) {
      ErrorDialog().errorDialog(context, 'Please enter valid number of calories.');
    } else {
      setState(() {
        cardioData.date = widget.data.selDate;
        cardioData.description = _exerciseController.text;
        cardioData.time = _minutesController.text;
        cardioData.calorie = _calorieController.text;
      });
      helper.insertCardioExercise(cardioData);
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route, (route) => false,
          arguments: HomeScreenData(
              index: 2,
              date: DateTime.parse(widget.data.selDate)));
    }
  }

  void strengthDataSave() {
    if (_exerciseController.text.isEmpty) {
      ErrorDialog().errorDialog(context, 'Please enter the description for this exercise.');
    } else if ((_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isEmpty) ||
        (_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isNotEmpty) ||
        (_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isNotEmpty &&
            _calorieController.text.isNotEmpty) ||
        (_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isNotEmpty &&
            _calorieController.text.isEmpty)) {
      ErrorDialog().errorDialog(context,
          'Please enter the number of sets performed before adding this exercise.');
    } else if ((_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isNotEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isEmpty) ||
        (_exerciseController.text.isNotEmpty &&
            _hashOfSetController.text.isNotEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isNotEmpty)) {
      ErrorDialog().errorDialog(context,
          'Please enter the number of repetitions before adding this exercise.');
    } else if (_exerciseController.text.isNotEmpty &&
        _hashOfSetController.text.isNotEmpty &&
        _repetitionSetController.text.isNotEmpty &&
        _calorieController.text.isEmpty) {
      ErrorDialog().errorDialog(context, 'Please enter valid number of calories.');
    } else {
      setState(() {
        strengthData.date =  widget.data.selDate;
        strengthData.description = _exerciseController.text;
        strengthData.hashOfSet = _hashOfSetController.text;
        strengthData.repetitionSet = _repetitionSetController.text;
        strengthData.weightPerRepetition =
            _weightPerRepetitionController.text.isEmpty
                ? ''
                : _weightPerRepetitionController.text;
        strengthData.time = _minutesController.text;
        strengthData.calorie = _calorieController.text;
      });
      helper.insertStrengthExercise(strengthData);
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route, (route) => false,
          arguments: HomeScreenData(
              index: 2,
              date: DateTime.parse(widget.data.selDate)));
    }
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
        leading: buttons(icBack, () => Navigator.of(context).pop()),
        title: Text('New Exercise', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: widget.data.exerciseType == 'Cardio'
                    ? cardioDataSave
                    : strengthDataSave,
                icon: Image.asset(icSaveWeight,
                    width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
          child: Column(
            children: [
              SizedBox(height: deviceHeight(context) * 0.04),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: deviceHeight(context) * 0.015),
                child: Container(
                  height: deviceHeight(context) * 0.065,
                  decoration: decoration(4),
                  child: Padding(
                    padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
                    child: SizedBox(
                      height: deviceHeight(context) * 0.065,
                      width: deviceWidth(context),
                      child: TextFormField(
                        controller: _exerciseController,
                        autofocus: true,
                        style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
                        cursorColor: colorIndigo,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: textStyle14Bold(colorGrey),
                            border: InputBorder.none),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                ),
              ),
              if (widget.data.exerciseType == 'Cardio')
                Column(
                  children: [
                    exerciseField('How long (minutes)?', _minutesController),
                    exerciseField('Calories Burned', _calorieController)
                  ],
                ),
              if (widget.data.exerciseType == 'Strength')
                Column(
                  children: [
                    exerciseField('# of Sets', _hashOfSetController),
                    exerciseField('Repetitions/Set', _repetitionSetController),
                    exerciseField('Weight per Repetition',
                        _weightPerRepetitionController),
                    exerciseField('How long (minutes)?', _minutesController),
                    exerciseField('Calories Burned', _calorieController),
                  ],
                )
            ],
          ),
        ),
      ),
    ));
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: radius == 4 ? colorBG : colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: colorIndigo, width: 1) : null,
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
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  exerciseField(String title, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.015),
      child: Container(
        height: deviceHeight(context) * 0.065,
        decoration: decoration(4.1),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(title, style: textStyle16Bold(colorIndigo)),
            const Spacer(),
            textField(controller),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }

  textField(TextEditingController controller) {
    return Container(
      height: deviceHeight(context) * 0.065,
      width: deviceWidth(context) * 0.17,
      alignment: Alignment.centerRight,
      child: TextFormField(
        controller: controller,
        style: textStyle14Bold(colorIndigo),
        cursorColor: colorIndigo,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
            hintText: controller == _weightPerRepetitionController
                ? 'Optional'
                : 'Required',
            hintStyle: textStyle14Bold(colorGrey.withOpacity(0.7)),
            border: InputBorder.none),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
