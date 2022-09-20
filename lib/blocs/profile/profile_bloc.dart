import 'package:bloc/bloc.dart';

import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileBlocInitial()) {
    on<ProfileEvent>((event, emit) {
      emit(ProfileBlocInitial());
    });

    on<GetStartDateEvent>((event, emit) {
      emit(GetStartDateData(date: event.date));
    });

    on<GetGenderEvent>((event, emit) {
      emit(GetGenderData(gender: event.gender));
    });

    on<GetActivityEvent>((event, emit) {
      emit(GetActivityData(activity: event.activity));
    });

    on<GetLocationEvent>((event, emit) {
      emit(GetLocationData(location: event.location));
    });

    on<GetCaloriesEvent>((event, emit) {
      emit(GetCaloriesData(calorie: event.calorie));
    });

    on<GetSatFatEvent>((event, emit) {
      emit(GetSatFatData(satFat: event.satFat));
    });

    on<GetCholesterolEvent>((event, emit) {
      emit(GetCholesterolData(cholesterol: event.cholesterol));
    });

    on<GetPotassiumEvent>((event, emit) {
      emit(GetPotassiumData(potassium: event.potassium));
    });

    on<GetFiberEvent>((event, emit) {
      emit(GetFiberData(fiber: event.fiber));
    });

    on<GetSodiumEvent>((event, emit) {
      emit(GetSodiumData(sodium: event.sodium));
    });

    on<GetSugarsEvent>((event, emit) {
      emit(GetSugarsData(sugars: event.sugars));
    });

    on<GetVitaminAEvent>((event, emit) {
      emit(GetVitaminAData(vitaminA: event.vitaminA));
    });

    on<GetVitaminCEvent>((event, emit) {
      emit(GetVitaminCData(vitaminC: event.vitaminC));
    });

    on<GetCalciumEvent>((event, emit) {
      emit(GetCalciumData(calcium: event.calcium));
    });

    on<GetIronEvent>((event, emit) {
      emit(GetIronData(iron: event.iron));
    });
  }
}
