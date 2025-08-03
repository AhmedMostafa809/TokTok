// import 'package:get/get.dart';
// import 'package:toktokapp/translations/arabic_translation.dart';
// import 'package:toktokapp/translations/english_translation.dart';
// import 'package:flutter/cupertino.dart';
//
// class AppTranslations extends Translations {
//   @override
//   Map<String, Map<String, String>> get keys => {
//     'en_US': enLanguage,
//     'ar_SA': arLanguage,
//   };
//
//
//   }
//
//
// class LocaleController extends ChangeNotifier {
//   Locale _locale = const Locale('en');
//
//   Locale get currentLocale => _locale;
//
//   void toggleLocale() {
//     _locale = _locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
//     notifyListeners();
//   }
// }