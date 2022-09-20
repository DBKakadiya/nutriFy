import 'package:flutter/material.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';

class UpdateExerciseData {
  final String type;
  final dynamic exerciseData;

  UpdateExerciseData({required this.type, required this.exerciseData});
}

class UpdateExerciseScreen extends StatefulWidget {
  final UpdateExerciseData modelData;
  static const route = '/Update-Exercise';

  const UpdateExerciseScreen({required this.modelData});

  @override
  State<UpdateExerciseScreen> createState() => _UpdateExerciseScreenState();
}

class _UpdateExerciseScreenState extends State<UpdateExerciseScreen> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _minutesController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _hashOfSetController = TextEditingController();
  final TextEditingController _repetitionSetController =
      TextEditingController();
  final TextEditingController _weightPerRepetitionController =
      TextEditingController();

  @override
  void initState() {
    if (widget.modelData.type == 'Cardio') {
      _minutesController.text = widget.modelData.exerciseData.time!;
      _minutesController.selection = TextSelection.fromPosition(
          TextPosition(offset: _minutesController.text.length));
      _calorieController.text = widget.modelData.exerciseData.calorie!;
    } else if (widget.modelData.type == 'Strength') {
      _hashOfSetController.text = widget.modelData.exerciseData.hashOfSet!;
      _hashOfSetController.selection = TextSelection.fromPosition(
          TextPosition(offset: _hashOfSetController.text.length));
      _repetitionSetController.text =
          widget.modelData.exerciseData.repetitionSet!;
      _weightPerRepetitionController.text =
          widget.modelData.exerciseData.weightPerRepetition!;
      _minutesController.text = widget.modelData.exerciseData.time!;
      _calorieController.text = widget.modelData.exerciseData.calorie!;
    }
    super.initState();
  }

  void updateCardioData() {
    if ((_minutesController.text.isEmpty && _calorieController.text.isEmpty) ||
        (_minutesController.text.isEmpty &&
            _calorieController.text.isNotEmpty)) {
      ErrorDialog().errorDialog(
          context, 'Please enter the number of minutes you spent exercising.');
    } else if (_minutesController.text.isNotEmpty &&
        _calorieController.text.isEmpty) {
      ErrorDialog()
          .errorDialog(context, 'Please enter valid number of calories.');
    } else {
      setState(() {
        widget.modelData.exerciseData.time = _minutesController.text;
        widget.modelData.exerciseData.calorie = _calorieController.text;
      });
      helper.updateCardioExerciseData(widget.modelData.exerciseData);
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route, (route) => false,
          arguments: HomeScreenData(
              index: 2,
              date: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)));
    }
  }

  void updateStrengthData() {
    if ((_hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isNotEmpty &&
            _calorieController.text.isNotEmpty) ||
        (_hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isNotEmpty) ||
        (_hashOfSetController.text.isEmpty &&
            _repetitionSetController.text.isNotEmpty &&
            _calorieController.text.isEmpty)) {
      ErrorDialog().errorDialog(context,
          'Please enter the number of sets performed before adding this exercise.');
    } else if ((_hashOfSetController.text.isNotEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isEmpty) ||
        (_hashOfSetController.text.isNotEmpty &&
            _repetitionSetController.text.isEmpty &&
            _calorieController.text.isNotEmpty)) {
      ErrorDialog().errorDialog(context,
          'Please enter the number of repetitions before adding this exercise.');
    } else if ((_hashOfSetController.text.isNotEmpty &&
        _repetitionSetController.text.isNotEmpty &&
        _calorieController.text.isEmpty)) {
      ErrorDialog()
          .errorDialog(context, 'Please enter valid number of calories.');
    } else {
      setState(() {
        widget.modelData.exerciseData.hashOfSet = _hashOfSetController.text;
        widget.modelData.exerciseData.repetitionSet =
            _repetitionSetController.text;
        widget.modelData.exerciseData.weightPerRepetition =
            _weightPerRepetitionController.text;
        widget.modelData.exerciseData.time = _minutesController.text;
        widget.modelData.exerciseData.calorie = _calorieController.text;
      });
      helper.updateStrengthExerciseData(widget.modelData.exerciseData);
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomeScreen.route, (route) => false,
          arguments: HomeScreenData(
              index: 2,
              date: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day)));
    }
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
    title: Text(widget.modelData.exerciseData.description!,
        overflow: TextOverflow.ellipsis,
        style: textStyle20Bold(colorIndigo)),
    actions: [
      Padding(
        padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
        child: IconButton(
            onPressed: widget.modelData.type == 'Cardio'
                ? updateCardioData
                : updateStrengthData,
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
          if (widget.modelData.type == 'Cardio')
            Column(
              children: [
                exerciseField('Minutes performed', _minutesController,
                    (val) {
                  if (val.isEmpty) {
                    _calorieController.text = '0';
                  }
                }),
                exerciseField('Calories Burned', _calorieController)
              ],
            ),
          if (widget.modelData.type == 'Strength')
            Column(
              children: [
                exerciseField('# of Sets', _hashOfSetController, (val) {
                  if (val.isEmpty) {
                    _calorieController.text = '0';
                  }
                }),
                exerciseField('Repetitions/Set', _repetitionSetController),
                exerciseField('Weight per Repetition',
                    _weightPerRepetitionController),
                exerciseField('Minutes performed', _minutesController,
                        (val) {
                      if (val.isEmpty) {
                        _calorieController.text = '0';
                      }
                    }),
                exerciseField('Calories Burned', _calorieController),
              ],
            )
        ],
      ),
    ),
      ),
    );
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

  exerciseField(String title, TextEditingController controller,
      [Function(String)? onChanged]) {
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
            textField(controller, onChanged),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }

  textField(TextEditingController controller, Function(String)? onChanged) {
    return Container(
      height: deviceHeight(context) * 0.065,
      width: deviceWidth(context) * 0.17,
      alignment: Alignment.centerRight,
      child: TextFormField(
        controller: controller,
        autofocus: controller == _minutesController ||
                controller == _hashOfSetController
            ? true
            : false,
        style: textStyle14Bold(colorIndigo),
        cursorColor: colorIndigo,
        textAlign: TextAlign.right,
        onChanged: onChanged,
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
