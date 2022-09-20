import 'package:flutter/material.dart';

import '../../resources/resource.dart';

class AddFriendsScreen extends StatefulWidget {
  static const route = '/Add-Friends';

  const AddFriendsScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  List<String> titles = ['Contacts', 'Email'];
  List<String> subTitles = [
    'Find friends from my phone contacts',
    'Invite friends using their email address or Nutrition Tracker username'
  ];

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
        title: Text('Add Friends', style: textStyle20Bold(colorIndigo)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: deviceWidth(context) * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: deviceHeight(context) * 0.02),
              Column(
                children: List.generate(
                    2,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(vertical: deviceHeight(context) * 0.012),
                      child: GestureDetector(
                        onTap: (){},
                        child: Container(
                          height: index == 1 ? deviceHeight(context) * 0.1 : deviceHeight(context) * 0.085,
                          width: deviceWidth(context),
                          decoration: decoration(colorWhite, 4),
                          padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(titles[index], style: textStyle16Bold(colorIndigo)),
                              Text(subTitles[index], style: textStyle11(colorIndigo))
                            ],
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          if(radius==5)
            BoxShadow(
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
          decoration: decoration(colorWhite, 5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }
}
