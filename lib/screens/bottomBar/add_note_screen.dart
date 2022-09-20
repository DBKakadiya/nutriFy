import 'package:flutter/material.dart';
import 'package:nutrime/models/notes_data.dart';
import 'package:sqflite/sqflite.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../home_screen.dart';

class AddNoteData {
  final String noteType;
  final String selDate;

  const AddNoteData({required this.noteType, required this.selDate});
}

class AddNoteScreen extends StatefulWidget {
  final AddNoteData data;
  static const route = '/Add-Note';

  const AddNoteScreen({required this.data});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final TextEditingController _noteController = TextEditingController();
  DatabaseHelper helper = DatabaseHelper();
  NotesData notesData = NotesData(date: '', foodNote: '', exerciseNote: '');
  bool? check;

  getNoteDataView() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<NotesData>?> listNoteFuture = helper.getNoteList();
      listNoteFuture.then((data) {
        print('-------data-------$data');
        print('--selDate----${widget.data.selDate}');
        if (data!.isNotEmpty) {
          for (var ele in data) {
            if (ele.date == widget.data.selDate) {
              setState(() {
                notesData = data.firstWhere(
                    (element) => element.date == widget.data.selDate);
                print('----notesData-11--------${notesData.toString()}');
                _noteController.text = widget.data.noteType == 'Food Notes'
                    ? notesData.foodNote!
                    : notesData.exerciseNote!;
                _noteController.selection = TextSelection.fromPosition(TextPosition(offset: _noteController.text.length));
              });
            }
          }
        }
        check = notesData.foodNote!.isEmpty && notesData.exerciseNote!.isEmpty;
        print('-----check----$check');
        print('----notesData-22--------${notesData.toString()}');
        print('-----note-------${_noteController.text}');
      });
    });
  }

  @override
  void initState() {
    getNoteDataView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorBG,
      appBar: AppBar(
        toolbarHeight: deviceHeight(context) * 0.08,
        backgroundColor: colorWhite,
        elevation: 5,
        shadowColor: colorIndigo.withOpacity(0.25),
        leadingWidth: deviceWidth(context) * 0.15,
        leading: buttons(icBack, () => Navigator.of(context).pop()),
        title: Text(widget.data.noteType, style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    notesData.date=widget.data.selDate;
                    widget.data.noteType == 'Food Notes'
                        ? notesData.foodNote = _noteController.text
                        : notesData.exerciseNote =
                        _noteController.text;
                  });
                  check!
                      ? helper.insertNote(notesData)
                      : helper.updateNotesData(notesData);
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.route, (Route<dynamic> route) => false, arguments: HomeScreenData(
                      index: 2,
                      date: DateTime.parse(widget.data.selDate)));
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
              SizedBox(height: deviceHeight(context) * 0.04),
              Container(
                height: deviceHeight(context) * 0.6,
                decoration: decoration(Colors.transparent, 6),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.035,
                      vertical: deviceHeight(context) * 0.005),
                  child: TextFormField(
                      controller: _noteController,
                      autofocus: true,
                      style: textStyle16Bold(colorIndigo.withOpacity(0.6)),
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                          hintText: 'Enter your notes here',
                          hintStyle:
                              textStyle16Bold(colorIndigo.withOpacity(0.6)),
                          border: InputBorder.none),
                      keyboardType: TextInputType.multiline,
                      maxLines: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  PopupMenuItem menuItem(String title, Function() onClick) {
    return PopupMenuItem(
        child: GestureDetector(
      onTap: onClick,
      child: Text(title, style: textStyle16Medium(colorIndigo)),
    ));
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        border: radius == 4 ? Border.all(color: color, width: 2) : null,
        boxShadow: [
          if (radius == 5)
            BoxShadow(
                color: color.withOpacity(0.3),
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
          decoration: decoration(colorIndigo, 5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }
}
