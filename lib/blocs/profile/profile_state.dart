import 'package:flutter/material.dart';

@immutable
  abstract class ProfileState {}

class ProfileBlocInitial extends ProfileState {}

class GetStartDateData extends ProfileState {
  final String date;
  GetStartDateData({required this.date});
}

class GetGenderData extends ProfileState {
  final String gender;
  GetGenderData({required this.gender});
}

class GetActivityData extends ProfileState {
  final String activity;
  GetActivityData({required this.activity});
}

class GetLocationData extends ProfileState {
  final String location;
  GetLocationData({required this.location});
}

class GetCaloriesData extends ProfileState {
  final String calorie;
  GetCaloriesData({required this.calorie});
}

class GetSatFatData extends ProfileState {
  final String satFat;
  GetSatFatData({required this.satFat});
}

class GetCholesterolData extends ProfileState {
  final String cholesterol;
  GetCholesterolData({required this.cholesterol});
}

class GetPotassiumData extends ProfileState {
  final String potassium;
  GetPotassiumData({required this.potassium});
}

class GetFiberData extends ProfileState {
  final String fiber;
  GetFiberData({required this.fiber});
}

class GetSodiumData extends ProfileState {
  final String sodium;
  GetSodiumData({required this.sodium});
}

class GetSugarsData extends ProfileState {
  final String sugars;
  GetSugarsData({required this.sugars});
}

class GetVitaminAData extends ProfileState {
  final String vitaminA;
  GetVitaminAData({required this.vitaminA});
}

class GetVitaminCData extends ProfileState {
  final String vitaminC;
  GetVitaminCData({required this.vitaminC});
}

class GetCalciumData extends ProfileState {
  final String calcium;
  GetCalciumData({required this.calcium});
}

class GetIronData extends ProfileState {
  final String iron;
  GetIronData({required this.iron});
}
