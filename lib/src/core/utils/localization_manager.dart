import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class LocalizationManager {
  static List<Locale> supportedLocales = const [Locale("ar"), Locale("en")];
  static int currentLocaleIndex = 1;

  static Future<void> changeLanguage(String languageCode) async {
    if (languageCode == "en") {
      currentLocaleIndex = 1;
    } else {
      currentLocaleIndex = 0;
    }
    await S.load(getCurrentLocale());
  }

  static Locale getCurrentLocale() {
    return supportedLocales[currentLocaleIndex];
  }

  static String getAppTitle() {
    return currentLocaleIndex == 0 ? "ترشيد" : "Tarsheed";
  }

  static List<String> arabicDays = [
    "الأحد",
    "الأثنين",
    "الثلاثاء",
    "الأربعاء",
    "الخميس",
    "الجمعة",
    "السبت"
  ];
  static List<String> englishDays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];

  static List<String> getDays() {
    return currentLocaleIndex == 0 ? arabicDays : englishDays;
  }

  static String getLanguageName() {
    return currentLocaleIndex == 0 ? "arabic" : "english";
  }
}
