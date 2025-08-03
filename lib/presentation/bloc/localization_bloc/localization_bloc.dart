import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'localization_event.dart';
import 'localization_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc()
      : super(LanguageState(const Locale('en'))) {
    on<ToggleLanguageEvent>((event, emit) {
      final newLocale = state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
      emit(LanguageState(newLocale));
    });
  }
}