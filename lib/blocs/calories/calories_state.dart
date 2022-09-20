import 'package:flutter/material.dart';

@immutable
  abstract class CaloriesState {}

class CaloriesBlocInitial extends CaloriesState {}

class GetCarbsData extends CaloriesState {
  final String carbs;
  GetCarbsData({required this.carbs});
}

class GetProteinData extends CaloriesState {
  final String protein;
  GetProteinData({required this.protein});
}

class GetFatData extends CaloriesState {
  final String fat;
  GetFatData({required this.fat});
}