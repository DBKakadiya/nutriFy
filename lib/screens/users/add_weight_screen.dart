import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:nutrime/screens/home_screen.dart';
import 'package:nutrime/screens/users/progress_screen.dart';
import 'package:nutrime/widgets/error_dialog.dart';

import '../../blocs/image/image_bloc.dart';
import '../../blocs/image/image_event.dart';
import '../../blocs/image/image_state.dart';
import '../../handler/handler.dart';
import '../../resources/resource.dart';

class AddWeightScreen extends StatefulWidget {
  final String type;
  static const route = '/Add-Weight';

  const AddWeightScreen({required this.type});

  @override
  State<AddWeightScreen> createState() => _AddWeightScreenState();
}

class _AddWeightScreenState extends State<AddWeightScreen> {
  final TextEditingController _weightController = TextEditingController();
  String date = '';
  File? _pickedFile;
  ImagePicker picker = ImagePicker();
  bool isVisible = false;
  WeightData weightData = WeightData(date: '', weight: '', image: '');
  DatabaseHelper helper = DatabaseHelper();

  datePicker() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: colorIndigo,
                  onPrimary: colorWhite,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    textStyle: textStyle14Bold(colorIndigo),
                    // primary: colorRed, // button text color
                  ),
                ),
              ),
              child: child!);
        }).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print('-------pickedDate---$pickedDate');
      setState(() {
        date = pickedDate.toString();
      });
    });
  }

  pickImage() {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: SizedBox(
                height: isVisible ? 213 : 160,
                width: deviceWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        height: 55,
                        width: deviceWidth(context),
                        decoration: BoxDecoration(
                            color: colorIndigo.withOpacity(0.1),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(20))),
                        alignment: Alignment.center,
                        child: Text('Progress Photo',
                            style: textStyle18Bold(colorIndigo))),
                    Column(
                      children: [
                        selectOption(
                            Icons.camera_alt, 'Take Photo', _takePicture),
                        Container(height: 1, color: colorGrey.withOpacity(0.5)),
                        selectOption(Icons.photo, 'Choose Existing Photo',
                            _getImageFromGallery),
                        if (isVisible)
                          Column(
                            children: [
                              Container(
                                  height: 1, color: colorGrey.withOpacity(0.5)),
                              selectOption(Icons.delete, 'Delete Photo', () {
                                BlocProvider.of<ImageBloc>(context)
                                    .add(GetImageEvent(image: null));
                                Navigator.of(context).pop();
                              }),
                            ],
                          )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _takePicture() async {
    Navigator.of(context).pop();
    _pickedFile = null;
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (imageFile == null) {
      return;
    }
    setState(() {
      _pickedFile = File(imageFile.path);
      isVisible = true;
    });
    BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: _pickedFile!));
  }

  _getImageFromGallery() async {
    Navigator.of(context).pop();
    _pickedFile = null;
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = File(pickedFile.path);
        isVisible = true;
      });
      BlocProvider.of<ImageBloc>(context)
          .add(GetImageEvent(image: _pickedFile!));
    }
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
        leading: buttons(icBack, () {
          BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: null));
          Navigator.of(context).pop();
        }),
        title: Text('Add Weight', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                onPressed: () async {
                  if ((date.isEmpty && _weightController.text.isEmpty) ||
                      (date.isNotEmpty && _weightController.text.isEmpty)) {
                    ErrorDialog().errorDialog(context, 'Please add weight');
                  } else if (date.isEmpty &&
                      _weightController.text.isNotEmpty) {
                    ErrorDialog().errorDialog(context, 'Please select date');
                  } else {
                    weightData.date = date;
                    weightData.weight = _weightController.text;
                    weightData.image = isVisible ? _pickedFile!.path : '';
                    await helper.insertWeight(weightData);
                    widget.type == 'isDashboard'
                        ? Navigator.of(context).pushNamed(HomeScreen.route,
                            arguments: HomeScreenData(
                                index: 1,
                                date: DateTime(DateTime.now().year,
                                    DateTime.now().month, DateTime.now().day)))
                        : Navigator.of(context).pushNamed(ProgressScreen.route);
                  }
                  BlocProvider.of<ImageBloc>(context)
                      .add(GetImageEvent(image: null));
                },
                icon: Image.asset(icSaveWeight,
                    width: deviceWidth(context) * 0.08)),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          BlocProvider.of<ImageBloc>(context).add(GetImageEvent(image: null));
          Navigator.of(context).pop();
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.06),
            child: Column(
              children: [
                SizedBox(height: deviceHeight(context) * 0.03),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: deviceHeight(context) * 0.015),
                  child: Container(
                    height: deviceHeight(context) * 0.065,
                    decoration: decoration(colorWhite, 6),
                    child: Row(
                      children: [
                        SizedBox(width: deviceWidth(context) * 0.03),
                        Text('Weight (kg)',
                            style: textStyle16Bold(colorIndigo)),
                        const Spacer(),
                        SizedBox(
                          height: deviceHeight(context) * 0.065,
                          width: deviceWidth(context) * 0.25,
                          child: TextFormField(
                            controller: _weightController,
                            // autofocus: true,
                            style: textStyle14Bold(colorIndigo.withOpacity(0.6)),
                            cursorColor: colorIndigo,
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                                hintText: 'add weight',
                                hintStyle: textStyle14Bold(
                                    colorIndigo.withOpacity(0.5)),
                                border: InputBorder.none),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: deviceWidth(context) * 0.03),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: deviceHeight(context) * 0.015),
                  child: Container(
                    height: deviceHeight(context) * 0.065,
                    decoration: decoration(colorWhite, 6),
                    child: Row(
                      children: [
                        SizedBox(width: deviceWidth(context) * 0.03),
                        Text('Date', style: textStyle16Bold(colorIndigo)),
                        const Spacer(),
                        GestureDetector(
                            onTap: datePicker,
                            child: Text(
                                date.isEmpty
                                    ? 'select date'
                                    : DateFormat('dd-MMM-yyyy')
                                        .format(DateTime.parse(date)),
                                style: textStyle14Bold(date.isEmpty
                                    ? colorIndigo.withOpacity(0.5)
                                    : colorIndigo))),
                        SizedBox(width: deviceWidth(context) * 0.03),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: deviceHeight(context) * 0.015),
                  child: Container(
                    height: deviceHeight(context) * 0.065,
                    decoration: decoration(colorWhite, 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: deviceWidth(context) * 0.03),
                        Text('Progress Image',
                            style: textStyle16Bold(colorIndigo)),
                        const Spacer(),
                        BlocBuilder<ImageBloc, ImageState>(
                          builder: (context, state) {
                            return state is GetImageData
                                ? SizedBox(
                                    height: deviceHeight(context) * 0.055,
                                    width: deviceWidth(context) * 0.1,
                                    child: GestureDetector(
                                        onTap: pickImage,
                                        child: Image.file(state.image!,
                                            fit: BoxFit.fill)),
                                  )
                                : SizedBox(
                                    height: deviceHeight(context) * 0.04,
                                    width: deviceWidth(context) * 0.08,
                                    child: GestureDetector(
                                      onTap: pickImage,
                                      child: Image.asset(icPhoto,
                                          fit: BoxFit.fill),
                                    ),
                                  );
                          },
                        ),
                        SizedBox(width: deviceWidth(context) * 0.03),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          decoration: decoration(colorWhite, 5),
          alignment: Alignment.center,
          child: Image.asset(icon, width: deviceWidth(context) * 0.04),
        ),
      ),
    );
  }

  selectOption(IconData icon, String title, Function() onClick) {
    return Padding(
      padding: EdgeInsets.only(left: deviceWidth(context) * 0.05),
      child: GestureDetector(
        onTap: onClick,
        child: SizedBox(
          height: 52,
          child: Row(
            children: [
              Icon(icon, color: colorIndigo),
              SizedBox(width: deviceWidth(context) * 0.03),
              Text(title, style: textStyle14Medium(colorIndigo))
            ],
          ),
        ),
      ),
    );
  }
}
