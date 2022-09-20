import 'package:flutter/material.dart';
import 'package:nutrime/widgets/error_dialog_button.dart';

import '../resources/resource.dart';

class ErrorDialog {
  errorDialog(BuildContext context, String text) {
    showGeneralDialog(
        context: context,
        barrierDismissible: false,
        transitionBuilder: (context, a1, a2, widget) {
          return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
              child: FadeTransition(
                  opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
                  child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      content: SizedBox(
                        height: text ==
                                'Women are likely to need between 1600 and 2400 calories a day, and men from 2000 to 3000. So please enter a valid goal.'
                            ? deviceHeight(context) * 0.25
                            : deviceHeight(context) * 0.2,
                        width: deviceWidth(context) * 0.8,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: deviceWidth(context) * 0.04),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Error',
                                  style: textStyle20Bold(colorIndigo)),
                              Text(text,
                                  style: textStyle16(
                                      colorIndigo.withOpacity(0.7))),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ErrorDialogButton(
                                      'OK',
                                      deviceWidth(context) * 0.2,
                                      () => Navigator.of(context).pop())
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
