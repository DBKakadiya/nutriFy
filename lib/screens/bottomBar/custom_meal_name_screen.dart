import 'package:flutter/material.dart';

import '../../resources/resource.dart';

class CustomMealNameScreen extends StatefulWidget {
  static const route = '/Custom-Meal-Name';

  const CustomMealNameScreen({Key? key}) : super(key: key);

  @override
  State<CustomMealNameScreen> createState() => _CustomMealNameScreenState();
}

class _CustomMealNameScreenState extends State<CustomMealNameScreen> {
  final TextEditingController _name1Controller = TextEditingController();
  final TextEditingController _name2Controller = TextEditingController();
  final TextEditingController _name3Controller = TextEditingController();
  final TextEditingController _name4Controller = TextEditingController();
  final TextEditingController _name5Controller = TextEditingController();
  final TextEditingController _name6Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    setState(() {
      _name1Controller.text = 'BreakFast';
      _name2Controller.text = 'Lunch';
      _name3Controller.text = 'Dinner';
      _name4Controller.text = 'Snacks';
    });
    return Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.15,
        leading: buttons(icBack, () => Navigator.of(context).pop()),
        title: Text('Customize Meal Name', style: textStyle18Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: (){},
                icon: Image.asset(icSaveWeight, width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: SingleChildScrollView(
    child: Padding(
      padding:
          EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
      child: Column(
        children: [
          SizedBox(height: deviceHeight(context) * 0.02),
          editName('Name 1', _name1Controller),
          editName('Name 2', _name2Controller),
          editName('Name 3', _name3Controller),
          editName('Name 4', _name4Controller),
          editName('Name 5', _name5Controller),
          editName('Name 6', _name6Controller),
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
          if(radius==5)BoxShadow(
              color: colorIndigo.withOpacity(0.3),
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
          decoration: decoration(5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  editName(String name, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.015),
      child: Container(
        height: deviceHeight(context) * 0.065,
        decoration: decoration(6),
        child: Row(
          children: [
            SizedBox(width: deviceWidth(context) * 0.03),
            Text(name, style: textStyle16Bold(colorIndigo)),
            const Spacer(),
            SizedBox(
              height: deviceHeight(context) * 0.065,
              width: deviceWidth(context) * 0.3,
              child: TextFormField(
                controller: controller,
                autofocus: controller==_name5Controller?true:false,
                style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
                cursorColor: colorIndigo,
                textAlign: TextAlign.end,
                decoration: InputDecoration(
                    hintText: controller.text.isNotEmpty
                        ? controller.text
                        : 'New Meal',
                    hintStyle: controller.text.isNotEmpty
                        ? textStyle16Bold(colorIndigo)
                        : textStyle16Bold(colorGrey.withOpacity(0.7)),
                    border: InputBorder.none),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: deviceWidth(context) * 0.03),
          ],
        ),
      ),
    );
  }
}
