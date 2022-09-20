import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../resources/resource.dart';
import '../screens/bottomBar/add_note_screen.dart';
import '../screens/bottomBar/exercise_screen.dart';

class Dialogs extends StatefulWidget {
  final String type;
  final DateTime selDate;
  const Dialogs({required this.type, required this.selDate});

  @override
  State<Dialogs> createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> with SingleTickerProviderStateMixin{
  AnimationController? animationController;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: animationController!, curve: Curves.elasticInOut);

    animationController!.addListener(() {
      setState(() {});
    });

    animationController!.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation!,
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        content: widget.type == 'Exercise'? SizedBox(
          height: 200,
          width: deviceWidth(context) * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Exercises', style: textStyle20Bold(colorIndigo)),
              Column(
                children: List.generate(
                    exerciseType.length,
                        (index) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(
                                ExerciseScreen.route,
                                arguments: ExerciseData(
                                    exerciseType:
                                    exerciseType[index],
                                    selDate: DateFormat('yyyy-MM-dd').format(widget.selDate)));
                          },
                          child: Container(
                            height: 43,
                            width: deviceWidth(context) * 0.7,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color: colorGrey.withOpacity(0.5),
                                    width: 1.5)),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(
                                    width:
                                    deviceWidth(context) * 0.04),
                                Text(
                                  exerciseType[index],
                                  style:
                                  textStyle14Medium(colorIndigo),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 15)
                      ],
                    )),
              )
            ],
          ),
        ) : SizedBox(
          height: 200,
          width: deviceWidth(context) * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Notes', style: textStyle20Bold(colorIndigo)),
              Column(
                children: List.generate(
                    notesType.length,
                        (index) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(
                                AddNoteScreen.route,
                                arguments: AddNoteData(
                                    noteType: notesType[index],
                                    selDate: DateFormat('yyyy-MM-dd')
                                        .format(widget.selDate)));
                          },
                          child: Container(
                            height: 43,
                            width: deviceWidth(context) * 0.7,
                            decoration: BoxDecoration(
                                color: colorWhite,
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color: colorGrey.withOpacity(0.5),
                                    width: 1.5)),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                SizedBox(
                                    width:
                                    deviceWidth(context) * 0.04),
                                Text(
                                  notesType[index],
                                  style:
                                  textStyle14Medium(colorIndigo),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                            height: 15)
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
