import 'package:equatable/equatable.dart';

// abstract class LocaleEvent extends Equatable {
//   const LocaleEvent();
//
//   @override
//   List<Object> get props => [];
// }
//
// class ToggleLocaleEvent extends LocaleEvent {}
//
// class SetLocaleEvent extends LocaleEvent {
//   final String languageCode;
//
//   const SetLocaleEvent(this.languageCode);
//
//   @override
//   List<Object> get props => [languageCode];
// }

abstract class LanguageEvent {}

class ToggleLanguageEvent extends LanguageEvent {}