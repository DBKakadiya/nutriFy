import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrime/models/meal_data.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/image/image_bloc.dart';
import '../../blocs/image/image_event.dart';
import '../../blocs/image/image_state.dart';
import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';

class CreateMealData {
  final String action;
  final MealData mealData;

  CreateMealData({required this.action, required this.mealData});
}

class CreateMeal extends StatefulWidget {
  static const route = '/Create-Meal';

  final CreateMealData data;
  const CreateMeal({required this.data});

  @override
  State<CreateMeal> createState() => _CreateMealState();
}

class _CreateMealState extends State<CreateMeal> {
  final TextEditingController _mealController = TextEditingController();
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
  final TextEditingController _directionController = TextEditingController();
  File? _pickedFile;
  ImagePicker picker = ImagePicker();
  DatabaseHelper helper = DatabaseHelper();
  bool isVisible = false;
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
            '${pickedTime.hour>12?pickedTime.hour-12:pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.name}';
      });
    });
  }

  pickImage() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: isVisible ? 213 : 160,
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
                        child: Text('Progress Photo',
                            style: textStyle18Bold(colorIndigo))),
                    Column(
                      children: [
                        selectOption(
                            Icons.camera_alt, 'Take Photo', _takePicture),
                        Container(height: 1, color: colorGrey.withOpacity(0.5)),
                        selectOption(
                            Icons.photo, 'Import Photo', _getImageFromGallery),
                        if (isVisible)
                          Column(
                            children: [
                              Container(
                                  height: 1, color: colorGrey.withOpacity(0.5)),
                              selectOption(Icons.delete, 'Delete Photo', () {
                                setState(() {
                                  isVisible = false;
                                });
                                BlocProvider.of<ImageBloc>(context)
                                    .add(GetImageEvent(image: null));
                                Navigator.of(context).pop();
                              }),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _takePicture() async {
    Navigator.of(context).pop();
    _pickedFile = null;
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _pickedFile = File(imageFile.path);
      isVisible = true;
    });
    BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: _pickedFile!));
  }

  _getImageFromGallery() async {
    Navigator.of(context).pop();
    _pickedFile = null;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
        isVisible = true;
      });
    }
    BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: _pickedFile!));
  }

  void getMealData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<MealData>?> mealDataList = helper.getMealList();
      mealDataList.then((data) {
        print('--------data-----$data');
        if (widget.data.action == 'Add') {
          if (data!.isEmpty) {
            setState(() {
              widget.data.mealData.id = 1;
            });
          } else {
            setState(() {
              widget.data.mealData.id = data.last.id! + 1;
            });
          }
          print('--------id-----${widget.data.mealData.toString()}');
        } else {
          for (var ele in data!) {
            if (ele.id == widget.data.mealData.id) {
              print('--meal----${ele.toString()}');
              BlocProvider.of<ImageBloc>(context)
                  .add(GetImageEvent(image: File(ele.image!)));
              setState(() {
                isVisible = true;
                widget.data.mealData.id = ele.id!;
                _pickedFile = File(ele.image!);
                _mealController.text = ele.name!;
                _mealController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _mealController.text.length));
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
                _directionController.text = ele.direction!;
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
    getMealData();
    print('-----action------${widget.data.mealData.type}');
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
        leading: buttons(icBack, () {
          BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: null));
          Navigator.of(context).pop();
        }),
        title: Text('Create a Meal', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () async {
                  if ((!isVisible ||
                      _mealController.text.isEmpty ||
                      _caloriesController.text.isEmpty ||
                      _fatController.text.isEmpty ||
                      _carbohydratesController.text.isEmpty ||
                      _proteinController.text.isEmpty)) {
                    ErrorDialog()
                        .errorDialog(context, 'Please fill required field.');
                  } else {
                    setState(() {
                      widget.data.mealData.image = _pickedFile!.path;
                      widget.data.mealData.name = _mealController.text;
                      widget.data.mealData.calorie = _caloriesController.text;
                      widget.data.mealData.fat = _fatController.text;
                      widget.data.mealData.satFat = _satFatController.text;
                      widget.data.mealData.sodium = _sodiumController.text;
                      widget.data.mealData.cholesterol =
                          _cholesterolController.text;
                      widget.data.mealData.carbohydrates =
                          _carbohydratesController.text;
                      widget.data.mealData.potassium =
                          _potassiumController.text;
                      widget.data.mealData.protein = _proteinController.text;
                      widget.data.mealData.fiber = _fiberController.text;
                      widget.data.mealData.sugar = _sugarController.text;
                      widget.data.mealData.vitaminA = _vitaminAController.text;
                      widget.data.mealData.vitaminC = _vitaminCController.text;
                      widget.data.mealData.calcium = _calciumController.text;
                      widget.data.mealData.iron = _ironController.text;
                      widget.data.mealData.time = time;
                      widget.data.mealData.direction =
                          _directionController.text;
                    });
                    widget.data.action == 'Add'
                        ? helper.insertMeal(widget.data.mealData)
                        : helper.updateMealData(widget.data.mealData);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (route) => false,
                        arguments: HomeScreenData(
                            index: 2,
                            date: DateTime.parse(widget.data.mealData.date!)));
                    BlocProvider.of<ImageBloc>(context)
                        .add(GetImageEvent(image: null));
                  }
                },
                icon: Image.asset(icSaveWeight,
                    width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: null));
          Navigator.of(context).pop();
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  BlocBuilder<ImageBloc, ImageState>(
                    builder: (context, state) {
                      return SizedBox(
                        height: 250,
                        width: deviceWidth(context),
                        child: state is GetImageData
                            ? Opacity(
                                opacity: 1,
                                child:
                                    Image.file(state.image!, fit: BoxFit.fill))
                            : Opacity(
                                opacity: 0.06,
                                child: Image.asset(imgCreateMealScreen,
                                    fit: BoxFit.fill)),
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: 250,
                      width: deviceWidth(context),
                      child: Column(
                        children: [
                          const Spacer(),
                          if (!isVisible)
                            GestureDetector(
                              onTap: pickImage,
                              child: Column(
                                children: [
                                  Image.asset(icCamera,
                                      color:
                                          isVisible ? colorWhite : colorIndigo,
                                      width: deviceWidth(context) * 0.08),
                                  const SizedBox(height: 5),
                                  Text('Add Photo',
                                      style: textStyle16Bold(isVisible
                                          ? colorWhite
                                          : colorIndigo)),
                                ],
                              ),
                            ),
                          const Spacer(),
                          if (isVisible)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                    onPressed: pickImage,
                                    child: Text('Edit',
                                        style: textStyle14Medium(colorWhite)
                                            .copyWith(shadows: [
                                          const Shadow(
                                              color: colorBlack,
                                              offset: Offset(0, 1),
                                              blurRadius: 3)
                                        ])))
                              ],
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 1,
                color: colorIndigo.withOpacity(0.4),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Meal Name', style: textStyle16Bold(colorIndigo)),
                        Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Container(
                        height: 55,
                        decoration: decoration(colorGrey, 4),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: deviceWidth(context) * 0.03),
                          child: SizedBox(
                            height: 55,
                            width: deviceWidth(context),
                            child: TextFormField(
                              controller: _mealController,
                              style:
                                  textStyle14Bold(colorIndigo.withOpacity(0.6)),
                              cursorColor: colorIndigo,
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: 'Meal name',
                                hintStyle: textStyle14Bold(colorGrey),
                                border: InputBorder.none,
                              ),
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text('Nutrition Facts', style: textStyle16Bold(colorIndigo)),
                    const SizedBox(height: 15),
                    Container(
                      height: 100,
                      width: deviceWidth(context),
                      decoration: decoration(colorWhite, 4),
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
                    dataEntryField('Calories', _caloriesController, ''),
                    dataEntryField('Fat', _fatController, 'g'),
                    dataEntryField('Saturated Fat', _satFatController, 'g'),
                    dataEntryField('Sodium', _sodiumController, 'mg'),
                    dataEntryField('Cholesterol', _cholesterolController, 'mg'),
                    dataEntryField(
                        'Carbohydrates', _carbohydratesController, 'g'),
                    dataEntryField('Potassium', _potassiumController, 'mg'),
                    dataEntryField('Protein', _proteinController, 'g'),
                    dataEntryField('Fiber', _fiberController, 'g'),
                    dataEntryField('Sugars', _sugarController, 'g'),
                    dataEntryField('Vitamin A', _vitaminAController, '%'),
                    dataEntryField('Vitamin C', _vitaminCController, '%'),
                    dataEntryField('Calcium', _calciumController, '%'),
                    dataEntryField('Iron', _ironController, '%'),
                    dataEntryField('Time'),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Directions', style: textStyle16Bold(colorIndigo)),
                        IconButton(
                            onPressed: () {},
                            icon: Image.asset(icAdd,
                                color: colorIndigo,
                                width: deviceWidth(context) * 0.05))
                      ],
                    ),
                    Container(
                      height: 100,
                      width: deviceWidth(context),
                      decoration: decoration(colorWhite, 4),
                      alignment: Alignment.center,
                      child: Text('Add Instructions for making this meal',
                          style: textStyle14(colorIndigo.withOpacity(0.5))),
                    ),
                    const SizedBox(height: 150),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if(radius==5)BoxShadow(
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

  selectOption(IconData icon, String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth(context) * 0.05),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: 52,
          color: colorWhite,
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

  dataEntryField(String title,
      [TextEditingController? controller, String? valueType]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 55,
        decoration: decoration(colorGrey, 4.1),
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
            if (title != 'Time') textField(controller!, valueType!),
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

  textField(TextEditingController controller, String valueType) {
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
