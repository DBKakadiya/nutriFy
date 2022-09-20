import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutrime/resources/resource.dart';

class ExitScreen extends StatefulWidget {
  static const route = '/Exit-Screen';

  const ExitScreen({Key? key}) : super(key: key);

  @override
  State<ExitScreen> createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> {
  _onBackPressed() {
    return showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        isScrollControlled: true,
        context: context,
        builder: (context) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: deviceHeight(context) * 0.7,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13)),
                      color: colorWhite),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: deviceHeight(context) * 0.2,
                        width: deviceWidth(context),
                        child: Center(
                          child: Image.asset(imgSplash,
                              width: deviceWidth(context) * 0.35),
                        ),
                      ),
                      SizedBox(
                        height: deviceHeight(context) * 0.05,
                      ),
                      Text('Are you sure want to exit?',
                          style: textStyle18Bold(colorIndigo)),
                      SizedBox(
                        height: deviceHeight(context) * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          commonButton('Yes', deviceWidth(context) * 0.33,
                              () => exit(0)),
                          commonButton('No', deviceWidth(context) * 0.33,
                              () => Navigator.of(context).pop(false)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBG,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 1.5,
            width: deviceWidth(context),
            color: colorIndigo,
          ),
          SizedBox(height: deviceHeight(context) * 0.02),
          Image.asset(imgExitPhoto, width: deviceWidth(context)),
          SizedBox(height: deviceHeight(context) * 0.02),
          Container(
            height: 1.5,
            width: deviceWidth(context),
            color: colorIndigo,
          ),
          SizedBox(height: deviceHeight(context) * 0.025),
          commonButton('Exit App', deviceWidth(context) * 0.65, _onBackPressed),
          SizedBox(height: deviceHeight(context) * 0.07),
        ],
      ),
    );
  }

  commonButton(String title, double width, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.065,
        width: width,
        decoration: BoxDecoration(
            color: colorIndigo,
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(45), right: Radius.circular(45)),
            boxShadow: [
              BoxShadow(
                  color: colorIndigo.withOpacity(0.5),
                  blurRadius: 5,
                  offset: const Offset(2, 2)),
            ]),
        alignment: Alignment.center,
        child: Text(title, style: textStyle20Bold(colorWhite)),
      ),
    );
  }
}
