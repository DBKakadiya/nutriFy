import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrime/models/food_data.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';

class CreateFoodData {
  final String action;
  final FoodData foodData;

  CreateFoodData({required this.action, required this.foodData});
}

class CreateFood extends StatefulWidget {
  static const route = '/Create-Food';

  final CreateFoodData data;

  const CreateFood({required this.data});

  @override
  State<CreateFood> createState() => _CreateFoodState();
}

class _CreateFoodState extends State<CreateFood> {
  DatabaseHelper helper = DatabaseHelper();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _servingSizeController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _servingContainerController =
      TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _satFatController = TextEditingController();
  final TextEditingController _sodiumController = TextEditingController();
  final TextEditingController _cholesterolController = TextEditingController();
  final TextEditingController _carbohydratesController =
  TextEditingController();
  final TextEditingController _potassiumController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fiberController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();
  final TextEditingController _vitaminAController = TextEditingController();
  final TextEditingController _vitaminCController = TextEditingController();
  final TextEditingController _calciumController = TextEditingController();
  final TextEditingController _ironController = TextEditingController();
  String? time;

  void _presentTimePicker() {
    showTimePicker(
            context: context,
            initialTime: time == null
                ? TimeOfDay.now()
                : TimeOfDay(
                    hour: int.parse(time!.split(":")[0]),
                    minute: int.parse(time!.split(":")[1].split(' ')[0])))
        .then((pickedTime) {
      if (pickedTime == null) {
        return;
      }
      setState(() {
        time =
            '${pickedTime.hour > 12 ? pickedTime.hour - 12 : pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.name}';
      });
    });
  }

