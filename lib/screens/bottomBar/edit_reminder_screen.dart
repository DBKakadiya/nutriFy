import 'package:flutter/material.dart';

import '../../resources/resource.dart';

class EditReminderData {
  final String foodType;
  final TimeOfDay time;

  EditReminderData({required this.foodType, required this.time});
}

class EditReminderScreen extends StatefulWidget {
  final EditReminderData data;
  static const route = '/Edit-Reminder';

  const EditReminderScreen({required this.data});

  @override
  State<EditReminderScreen> createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final TextEditingController _foodTypeController = TextEditingController();
  String time = '${const TimeOfDay(hour: 8, minute: 00)}';

  void _presentTimePicker() {
    showTimePicker(
            context: context,
            initialTime: TimeOfDay(
                hour: int.parse(time.split(":")[0]),
                minute: int.parse(time.split(":")[1].split(' ')[0])))
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

  @override
  void initState() {
    setState(() {
      _foodTypeController.text = widget.data.foodType;
      time =
          '${widget.data.time.hour}:${widget.data.time.minute} ${widget.data.time.period.name}';
    });
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
        title: Text('Edit Reminder', style: textStyle20Bold(colorIndigo)),
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
          typesButton(_foodTypeController.text,
              'Remind me if i haven’t logged', () => null),
          typesButton('Time', time, _presentTimePicker),
          SizedBox(height: deviceHeight(context) * 0.02),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth(context) * 0.05),
            child: Text(
                'You will receive a reminder if you have not logged any items for your selected group by the time indicated above.',
                style: textStyle13(colorIndigo).copyWith(height: 1.3)),
          )
        ],
      ),
    ),
      ),
    );
  }

  typesButton(String title, String subTitle, Function() onClick) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          height: deviceHeight(context) * 0.09,
          width: deviceWidth(context),
          decoration: decoration(6),
          padding: EdgeInsets.only(left: deviceWidth(context) * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle18Bold(colorIndigo)),
              Text(subTitle, style: textStyle13(colorIndigo))
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
                color: colorIndigo.withOpacity(0.30),
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
}
