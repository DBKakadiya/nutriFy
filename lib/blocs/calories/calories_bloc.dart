import 'package:bloc/bloc.dart';

import 'calories_event.dart';
import 'calories_state.dart';

class CaloriesBloc extends Bloc<CaloriesEvent, CaloriesState> {
  CaloriesBloc() : super(CaloriesBlocInitial()) {
    on<CaloriesEvent>((event, emit) {
      emit(CaloriesBlocInitial());
    });

    on<GetCarbsEvent>((event, emit) {
      emit(GetCarbsData(carbs: event.carbs));
    });

    on<GetProteinEvent>((event, emit) {
      emit(GetProteinData(protein: event.protein));
    });

    on<GetFatEvent>((event, emit) {
      emit(GetFatData(fat: event.fat));
    });

  }
}
