import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';

import '../../../generated/l10n.dart';

class LocalizationManager {
  static List<Locale> supportedLocales = const [Locale("ar"), Locale("en")];
  static late int currentLocaleIndex;

  static Future<void> init() async {
    await CacheHelper.getData(key: "currentLocale").then((value) {
      if (value != null) {
        currentLocaleIndex = value;
      } else {
        currentLocaleIndex = 1;
      }
    });
  }

  static Future<void> changeLanguage() async {
    if (currentLocaleIndex == 0) {
      currentLocaleIndex = 1;
    } else {
      currentLocaleIndex = 0;
    }
    await S.load(getCurrentLocale());
    await saveChanges();
  }

  static Future<void> saveChanges() async {
    await CacheHelper.saveData(key: "currentLocale", value: currentLocaleIndex);
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
}
