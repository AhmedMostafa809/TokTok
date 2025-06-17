import 'package:get/get.dart';
import 'package:toktokapp/translations/arabic_translation.dart';
import 'package:toktokapp/translations/english_translation.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enLanguage,
    'ar_SA': arLanguage,
  };
}