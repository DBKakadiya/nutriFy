import 'dart:io';

import 'package:flutter/material.dart';

@immutable
  abstract class ImageState {}

class ImageBlocInitial extends ImageState {}

class GetImageData extends ImageState {
  final File? image;
  GetImageData({required this.image});
}

class GetImageDlt extends ImageState {
  final File? image;
  GetImageDlt({required this.image});
}
