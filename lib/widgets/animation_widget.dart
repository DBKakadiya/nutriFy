import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class AnimationWidget extends StatelessWidget {
  final String message;
  final Color color;
  final Widget widget;
  final Widget screen;

  const AnimationWidget(
      {required this.message,
      required this.color,
      required this.widget,
      required this.screen});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      openBuilder: (context, closedContainer) {
        return screen;
      },
      transitionDuration: const Duration(milliseconds: 600),
      closedElevation: 0,
      closedColor: color,
      closedShape: message == 'AddItem'
          ? const CircleBorder()
          : message == 'AddItemImage' || message == 'AddWater'
              ? const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(10)))
              : InputBorder.none,
      closedBuilder: (context, openContainer) {
        return Tooltip(
          message: message,
          child: InkWell(
            onTap: () {
              openContainer();
            },
            child: widget,
          ),
        );
      },
    );
  }
}
