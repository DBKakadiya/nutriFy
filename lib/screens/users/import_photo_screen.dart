import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutrime/models/weight_data.dart';
import 'package:nutrime/screens/users/display_weight_data_screen.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../handler/handler.dart';
import '../../resources/resource.dart';

class ImportPhotoScreen extends StatefulWidget {
  final WeightData weightData;
  static const route = '/Import-Photo';

  const ImportPhotoScreen({required this.weightData});

  @override
  State<ImportPhotoScreen> createState() => _ImportPhotoScreenState();
}

class _ImportPhotoScreenState extends State<ImportPhotoScreen> {
  List<AssetEntity> assets = [];
  DatabaseHelper helper = DatabaseHelper();
  File? _pickedFile;

  _fetchAssets() async {
    final albums = await PhotoManager.getAssetPathList(onlyAll: true);
    final recentAlbum = albums.first;
    final recentAssets = await recentAlbum.getAssetListRange(
      start: 0,
      end: 1000000,
    );
    setState(() => assets = recentAssets);
  }

  bottomGallerySheet() async {
    await _fetchAssets();
    // return showModalBottomSheet(
    //   context: context,
    //   backgroundColor: Colors.transparent,
    //   isDismissible: false,
    //   isScrollControlled: true,
    //   builder: (context) => ClipRRect(
    //     borderRadius: const BorderRadius.only(
    //       topRight: Radius.circular(16),
    //       topLeft: Radius.circular(16),
    //     ),
    //     child: Container(
    //       color: colorWhite,
    //       height: deviceHeight(context) * 0.7,
    //       child: Stack(
    //         clipBehavior: Clip.antiAliasWithSaveLayer,
    //         children: [
    //           GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
    //             itemCount: assets.length,
    //             itemBuilder: (_, index) {
    //               return FutureBuilder<Uint8List?>(
    //                 future: assets[index].thumbnailData,
    //                 builder: (_, snapshot) {
    //                   final bytes = snapshot.data;
    //                   if (bytes == null) {
    //                     return Container(
    //                         color: colorGrey.withOpacity(0.3),
    //                         child: Center(
    //                             child: SizedBox(
    //                                 height: deviceHeight(context) * 0.02,
    //                                 width: deviceWidth(context) * 0.04,
    //                                 child: const CircularProgressIndicator(
    //                                     strokeWidth: 2,color: colorIndigo))));
    //                   }
    //                   return FutureBuilder<File?>(
    //                     future: assets[index].file,
    //                     builder: (_, snapshot) {
    //                       final file = snapshot.data;
    //                       if (file == null) return Container();
    //                       return InkWell(
    //                         onTap: () {
    //                           if (assets[index].type == AssetType.image) {
    //                               _pickedFile = file;
    //                               widget.weightData.image = _pickedFile!.path;
    //                           } else {}
    //                           Navigator.of(context).pushReplacementNamed(
    //                               DisplayWeightDataScreen.route,
    //                               arguments: widget.weightData.image);
    //                         },
    //                         child: Stack(
    //                           children: [
    //                             Positioned.fill(
    //                               child: Image.memory(bytes, fit: BoxFit.cover),
    //                             ),
    //                           ],
    //                         ),
    //                       );
    //                     },
    //                   );
    //                 },
    //               );
    //             },
    //           ),
    //           Positioned(
    //             right: deviceWidth(context) * 0.035,
    //             top: deviceHeight(context) * 0.01,
    //             child: GestureDetector(
    //               onTap: () {
    //                 Navigator.of(context).pop();
    //               },
    //               child: Container(
    //                 height: deviceHeight(context) * 0.07,
    //                 width: deviceWidth(context) * 0.07,
    //                 decoration: const BoxDecoration(
    //                     color: colorWhite, shape: BoxShape.circle),
    //                 child: const Center(
    //                     child: Icon(Icons.close, color: colorBlack, size: 20)),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }

  @override
  void initState() {
    bottomGallerySheet();
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
        title: Text('Import Photo', style: textStyle20Bold(colorIndigo)),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: deviceHeight(context) * 0.04),
                Text(
                    DateFormat('dd MMMM yyyy')
                        .format(DateTime.parse(widget.weightData.date!)),
                    style: textStyle16Medium(colorIndigo)),
                SizedBox(height: deviceHeight(context) * 0.08),
                Icon(Icons.camera_alt_outlined,
                    color: colorIndigo, size: deviceWidth(context) * 0.08),
              ],
            ),
            SingleChildScrollView(
              child: Container(
                height: deviceHeight(context) * 0.65,
                decoration: BoxDecoration(
                    color: colorWhite,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                    ),
                    border: Border.all(color: colorIndigo, width: 2)),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(14),
                    topLeft: Radius.circular(14),
                  ),
                  child: Stack(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2),
                        itemCount: assets.length,
                        itemBuilder: (_, index) {
                          return FutureBuilder<Uint8List?>(
                            future: assets[index].thumbnailData,
                            builder: (_, snapshot) {
                              final bytes = snapshot.data;
                              if (bytes == null) {
                                return Container(
                                    color: colorGrey.withOpacity(0.3),
                                    child: Center(
                                        child: SizedBox(
                                            height:
                                                deviceHeight(context) * 0.02,
                                            width: deviceWidth(context) * 0.04,
                                            child:
                                                const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: colorIndigo))));
                              }
                              return FutureBuilder<File?>(
                                future: assets[index].file,
                                builder: (_, snapshot) {
                                  final file = snapshot.data;
                                  if (file == null) return Container();
                                  return InkWell(
                                    onTap: () async {
                                      if (assets[index].type ==
                                          AssetType.image) {
                                        _pickedFile = file;
                                        widget.weightData.image =
                                            _pickedFile!.path;
                                        await helper.updateWeightData(widget.weightData);
                                      } else {}
                                      Navigator.of(context).pushNamed(
                                          DisplayWeightDataScreen.route,
                                          arguments: widget.weightData.image);
                                    },
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.memory(bytes,
                                              fit: BoxFit.cover),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      Positioned(
                        right: deviceWidth(context) * 0.035,
                        top: deviceHeight(context) * 0.01,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: deviceHeight(context) * 0.07,
                            width: deviceWidth(context) * 0.07,
                            decoration: const BoxDecoration(
                                color: colorIndigo, shape: BoxShape.circle),
                            child: const Center(
                                child: Icon(Icons.close,
                                    color: colorWhite, size: 20)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          BoxShadow(
              color: color.withOpacity(0.30),
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
