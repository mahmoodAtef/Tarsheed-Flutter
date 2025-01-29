import 'package:flutter/material.dart';
import 'package:tarsheed/src/core/local/shared_prefrences.dart';

import '../../../generated/l10n.dart';

class LocalizationManager {
  static List<Locale> supportedLocales = const [Locale("ar"), Locale("en")];
  static late int currentLocale;

  static Future<void> init() async {
    await CacheHelper.getData(key: "currentLocale").then((value) {
      if (value != null) {
        currentLocale = value;
      } else {
        currentLocale = 1;
      }
    });
  }

  static Future<void> setLocale(int localeIndex) async {
    if (currentLocale != localeIndex) {
      currentLocale = localeIndex;
      await S.load(getCurrentLocale());
      await saveChanges();
    }
  }

  static Future<void> saveChanges() async {
    await CacheHelper.saveData(key: "currentLocale", value: currentLocale);
  }

  static Locale getCurrentLocale() {
    return supportedLocales[currentLocale];
  }

  static String getAppTitle() {
    return currentLocale == 0 ? "هاوي هب" : "Hawihub";
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
    return currentLocale == 0 ? arabicDays : englishDays;
  }

  static final List<String> saudiCitiesArabic = [
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'الدمام',
    'الخبر',
    'الطائف',
    'المدينة المنورة',
    'بريدة',
    'تبوك',
    'خميس مشيط',
    'حائل',
    'الجبيل',
    'الخرج',
    'أبها',
    'نجران',
    'ينبع',
    'القصيم',
    'الظهران',
    'الباحة',
    'الأحساء',
    'النماص',
    'عرعر',
    'سكاكا',
    'جازان',
    'عنيزة',
    'القريات',
    'الرس',
    'صفوى',
    'الخفجي',
    'الدوادمي',
    'الزلفي',
    'رفحاء',
    'شقراء',
    'الدرعية',
    'الرميلة',
    'بيشة',
    'الطائف',
    'الظهران',
    'الفرسان',
    'المظيلف',
    'المزاحمية',
    'المويه',
  ];
  static final List<String> saudiCitiesEnglish = [
    'Riyadh',
    'Jeddah',
    'Mecca',
    'Dammam',
    'Khobar',
    'Taif',
    'Medina',
    'Buraydah',
    'Tabuk',
    'Khamis Mushait',
    'Hail',
    'Jubail',
    'Kharg',
    'Abha',
    'Najran',
    'Yanbu',
    'Qassim',
    'Dhahran',
    'Baha',
    'Al Ahsa',
    'Namas',
    'Arar',
    'Sakakah',
    'Jazan',
    'Unaizah',
    'Qurayyat',
    'Ar Rass',
    'Safwa',
    'Khafji',
    'Ad Dawadimi',
    'Zulfi',
    'Rafha',
    'Shaqraa',
    'Ad Diriyah',
    'Ar Rumaylah',
    'Bisha',
    'Taif',
    'Dhahran',
    'Farasan',
    'Muzahmiyya',
    'Al Muwayh',
  ];

  static List<String> get getSaudiCities {
    if (LocalizationManager.getCurrentLocale().languageCode == "ar") {
      return saudiCitiesArabic;
    } else {
      return saudiCitiesEnglish;
    }
  }
}
