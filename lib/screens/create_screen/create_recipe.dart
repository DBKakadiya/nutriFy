import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutrime/models/recipe_data.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';

class CreateRecipeData {
  final String action;
  final RecipeData recipeData;

  CreateRecipeData({required this.action, required this.recipeData});
}

class CreateRecipe extends StatefulWidget {
  final CreateRecipeData data;
  static const route = '/Create-Recipe';

  const CreateRecipe({required this.data});

  @override
  State<CreateRecipe> createState() => _CreateRecipeState();
}

class _CreateRecipeState extends State<CreateRecipe> {
  final TextEditingController _recipeNameController = TextEditingController();
  final TextEditingController _servingsController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();

  DatabaseHelper helper = DatabaseHelper();
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
            '${pickedTime.hour}:${pickedTime.minute} ${pickedTime.period.name}';
      });
    });
  }

  void getRecipeData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<RecipeData>?> quickAddDataList = helper.getRecipeList();
      quickAddDataList.then((data) {
        print('--------data-----$data');
        if (widget.data.action == 'Add') {
          if (data!.isEmpty) {
            setState(() {
              widget.data.recipeData.id = 1;
            });
          } else {
            setState(() {
              widget.data.recipeData.id = data.last.id! + 1;
            });
          }
          print('--------id-----${widget.data.recipeData.toString()}');
        } else {
          for (var ele in data!) {
            if (ele.id == widget.data.recipeData.id) {
              print('--meal----${ele.toString()}');
              setState(() {
                widget.data.recipeData.id = ele.id!;
                _recipeNameController.text = ele.recipeName!;
                _recipeNameController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _recipeNameController.text.length));
                _servingsController.text = ele.servings!.toString();
                _ingredientsController.text = ele.ingredients!;
                _calorieController.text = ele.calorie!;
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
    getRecipeData();
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
        title: Text('Create Recipe', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () async {
                  if ((_recipeNameController.text.isEmpty ||
                      _servingsController.text.isEmpty ||
                      _calorieController.text.isEmpty)) {
                    ErrorDialog()
                        .errorDialog(context, 'Please fill required field.');
                  } else {
                    setState(() {
                      widget.data.recipeData.recipeName =
                          _recipeNameController.text;
                      widget.data.recipeData.servings =
                          int.parse(_servingsController.text);
                      widget.data.recipeData.ingredients =
                          _ingredientsController.text;
                      widget.data.recipeData.calorie = _calorieController.text;
                      widget.data.recipeData.time = time;
                    });
                    widget.data.action == 'Add'
                        ? helper.insertRecipe(widget.data.recipeData)
                        : helper.updateRecipeData(widget.data.recipeData);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (route) => false,
                        arguments: HomeScreenData(
                            index: 2,
                            date:
                                DateTime.parse(widget.data.recipeData.date!)));
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
            children: [
              SizedBox(height: deviceHeight(context) * 0.03),
              dataEntryField(
                  'Recipe Name', 'ex. Macaroni Pasta', _recipeNameController),
              dataEntryField('Servings', '1', _servingsController),
              dataEntryField(
                  'Ingredients',
                  'ex. Olive Oil, Pesto, Sundries-Tomatoes etc.',
                  _ingredientsController),
              calorieDataField('Calories', _calorieController, ''),
              calorieDataField('Time'),
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

  dataEntryField(String title,
      [String? hintText, TextEditingController? controller]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: textStyle16Bold(colorIndigo)),
              Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
            ],
          ),
          const SizedBox(height: 10),
          textField(controller!, hintText!),
        ],
      ),
    );
  }

  textField(TextEditingController controller, String hintText) {
    return Container(
      height: 55,
      decoration: decoration(4),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.03),
        child: SizedBox(
          height: 55,
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
            if (title != 'Time')
              Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
            const Spacer(),
            if (title != 'Time') calorieTextField(controller!),
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

  calorieTextField(TextEditingController controller) {
    return Container(
      height: 40,
      width: 60,
      alignment: Alignment.centerRight,
      child: TextFormField(
        controller: controller,
        style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
        cursorColor: colorIndigo,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(5),
        ],
        decoration: InputDecoration(
            hintText: '-',
            hintStyle: textStyle18Bold(colorGrey.withOpacity(0.7))),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
