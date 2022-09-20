import 'package:flutter/material.dart';

import '../resources/resource.dart';

class ErrorDialogButton extends StatelessWidget {
  final String title;
  final double width;
  final Function() onClick;
  const ErrorDialogButton(this.title,this.width,this.onClick);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: deviceHeight(context) * 0.045,
        width: width,
        decoration: const BoxDecoration(
          color: colorIndigo,
          borderRadius: BorderRadius.horizontal(
              left: Radius.circular(45), right: Radius.circular(45)),
        ),
        alignment: Alignment.center,
        child: Text(title, style: textStyle16Medium(colorWhite)),
      ),
    );
  }
}
