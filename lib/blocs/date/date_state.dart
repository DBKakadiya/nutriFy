import 'package:flutter/material.dart';

@immutable
  abstract class DateState {}

class DateBlocInitial extends DateState {}

class GetDiaryDateData extends DateState {
  final DateTime date;
  GetDiaryDateData({required this.date});
}

class GetCalorieDateData extends DateState {
  final DateTime date;
  GetCalorieDateData({required this.date});
}

class GetNutrientDateData extends DateState {
  final DateTime date;
  GetNutrientDateData({required this.date});
}

class GetMacrosDateData extends DateState {
  final DateTime date;
  GetMacrosDateData({required this.date});
}
