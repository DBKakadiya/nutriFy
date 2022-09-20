import 'package:bloc/bloc.dart';

import 'date_event.dart';
import 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(DateBlocInitial()) {
    on<DateEvent>((event, emit) {
      emit(DateBlocInitial());
    });

    on<GetDiaryDateEvent>((event, emit) {
      print('-------date--------${event.date}');
      emit(GetDiaryDateData(date: event.date));
    });

    on<GetCalorieDateEvent>((event, emit) {
      print('-------date--------${event.date}');
      emit(GetCalorieDateData(date: event.date));
    });

    on<GetNutrientDateEvent>((event, emit) {
      print('-------date--------${event.date}');
      emit(GetNutrientDateData(date: event.date));
    });

    on<GetMacrosDateEvent>((event, emit) {
      print('-------date--------${event.date}');
      emit(GetMacrosDateData(date: event.date));
    });
  }
}
