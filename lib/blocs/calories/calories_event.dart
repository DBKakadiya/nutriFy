import 'package:flutter/material.dart';

@immutable
abstract class CaloriesEvent {}

class GetCarbsEvent extends CaloriesEvent {
  final String carbs;

  GetCarbsEvent({required this.carbs});
}

class GetProteinEvent extends CaloriesEvent {
  final String protein;

  GetProteinEvent({required this.protein});
}

class GetFatEvent extends CaloriesEvent {
  final String fat;

  GetFatEvent({required this.fat});
}
