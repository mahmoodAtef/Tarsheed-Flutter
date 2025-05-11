import 'package:tarsheed/src/core/utils/localization_manager.dart';

enum SensorCategory {
  temperature,
  current,
  motion,
  vibration,
}

extension SensorData on SensorCategory {
  String get name {
    bool isArabic = LocalizationManager.currentLocaleIndex == 0;
    switch (this) {
      case SensorCategory.temperature:
        return isArabic ? "مستشعر حرارة" : "Temperature Sensor";
      case SensorCategory.current:
        return isArabic ? "مستشعر التيار" : "Current Sensor";
      case SensorCategory.motion:
        return isArabic ? "مستشعر الحركة" : "Motion Sensor";
      case SensorCategory.vibration:
        return isArabic ? "مستشعر الاهتزاز" : "Vibration Sensor";
    }
  }

  String get id {
    switch (this) {
      case SensorCategory.temperature:
        return "6817b4b7f927a0b34e0756d7";
      case SensorCategory.current:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.motion:
        return "6817b5bda500e527dbafb536";
      case SensorCategory.vibration:
        return "6817b5e3dc386af5382343f3";
    }
  }

  String get imagePath {
    switch (this) {
      case SensorCategory.temperature:
        return 'assets/images/temp.jpeg';
      case SensorCategory.current:
        return 'assets/images/cuur.jpeg';
      case SensorCategory.motion:
        return 'assets/images/mothion.jpg';
      case SensorCategory.vibration:
        return 'assets/images/vib.jpeg';
    }
  }
}
