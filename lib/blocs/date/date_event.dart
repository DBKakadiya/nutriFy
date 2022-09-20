import 'package:flutter/material.dart';

@immutable
abstract class DateEvent {}

class GetDiaryDateEvent extends DateEvent {
  final DateTime date;

  GetDiaryDateEvent({required this.date});
}

class GetCalorieDateEvent extends DateEvent {
  final DateTime date;

  GetCalorieDateEvent({required this.date});
}

class GetNutrientDateEvent extends DateEvent {
  final DateTime date;

  GetNutrientDateEvent({required this.date});
}

class GetMacrosDateEvent extends DateEvent {
  final DateTime date;

  GetMacrosDateEvent({required this.date});
}


