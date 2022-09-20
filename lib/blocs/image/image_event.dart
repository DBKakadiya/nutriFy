import 'dart:io';

import 'package:flutter/material.dart';

@immutable
abstract class ImageEvent {}

class GetImageEvent extends ImageEvent {
  final File? image;

  GetImageEvent({required this.image});
}

