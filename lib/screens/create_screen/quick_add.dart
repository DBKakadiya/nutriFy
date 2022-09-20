import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../models/quickAdd_data.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import '../home_screen.dart';

class QuickAddScreenData {
  final String action;
  final QuickAddData quickAddData;

  QuickAddScreenData({required this.action, required this.quickAddData});
}

class QuickAddScreen extends StatefulWidget {
  final QuickAddScreenData data;
  static const route = '/Quick-Add';

  const QuickAddScreen({required this.data});

  @override
  State<QuickAddScreen> createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _carbohydratesController =
      TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();
  String? time;

  void _presentTimePicker() {
    showTimePicker(
        context: context,
        initialTime: time == null ? TimeOfDay.now() : TimeOfDay(
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

  void getQuickAddData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<QuickAddData>?> quickAddDataList = helper.getQuickAddList();
      quickAddDataList.then((data) {
        print('--------data-----$data');
        if (widget.data.action == 'Add') {
          if (data!.isEmpty) {
            setState(() {
              widget.data.quickAddData.id = 1;
            });
          } else {
            setState(() {
              widget.data.quickAddData.id = data.last.id! + 1;
            });
          }
          print('--------id-----${widget.data.quickAddData.toString()}');
        } else {
          for (var ele in data!) {
            if (ele.id == widget.data.quickAddData.id) {
              print('--meal----${ele.toString()}');
              setState(() {
                widget.data.quickAddData.id = ele.id!;
                _calorieController.text = ele.calorie!;
                _calorieController.selection = TextSelection.fromPosition(TextPosition(offset: _calorieController.text.length));
                _carbohydratesController.text = ele.carbohydrates!;
                _fatController.text = ele.fat!;
                _proteinController.text = ele.protein!;
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
    getQuickAddData();
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
        title: Text('Quick Add', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context)*0.02),
            child: IconButton(
                onPressed: () async {
                  if ((_calorieController.text.isEmpty ||
                      _fatController.text.isEmpty ||
                      _carbohydratesController.text.isEmpty ||
                      _proteinController.text.isEmpty)) {
                    ErrorDialog()
                        .errorDialog(context, 'Please fill required field.');
                  } else {
                    setState(() {
                      widget.data.quickAddData.calorie = _calorieController.text;
                      widget.data.quickAddData.carbohydrates =
                          _carbohydratesController.text;
                      widget.data.quickAddData.fat = _fatController.text;
                      widget.data.quickAddData.protein = _proteinController.text;
                      widget.data.quickAddData.time = time;
                    });
                    widget.data.action == 'Add'
                        ? helper.insertQuickAdd(widget.data.quickAddData)
                        : helper.updateQuickAddData(widget.data.quickAddData);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        HomeScreen.route, (route) => false,
                        arguments: HomeScreenData(
                            index: 2,
                            date:
                            DateTime.parse(widget.data.quickAddData.date!)));
                  }
                },
                icon:
                Image.asset(icSaveWeight, width: deviceWidth(context) * 0.08)),
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
              'Calories', _calorieController, ''),
          dataEntryField(
              'Carbohydrates', _carbohydratesController, 'g'),
          dataEntryField('Fat', _fatController, 'g'),
          dataEntryField('Protein', _proteinController, 'g'),
          dataEntryField('Time'),
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
          if(radius == 5)
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(2, 2)),
        ]);
  }

  buttons(String icon, Function() onclick) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: (deviceHeight(context) * 0.08 - deviceHeight(context) * 0.042)/2,
          horizontal: (deviceWidth(context) * 0.15-deviceWidth(context) * 0.085)/2),
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

  dataEntryField(
      String title, [TextEditingController? controller, String? valueType]) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.01),
      child: Container(
        height: deviceHeight(context) * 0.065,
        decoration: decoration(colorGrey, 4),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(title, style: textStyle16Bold(colorIndigo)),
            if(title!='Time')
              Text('*', style: textStyle16(colorIndigo.withOpacity(0.5))),
            const Spacer(),
            if(title!='Time')
              textField(controller!, valueType!),
            if(title == 'Time')
              TextButton(onPressed: _presentTimePicker, child: Text(time==null?'Select Time':time!,
                  style: textStyle14Medium(Colors.blue.shade800))),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }

  textField(TextEditingController controller, String valueType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 40,
          width: valueType == ''
              ? deviceWidth(context) * 0.5
              : 50,
          alignment: Alignment.centerRight,
          child: TextFormField(
            controller: controller,
            autofocus: true,
            style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
            cursorColor: colorIndigo,
            textAlign: valueType == '' ? TextAlign.end : TextAlign.center,
            inputFormatters: [
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: InputDecoration(
                hintText: valueType == '' ? 'Enter Calories Amount' : '-',
                hintStyle: valueType == ''
                    ? textStyle14Bold(colorGrey.withOpacity(0.7))
                    : textStyle18Bold(colorGrey.withOpacity(0.7)),
                border: valueType == '' ? InputBorder.none : null),
            keyboardType: TextInputType.number,
          ),
        ),
        Text(valueType, style: textStyle13(Colors.blue.shade800))
      ],
    );
  }
}
