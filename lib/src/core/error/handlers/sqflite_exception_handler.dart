import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';

class SQLiteExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    final bool isEnglish =
        LocalizationManager.getCurrentLocale().languageCode == "en";

    if (exception is DatabaseException) {
      final String errorCode = _extractErrorCode(exception.toString());

      if (isEnglish) {
        switch (errorCode) {
          case "1":
            return "SQL syntax error";
          case "2":
            return "SQLite internal error";
          case "3":
            return "Access permission denied";
          case "4":
            return "Query aborted";
          case "5":
            return "Database is locked";
          case "6":
            return "Database table is locked";
          case "7":
            return "Out of memory";
          case "8":
            return "Database is read-only";
          case "9":
            return "Operation interrupted";
          case "10":
            return "Disk I/O error";
          case "11":
            return "Database is corrupted";
          case "12":
            return "Table or record not found";
          case "13":
            return "Database is full";
          case "14":
            return "Unable to open database file";
          case "15":
            return "Database protocol error";
          case "16":
            return "No data found";
          case "17":
            return "Database schema changed";
          case "18":
            return "String or BLOB exceeded size limit";
          case "19":
            return "Constraint violation: Data integrity constraint failed";
          case "20":
            return "Data type mismatch";
          case "21":
            return "Library misuse";
          case "22":
            return "Large file support disabled";
          case "23":
            return "Authorization denied";
          case "24":
            return "Incorrect format";
          case "25":
            return "Value out of range";
          case "26":
            return "File is not a database";
          case "1555":
            return "Unique constraint failed: Record already exists";
          case "2067":
            return "Foreign key constraint failed";
          case "2579":
            return "Primary key constraint failed";
          default:
            if (exception.toString().contains("no such table")) {
              return "Table does not exist";
            } else if (exception.toString().contains("no such column")) {
              return "Column does not exist";
            } else if (exception.toString().contains("duplicate column name")) {
              return "Column already exists";
            } else {
              return "Database error: ${exception.toString()}";
            }
        }
      } else {
        switch (errorCode) {
          case "1":
            return "خطأ في صياغة SQL";
          case "2":
            return "خطأ داخلي في SQLite";
          case "3":
            return "تم رفض إذن الوصول";
          case "4":
            return "تم إلغاء الاستعلام";
          case "5":
            return "قاعدة البيانات مقفلة";
          case "6":
            return "جدول قاعدة البيانات مقفل";
          case "7":
            return "نفاد الذاكرة";
          case "8":
            return "قاعدة البيانات للقراءة فقط";
          case "9":
            return "تمت مقاطعة العملية";
          case "10":
            return "خطأ في قراءة/كتابة القرص";
          case "11":
            return "قاعدة البيانات تالفة";
          case "12":
            return "الجدول أو السجل غير موجود";
          case "13":
            return "قاعدة البيانات ممتلئة";
          case "14":
            return "تعذر فتح ملف قاعدة البيانات";
          case "15":
            return "خطأ في بروتوكول قاعدة البيانات";
          case "16":
            return "قاعدة البيانات فارغة";
          case "17":
            return "تم تغيير مخطط قاعدة البيانات";
          case "18":
            return "تجاوز النص أو BLOB للحجم المسموح";
          case "19":
            return "انتهاك القيود: فشل في قيود سلامة البيانات";
          case "20":
            return "عدم تطابق نوع البيانات";
          case "21":
            return "سوء استخدام المكتبة";
          case "22":
            return "دعم الملفات الكبيرة معطل";
          case "23":
            return "تم رفض التفويض";
          case "24":
            return "تنسيق غير صحيح";
          case "25":
            return "القيمة خارج النطاق";
          case "26":
            return "الملف ليس قاعدة بيانات";
          case "1555":
            return "فشل قيد الفريد: السجل موجود بالفعل";
          case "2067":
            return "فشل قيد المفتاح الخارجي";
          case "2579":
            return "فشل قيد المفتاح الأساسي";
          default:
            if (exception.toString().contains("no such table")) {
              return "الجدول غير موجود";
            } else if (exception.toString().contains("no such column")) {
              return "العمود غير موجود";
            } else if (exception.toString().contains("duplicate column name")) {
              return "العمود موجود بالفعل";
            } else {
              return "خطأ في قاعدة البيانات: ${exception.toString()}";
            }
        }
      }
    } else if (exception is FileSystemException) {
      return isEnglish
          ? "File system error: ${exception.message}"
          : "خطأ في نظام الملفات: ${exception.message}";
    } else if (exception is FormatException) {
      return isEnglish
          ? "Format error: ${exception.message}"
          : "خطأ في التنسيق: ${exception.message}";
    } else {
      return isEnglish
          ? "Database operation error: ${exception.toString()}"
          : "خطأ في عملية قاعدة البيانات: ${exception.toString()}";
    }
  }

  String _extractErrorCode(String errorMessage) {
    final RegExp codeRegex = RegExp(r'SQLite error (\d+):');
    final Match? match = codeRegex.firstMatch(errorMessage);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? "0";
    }

    final RegExp constraintRegex = RegExp(r'SQLITE_CONSTRAINT_(\w+)\((\d+)\)');
    final Match? constraintMatch = constraintRegex.firstMatch(errorMessage);

    if (constraintMatch != null && constraintMatch.groupCount >= 2) {
      return constraintMatch.group(2) ?? "19";
    }

    return "0";
  }
}
