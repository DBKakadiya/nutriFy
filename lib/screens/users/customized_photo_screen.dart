import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uri_to_file/uri_to_file.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';

class CustomizePhotoData {
  final String firstImage;
  final String secondImage;

  CustomizePhotoData({required this.firstImage, required this.secondImage});
}

class CustomizePhotoScreen extends StatefulWidget {
  final CustomizePhotoData data;
  static const route = '/Customize-photo';

  const CustomizePhotoScreen({required this.data});

  @override
  State<CustomizePhotoScreen> createState() => _CustomizePhotoScreenState();
}

class _CustomizePhotoScreenState extends State<CustomizePhotoScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  List<WeightData> weightData = [];
  DatabaseHelper helper = DatabaseHelper();
  List<int> weightList = [];
  List<DateTime> dateList = [];
  List<String> photoList = [];
  int weightDiffer = 0;
  int dateDiffer = 0;
  String? imagePath;

  void getWeightData() {
    final Future<Database> dbFuture = helper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<WeightData>?> userDataList = helper.getWeightList();
      userDataList.then((data) {
        setState(() {
          weightData = data!;
          for (int i = 0; i < weightData.length; i++) {
            if (weightData[i].image == widget.data.firstImage) {
              photoList.add(weightData[i].image!);
              weightList.add(int.parse(weightData[i].weight!));
              dateList.add(DateTime.parse(weightData[i].date!));
            }
            if (weightData[i].image == widget.data.secondImage) {
              photoList.add(weightData[i].image!);
              weightList.add(int.parse(weightData[i].weight!));
              dateList.add(DateTime.parse(weightData[i].date!));
            }
          }
          weightDiffer = weightList.last - weightList.first;
          dateDiffer = dateList.last.difference(dateList.first).inDays;
        });
        print('--------weightData-------$weightData');
        print('--------photoList-------$photoList');
        print('--------weightList-------$weightList');
        print('--------dateList-------$dateList');
        print('--------weightDiffer-------{$weightDiffer');
        print('--------dateDiffer-------{$dateDiffer');
      });
    });
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colorBG,
        content: SizedBox(
          height: deviceHeight(context) * 0.4,
          width: deviceWidth(context) * 0.8,
          child: Center(
              child: capturedImage != null
                  ? Image.memory(capturedImage)
                  : Container()),
        ),
      ),
    );
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
  }

  _saved(image) async {
    final result = await ImageGallerySaver.saveImage(image,
        quality: 80,
        name:
            'IMAGE${DateTime.now().year}${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}');
    setState(() {
      imagePath = result['filePath'];
    });
    print("File Saved to Gallery---${result['filePath']}");
  }

  @override
  void initState() {
    getWeightData();
    _requestPermission();
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
        title: Text('Customize', style: textStyle20Bold(colorIndigo)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: deviceWidth(context) * 0.02),
            child: IconButton(
                splashColor: colorWhite,
                splashRadius: deviceWidth(context) * 0.075,
                onPressed: () async {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    await _saved(capturedImage);

                    final androidDeviceInfo =
                        await DeviceInfoPlugin().androidInfo;
                    File imageFile = int.parse(
                                androidDeviceInfo.version.release) <
                            11
                        ? await File(
                                '/storage/emulated/0/Download/NutriMe/IMAGE${DateTime.now().year}${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}.png')
                            .writeAsBytes(capturedImage!)
                        : await toFile(imagePath!);

                    await Share.shareFiles([imageFile.path],
                        text: 'Image Shared');
                  });
                },
                icon: Image.asset(icShare, width: deviceWidth(context) * 0.07)),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                height: 450,
                width: deviceWidth(context) * 0.93,
                decoration: decoration(colorGrey, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            height: 350,
                            width: deviceWidth(context) * 0.465,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(photoList.first)),
                                    fit: BoxFit.cover))),
                        Container(
                          height: 350,
                          width: deviceWidth(context) * 0.465,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(photoList.last)),
                                  fit: BoxFit.cover)),
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      width: deviceWidth(context) * 0.93,
                      decoration: const BoxDecoration(
                        color: colorWhite,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                  '${weightDiffer.isNegative ? -weightDiffer > 1 ? '${-weightDiffer} KILOGRAMS' : '${-weightDiffer} KILOGRAM' : weightDiffer > 1 ? '$weightDiffer KILOGRAMS' : '${-weightDiffer} KILOGRAM'} ${weightDiffer < 0 ? 'LOST!' : 'GAIN!'}',
                                  style: textStyle20Bold(colorIndigo)
                                      .copyWith(fontWeight: FontWeight.w900)),
                              const SizedBox(height: 2),
                              Text('(In $dateDiffer days)',
                                  style: textStyle10(colorIndigo)),
                            ],
                          ),
                          Text('NutriMe', style: textStyle14Bold(colorIndigo)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration decoration(Color color, double radius) {
    return BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(radius == 5 ? 0.3 : 0.7),
              blurRadius: radius == 5 ? 10 : 15,
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
