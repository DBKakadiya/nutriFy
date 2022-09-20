import 'package:flutter/material.dart';

@immutable
abstract class ProfileEvent {}

class GetStartDateEvent extends ProfileEvent {
  final String date;

  GetStartDateEvent({required this.date});
}

class GetGenderEvent extends ProfileEvent {
  final String gender;

  GetGenderEvent({required this.gender});
}

class GetActivityEvent extends ProfileEvent {
  final String activity;

  GetActivityEvent({required this.activity});
}

class GetLocationEvent extends ProfileEvent {
  final String location;

  GetLocationEvent({required this.location});
}

class GetCaloriesEvent extends ProfileEvent {
  final String calorie;

  GetCaloriesEvent({required this.calorie});
}

class GetSatFatEvent extends ProfileEvent {
  final String satFat;

  GetSatFatEvent({required this.satFat});
}

class GetCholesterolEvent extends ProfileEvent {
  final String cholesterol;

  GetCholesterolEvent({required this.cholesterol});
}

class GetPotassiumEvent extends ProfileEvent {
  final String potassium;

  GetPotassiumEvent({required this.potassium});
}

class GetFiberEvent extends ProfileEvent {
  final String fiber;

  GetFiberEvent({required this.fiber});
}

class GetSodiumEvent extends ProfileEvent {
  final String sodium;

  GetSodiumEvent({required this.sodium});
}

class GetSugarsEvent extends ProfileEvent {
  final String sugars;

  GetSugarsEvent({required this.sugars});
}

class GetVitaminAEvent extends ProfileEvent {
  final String vitaminA;

  GetVitaminAEvent({required this.vitaminA});
}

class GetVitaminCEvent extends ProfileEvent {
  final String vitaminC;

  GetVitaminCEvent({required this.vitaminC});
}

class GetCalciumEvent extends ProfileEvent {
  final String calcium;

  GetCalciumEvent({required this.calcium});
}

class GetIronEvent extends ProfileEvent {
  final String iron;

  GetIronEvent({required this.iron});
}