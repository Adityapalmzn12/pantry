import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(locale: Locale('en'))) {
    on<ToggleLanguageEvent>((event, emit) {
      emit(LanguageState(locale: event.locale));
    });
  }
}