  void getFoodData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<FoodData>?> mealDataList = helper.getFoodList();
      mealDataList.then((data) {
        print('--------data-----$data');
        if (widget.data.action == 'Add') {
          if (data!.isEmpty) {
            setState(() {
              widget.data.foodData.id = 1;
            });
          } else {
            setState(() {
              widget.data.foodData.id = data.last.id! + 1;
            });
          }
          print('--------id-----${widget.data.foodData.toString()}');
        } else {
          for (var ele in data!) {
            if (ele.id == widget.data.foodData.id) {
              print('--meal----${ele.toString()}');
              setState(() {
                widget.data.foodData.id = ele.id!;
                _brandNameController.text = ele.brandName!;
                _brandNameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _brandNameController.text.length));
                _descriptionController.text = ele.description!;
                _descriptionController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _descriptionController.text.length));
                _servingSizeController.text = ele.servingSize!.toString();
                _unitController.text = ele.servingUnit!;
                _servingContainerController.text =
                    ele.servingContainer!.toString();
                _caloriesController.text = ele.calorie!;
                _fatController.text = ele.fat!;
                _satFatController.text = ele.satFat!;
                _sodiumController.text = ele.sodium!;
                _cholesterolController.text = ele.cholesterol!;
                _carbohydratesController.text = ele.carbohydrates!;
                _potassiumController.text = ele.potassium!;
                _proteinController.text = ele.protein!;
                _fiberController.text = ele.fiber!;
                _sugarController.text = ele.sugar!;
                _vitaminAController.text = ele.vitaminA!;
                _vitaminCController.text = ele.vitaminC!;
                _calciumController.text = ele.calcium!;
                _ironController.text = ele.iron!;
                time = ele.time!;
              });
              break;
            }
          }
        }
      });
    });
  }

  @override
  void initState() {
    getFoodData();
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
        title: Text(widget.data.action == 'Add' ? 'Create Food' : 'Update Food', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () async {
                  if ((_descriptionController.text.isEmpty ||
                      _servingSizeController.text.isEmpty ||
                      _unitController.text.isEmpty ||
                      _servingContainerController.text.isEmpty ||
                      _caloriesController.text.isEmpty ||
                      _fatController.text.isEmpty ||
                      _carbohydratesController.text.isEmpty ||
                      _proteinController.text.isEmpty)) {
                    ErrorDialog()
                        .errorDialog(context, 'Please fill required field.');
                  } else {
                    setState(() {
                      widget.data.foodData.brandName =
                          _brandNameController.text;
                      widget.data.foodData.description =
                          _descriptionController.text;
                      widget.data.foodData.servingSize =
                          int.parse(_servingSizeController.text);
                      widget.data.foodData.servingUnit = _unitController.text;
                      widget.data.foodData.servingContainer =
                          int.parse(_servingContainerController.text);
                      widget.data.foodData.calorie = _caloriesController.text;
                      widget.data.foodData.fat = _fatController.text;
                      widget.data.foodData.satFat = _satFatController.text;
                      widget.data.foodData.sodium = _sodiumController.text;
                      widget.data.foodData.cholesterol =
                          _cholesterolController.text;
                      widget.data.foodData.carbohydrates =
                          _carbohydratesController.text;
                      widget.data.foodData.potassium =
                          _potassiumController.text;
                      widget.data.foodData.protein = _proteinController.text;
                      widget.data.foodData.fiber = _fiberController.text;
                      widget.data.foodData.sugar = _sugarController.text;
                      widget.data.foodData.vitaminA = _vitaminAController.text;
                      widget.data.foodData.vitaminC = _vitaminCController.text;
                      widget.data.foodData.calcium = _calciumController.text;
                      widget.data.foodData.iron = _ironController.text;
                      widget.data.foodData.time = time;
                    });
                    widget.data.action == 'Add'
                        ? helper.insertFood(widget.data.foodData)
                        : helper.updateFoodData(widget.data.foodData);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (route) => false,
                        arguments: HomeScreenData(
                            index: 2,
                            date: DateTime.parse(widget.data.foodData.date!)));
                  }
                },
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              if (widget.data.action == 'Add')
                shadowTitle('New Food', deviceWidth(context) * 0.33),
              if (widget.data.action == 'Add') const SizedBox(height: 10),
              dataEntryField(
                  'Brand Name', 'ex. McDonald\'s', _brandNameController),
              dataEntryField(
                  'Description', 'ex. Veggie Burger', _descriptionController),
              const SizedBox(height: 20),
              shadowTitle('Servings', deviceWidth(context) * 0.3),
              const SizedBox(height: 10),
              dataEntryField('Serving Size', '1', _servingSizeController),
              dataEntryField(
                  'Servings per Container', '1', _servingContainerController),
              const SizedBox(height: 20),
              shadowTitle('Nutrition Facts', deviceWidth(context) * 0.4),
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: deviceWidth(context),
                decoration: decoration(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      width: deviceWidth(context) * 0.2,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: colorIndigo.withOpacity(0.2),
                              width: deviceWidth(context) * 0.015)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('-', style: textStyle14Bold(colorIndigo)),
                          Text('Cal', style: textStyle12(colorIndigo)),
                        ],
                      ),
                    ),
                    carbsFatProtein('0%', '0g', 'Carbs'),
                    carbsFatProtein('0%', '0g', 'Fat'),
                    carbsFatProtein('100%', '0g', 'Protein'),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              calorieDataField('Calories', _caloriesController, ''),
              calorieDataField('Fat', _fatController, 'g'),
              calorieDataField('Saturated Fat', _satFatController, 'g'),
              calorieDataField('Sodium', _sodiumController, 'mg'),
              calorieDataField('Cholesterol', _cholesterolController, 'mg'),
              calorieDataField('Carbohydrates', _carbohydratesController, 'g'),
              calorieDataField('Potassium', _potassiumController, 'mg'),
              calorieDataField('Protein', _proteinController, 'g'),
              calorieDataField('Fiber', _fiberController, 'g'),
              calorieDataField('Sugars', _sugarController, 'g'),
              calorieDataField('Vitamin A', _vitaminAController, '%'),
              calorieDataField('Vitamin C', _vitaminCController, '%'),
              calorieDataField('Calcium', _calciumController, '%'),
              calorieDataField('Iron', _ironController, '%'),
              calorieDataField('Time'),
              const SizedBox(height: 150),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(double radius) {
    return BoxDecoration(
        color: radius == 8 ? colorIndigo : colorWhite,
        borderRadius: BorderRadius.circular(radius),
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

  shadowTitle(String title, double width) {
    return Container(
      height: 45,
      width: width,
      decoration: decoration(8),
      alignment: Alignment.center,
      child: Text(title, style: textStyle16Bold(colorWhite)),
    );
  }

  dataEntryField(String title,
      [String? hintText, TextEditingController? controller]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: textStyle16Bold(colorIndigo)),
              if (title != 'Brand Name' && title != 'Serving Time')
                Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
            ],
          ),
          const SizedBox(height: 10),
          if (title != 'Serving Time')
            Column(
              children: [
                textField(controller!, hintText!),
                if (title == 'Serving Size')
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      textField(_unitController, 'Unit(s)'),
                    ],
                  ),
              ],
            ),
        ],
      ),
    );
  }

  textField(TextEditingController controller, String hintText) {
    return Container(
      height: 55,
      decoration: decoration(4),
      child: Padding(
        padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
        child: SizedBox(
          height: deviceHeight(context) * 0.065,
          width: deviceWidth(context),
          child: TextFormField(
            controller: controller,
            autofocus: true,
            style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
            cursorColor: colorIndigo,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: textStyle14Bold(colorGrey),
                border: InputBorder.none),
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }

  carbsFatProtein(String percentage, String weight, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(percentage, style: textStyle13Medium(colorIndigo)),
        const SizedBox(height: 5),
        Text(weight, style: textStyle14Bold(colorIndigo)),
        const SizedBox(height: 5),
        Text(title, style: textStyle13Medium(colorIndigo)),
      ],
    );
  }

  calorieDataField(String title,
      [TextEditingController? controller, String? valueType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 55,
        decoration: decoration(4.1),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(title, style: textStyle16Bold(colorIndigo)),
            if (title == 'Calories' ||
                title == 'Fat' ||
                title == 'Carbohydrates' ||
                title == 'Protein')
              Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
            const Spacer(),
            if (title != 'Time') calorieTextField(controller!, valueType!),
            if (title == 'Time')
              TextButton(
                  onPressed: _presentTimePicker,
                  child: Text(time == null ? 'Select Time' : time!,
                      style: textStyle14Medium(Colors.blue.shade800))),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }

  calorieTextField(TextEditingController controller, String valueType) {
    return SizedBox(
      width: 72,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 50,
            alignment: Alignment.centerRight,
            child: TextFormField(
              controller: controller,
              style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
              cursorColor: colorIndigo,
              textAlign: TextAlign.center,
              inputFormatters: [
                LengthLimitingTextInputFormatter(valueType == '%' ? 3 : 5),
              ],
              decoration: InputDecoration(
                  hintText: '-',
                  hintStyle: textStyle18Bold(colorGrey.withOpacity(0.7))),
              keyboardType: TextInputType.number,
            ),
          ),
          Text(valueType, style: textStyle13(Colors.blue.shade800))
        ],
      ),
    );
  }
}
