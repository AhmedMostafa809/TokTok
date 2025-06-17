import 'dart:ui';

import 'package:get/get.dart';

class LanguageController extends GetxController {
  final RxString currentLanguage = 'en'.obs;

  void toggleLanguage() {
    currentLanguage.value = currentLanguage.value == 'en' ? 'ar' : 'en';
    Get.updateLocale(Locale(currentLanguage.value));
  }

  bool get isEnglish => currentLanguage.value == 'en';
}