import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:nutrime/screens/users/progress_screen.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:sqflite/sqflite.dart';

import '../../blocs/image/image_bloc.dart';
import '../../blocs/image/image_state.dart';
import '../../handler/handler.dart';
import '../../resources/resource.dart';
import '../../widgets/error_dialog.dart';
import 'customized_photo_screen.dart';

class DisplayWeightDataScreen extends StatefulWidget {
  final String image;
  static const route = '/Display-Weight';

  const DisplayWeightDataScreen({required this.image});

  @override
  State<DisplayWeightDataScreen> createState() =>
      _DisplayWeightDataScreenState();
}

class _DisplayWeightDataScreenState extends State<DisplayWeightDataScreen> {
  List<WeightData> weightData = [];
  DatabaseHelper helper = DatabaseHelper();
  ImagePicker picker = ImagePicker();
  int initialPage = 0;
  String firstPhoto = '';
  String secondPhoto = '';
  String firstWeight = '';
  String secondWeight = '';
  String firstDate = '';
  String secondDate = '';
  bool isSingle = true;
  bool isDouble = false;
  bool isLeft = true;
  bool isRight = false;

  void getWeightData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WeightData>?> userDataList = helper.getWeightList();
      userDataList.then((data) {
        setState(() {
          weightData = data!;
          secondPhoto =
              weightData.last.image!.isEmpty ? icPhoto : weightData.last.image!;
          secondWeight = weightData.last.weight!;
          secondDate = weightData.last.date!;
          for (int i = 0; i < weightData.length; i++) {
            if (weightData[i].image == widget.image) {
              firstPhoto =
                  weightData[i].image!.isEmpty ? icPhoto : weightData[i].image!;
              firstWeight = weightData[i].weight!;
              firstDate = weightData[i].date!;
              initialPage = i;
            }
          }
        });
        print('--------weightData-------$weightData');
      });
    });
  }

  pickImage(int index) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
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
                        height: 160,
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
                                selectOption(Icons.camera_alt, 'Take Photo',
                                        () => _takePicture(index)),
                                Container(height: 1, color: colorGrey.withOpacity(0.5)),
                                selectOption(Icons.photo, 'Choose Existing Photo',
                                        () => _getImageFromGallery(index)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
        },
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }
       );
  }

  _takePicture(int index) async {
    Navigator.of(context).pop();
    weightData[index].image = '';
    final imageFile =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (imageFile == null) {
      return;
    }
    setState(() {
      weightData[index].image = imageFile.path;
      isLeft ? firstPhoto = imageFile.path : secondPhoto = imageFile.path;
    });
    helper.updateWeightData(weightData[index]);
  }

  _getImageFromGallery(int index) async {
    Navigator.of(context).pop();
    weightData[index].image = '';
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      setState(() {
        weightData[index].image = pickedFile.path;
        isLeft ? firstPhoto = pickedFile.path : secondPhoto = pickedFile.path;
      });
      helper.updateWeightData(weightData[index]);
    }
  }

  @override
  void initState() {
    getWeightData();
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
        leading: buttons(icBack, () {
          Navigator.of(context).pushReplacementNamed(ProgressScreen.route);
        }),
        title: Text('Progress Photo', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                splashColor: colorWhite,
                splashRadius: deviceWidth(context) * 0.075,
                onPressed: () {
                  if (firstPhoto == icPhoto || secondPhoto == icPhoto) {
                    ErrorDialog().errorDialog(
                        context, 'Please set photo in empty field.');
                  } else {
                    Navigator.of(context).pushNamed(CustomizePhotoScreen.route,
                        arguments: CustomizePhotoData(
                            firstImage: firstPhoto, secondImage: secondPhoto));
                  }
                },
                icon: Image.asset(icNextScreen)),
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed(ProgressScreen.route);
          return false;
        },
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (isSingle)
                  photoView(firstPhoto, isLeft, deviceWidth(context), () {}),
                if (isDouble)
                  Row(
                    children: [
                      photoView(firstPhoto, isLeft, deviceWidth(context) * 0.5,
                          () {
                        setState(() {
                          isLeft = true;
                          isRight = false;
                          for (int i = 0; i < weightData.length; i++) {
                            if (weightData[i].date == firstDate) {
                              initialPage = i;
                            }
                          }
                        });
                        if (firstPhoto == icPhoto) {
                          pickImage(initialPage);
                        }
                        print('--left--initial--$initialPage');
                      }),
                      photoView(
                          secondPhoto, isRight, deviceWidth(context) * 0.5, () {
                        setState(() {
                          isRight = true;
                          isLeft = false;
                          for (int i = 0; i < weightData.length; i++) {
                            if (weightData[i].date == secondDate) {
                              initialPage = i;
                            }
                          }
                        });
                        if (secondPhoto == icPhoto) {
                          pickImage(initialPage);
                        }
                        print('--right--initial--$initialPage');
                      })
                    ],
                  ),
                Container(
                  height: 50,
                  width: deviceWidth(context),
                  color: colorBlack.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        splashRadius: deviceWidth(context) * 0.01,
                        onPressed: () {
                          setState(() {
                            isSingle = true;
                            isDouble = false;
                            isLeft = true;
                            isRight = false;
                          });
                        },
                        icon: Image.asset(icSingle,
                            color: isSingle
                                ? colorWhite
                                : colorGrey.withOpacity(0.6),
                            height: 25),
                      ),
                      SizedBox(width: deviceWidth(context) * 0.1),
                      IconButton(
                        splashRadius: deviceWidth(context) * 0.01,
                        onPressed: () {
                          setState(() {
                            isDouble = true;
                            isSingle = false;
                          });
                        },
                        icon: Image.asset(icDouble,
                            color: isDouble
                                ? colorWhite
                                : colorGrey.withOpacity(0.6),
                            height: 25),
                      ),
                    ],
                  ),
                )
              ],
            ),
            ClipPath(
              clipper: MyClip(),
              child: Card(
                child: Container(
                  height: deviceHeight(context) * 0.09,
                  width: deviceWidth(context),
                  decoration: BoxDecoration(
                    color: colorWhite,
                    border: Border.all(color: colorGrey, width: 1.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSingle)
                        Column(
                          children: [
                            SizedBox(height: deviceHeight(context) * 0.008),
                            Text('$firstWeight Kg',
                                style: textStyle13Bold(colorIndigo)),
                            const SizedBox(height: 4),
                            Text(
                                DateFormat('dd-MMM-yyyy')
                                    .format(DateTime.parse(firstDate)),
                                style: textStyle10(colorIndigo)),
                          ],
                        ),
                      if (isDouble)
                        SizedBox(
                          width: deviceWidth(context) - 11,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                      height: deviceHeight(context) * 0.008),
                                  Text('$firstWeight Kg',
                                      style: textStyle13Bold(colorIndigo)),
                                  const SizedBox(height: 4),
                                  Text(
                                      DateFormat('dd-MMM-yyyy')
                                          .format(DateTime.parse(firstDate)),
                                      style: textStyle10(colorIndigo)),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                      height: deviceHeight(context) * 0.008),
                                  Text('$secondWeight Kg',
                                      style: textStyle13Bold(colorIndigo)),
                                  const SizedBox(height: 4),
                                  Text(
                                      DateFormat('dd-MMM-yyyy')
                                          .format(DateTime.parse(secondDate)),
                                      style: textStyle10(colorIndigo)),
                                ],
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            HorizontalCardPager(
              initialPage: initialPage,
              onPageChanged: (page) {
                if (isSingle) {
                  setState(() {
                    firstPhoto = weightData[page.toInt()].image!;
                    firstWeight = weightData[page.toInt()].weight!;
                    firstDate = weightData[page.toInt()].date!;
                  });
                  print('---firstDate1------$firstDate');
                }
                if (isDouble) {
                  if (isLeft) {
                    setState(() {
                      firstPhoto = weightData[page.toInt()].image!.isNotEmpty
                          ? weightData[page.toInt()].image!
                          : icPhoto;
                      firstWeight = weightData[page.toInt()].weight!;
                      firstDate = weightData[page.toInt()].date!;
                    });
                    print('---firstDate2-----$firstDate');
                  }
                  if (isRight) {
                    setState(() {
                      secondPhoto = weightData[page.toInt()].image!.isNotEmpty
                          ? weightData[page.toInt()].image!
                          : icPhoto;
                      secondWeight = weightData[page.toInt()].weight!;
                      secondDate = weightData[page.toInt()].date!;
                    });
                    print('---secondDate-----$secondDate');
                  }
                }
              },
              onSelectedItem: (page) => print("selected : $page"),
              items: List<CardItem>.generate(
                  weightData.length,
                  (index) => ImageCarditem(
                      image: weightData[index].image!.isNotEmpty
                          ? Image.file(File(weightData[index].image!))
                          : Padding(
                              padding: const EdgeInsets.all(12),
                              child: Image.asset(icPhoto),
                            ))),
            )
          ],
        ),
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
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

  photoView(String image, bool position, double width, Function() onClick) {
    return GestureDetector(
        onTap: onClick,
        child: Container(
            height: deviceHeight(context) * 0.65,
            width: width,
            decoration: BoxDecoration(
                border:
                    position ? Border.all(color: colorIndigo, width: 5) : null),
            child: position
                ? image == icPhoto
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Tap to Add',
                              style: textStyle13Bold(colorIndigo)),
                          const SizedBox(height: 5),
                          Image.asset(image),
                        ],
                      )
                    : BlocBuilder<ImageBloc, ImageState>(
                        builder: (context, state) {
                          if (state is GetImageData) {
                            return AspectRatio(
                              aspectRatio: 1,
                              child: PhotoViewGallery.builder(
                                backgroundDecoration:
                                    const BoxDecoration(color: Colors.white),
                                scrollPhysics: const BouncingScrollPhysics(),
                                builder: (BuildContext context, int index) {
                                  return PhotoViewGalleryPageOptions(
                                    maxScale: PhotoViewComputedScale.covered,
                                    minScale: PhotoViewComputedScale.covered,
                                    imageProvider: FileImage(
                                      state.image!,
                                    ),
                                    initialScale:
                                        PhotoViewComputedScale.covered,
                                  );
                                },
                                itemCount: 1,
                              ),
                            );
                          }
                          return AspectRatio(
                            aspectRatio: 1,
                            child: PhotoViewGallery.builder(
                              backgroundDecoration:
                                  const BoxDecoration(color: Colors.white),
                              scrollPhysics: const BouncingScrollPhysics(),
                              builder: (BuildContext context, int index) {
                                return PhotoViewGalleryPageOptions(
                                  maxScale: PhotoViewComputedScale.covered,
                                  minScale: PhotoViewComputedScale.covered,
                                  imageProvider: FileImage(
                                    File(image),
                                  ),
                                  initialScale: PhotoViewComputedScale.covered,
                                );
                              },
                              itemCount: 1,
                            ),
                          );
                        },
                      )
                : image == icPhoto
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Tap to Add',
                              style: textStyle13Bold(colorIndigo)),
                          const SizedBox(height: 5),
                          Image.asset(image),
                        ],
                      )
                    : Image.file(File(image), fit: BoxFit.cover)));
  }
}

class MyClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.7);
    path.lineTo((size.width / 2) - 15, size.height * 0.7);
    path.lineTo(size.width / 2, size.height * 0.85);
    path.lineTo((size.width / 2) + 2, size.height * 0.85);
    path.lineTo((size.width / 2) + 17, size.height * 0.7);
    path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
