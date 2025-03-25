import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/utils/localization_manager.dart';

class DioExceptionHandler implements ExceptionHandler {
  @override
  String handle(Exception exception) {
    final err = exception as DioException;
    if (LocalizationManager.getCurrentLocale().languageCode == "en") {
      switch (err.response?.statusCode ?? 0) {
        case 100:
          return "Continue";
        case 101:
          return "Switching Protocols";
        case 102:
          return "Processing (WebDAV)";
        case 103:
          return "Early Hints";
        case 200:
          return "OK";
        case 201:
          return "Created";
        case 202:
          return "Accepted";
        case 203:
          return "Non-Authoritative Information";
        case 204:
          return "No Content";
        case 205:
          return "Reset Content";
        case 206:
          return "Partial Content";
        case 207:
          return "Multi-Status (WebDAV)";
        case 208:
          return "Already Reported (WebDAV)";
        case 226:
          return "IM Used (HTTP Delta encoding)";
        case 300:
          return "Multiple Choices";
        case 301:
          return "Moved Permanently";
        case 302:
          return "Found";
        case 303:
          return "See Other";
        case 304:
          return "Not Modified";
        case 305:
          return "Use Proxy (Deprecated)";
        case 307:
          return "Temporary Redirect";
        case 308:
          return "Permanent Redirect";
        case 400:
          return "Bad Request: ${err.response?.statusMessage ?? ''}";
        case 401:
          return "Unauthorized";
        case 402:
          return "Payment Required (Experimental)";
        case 403:
          return "Forbidden";
        case 404:
          return "Not Found";
        case 405:
          return "Method Not Allowed";
        case 406:
          return "Not Acceptable";
        case 407:
          return "Proxy Authentication Required";
        case 408:
          return "Request Timeout";
        case 409:
          return "Data conflict: ${err.response?.statusMessage ?? ''}";
        case 410:
          return "Gone";
        case 411:
          return "Length Required";
        case 412:
          return "Precondition Failed";
        case 413:
          return "Payload Too Large";
        case 414:
          return "URI Too Long";
        case 415:
          return "Unsupported Media Type";
        case 416:
          return "Range Not Satisfiable";

        case 417:
          return "Expectation Failed";
        case 418:
          return "I'm a teapot";
        case 421:
          return "Misdirected Request";
        case 422:
          return "Unprocessable Content (WebDAV)";
        case 423:
          return "Locked (WebDAV)";
        case 424:
          return "Failed Dependency (WebDAV)";
        case 425:
          return "Too Early (Experimental)";
        case 426:
          return "Upgrade Required";
        case 428:
          return "Precondition Required";
        case 429:
          return "Too Many Requests";
        case 431:
          return "Request Header Fields Too Large";
        case 451:
          return "Unavailable For Legal Reasons";
        case 500:
          return "Internal Server Error";
        case 501:
          return "Not Implemented";
        case 502:
          return "Bad Gateway";
        case 503:
          return "Service Unavailable";
        case 504:
          return "Gateway Timeout";
        case 505:
          return "HTTP Version Not Supported";
        case 506:
          return "Variant Also Negotiates";
        case 507:
          return "Insufficient Storage (WebDAV)";
        case 508:
          return "Loop Detected (WebDAV)";
        case 510:
          return "Not Extended";
        case 511:
          return "Network Authentication Required";
        default:
          return "Unknown Error ${err.response?.statusMessage}";
      }
    }
    switch (err.response?.statusCode ?? 0) {
      case 100:
        return "استمرار";
      case 101:
        return "تغيير البروتوكولات";
      case 102:
        return "معالجة الطلب (WebDAV)";
      case 103:
        return "معلومات مبكرة";
      case 200:
        return "نجاح";
      case 201:
        return "تم الإنشاء بنجاح";
      case 202:
        return "تم قبول الطلب";
      case 203:
        return "معلومات غير موثوقة";
      case 204:
        return "لا يوجد محتوى";
      case 205:
        return "إعادة تعيين المحتوى";
      case 206:
        return "محتوى جزئي";
      case 207:
        return "عدة حالات (WebDAV)";
      case 208:
        return "تم الإبلاغ بالفعل (WebDAV)";
      case 226:
        return "تم استخدام IM (ترميز Delta HTTP)";
      case 300:
        return "اختيارات متعددة";
      case 301:
        return "تم إعادة توجيه الطلب بشكل دائم";
      case 302:
        return "تم العثور عليه";
      case 303:
        return "انظر لمكان آخر";
      case 304:
        return "لم يتم تعديل الطلب";
      case 305:
        return "استخدم الوكيل (مهجور)";
      case 307:
        return "إعادة توجيه مؤقتة";
      case 308:
        return "إعادة توجيه دائمة";
      case 400:
        return "طلب غير صالح";
      case 401:
        return "غير مصرح به";
      case 402:
        return "الدفع مطلوب (تجريبي)";
      case 403:
        return "الوصول غير مسموح";
      case 404:
        return "الموارد غير موجودة";
      case 405:
        return "الطريقة غير مسموح بها";
      case 406:
        return "المحتوى غير مقبول";
      case 407:
        return "مطلوب مصادقة الوكيل";
      case 408:
        return "انتهت مهلة الطلب";
      case 409:
        return "تعارض في البيانات";
      case 410:
        return "الموارد غير متوفرة";
      case 411:
        return "الطول المطلوب مفقود";
      case 412:
        return "فشلت الشروط الأولية للطلب";
      case 413:
        return "البيانات كبيرة جدًا";
      case 414:
        return "طول الرابط طويل جدًا";
      case 415:
        return "نوع الوسائط غير مدعوم";
      case 416:
        return "النطاق غير مقبول";
      case 417:
        return "فشل في التوقعات";
      case 418:
        return "المحتوى غير قابل للمعالجة";
      case 421:
        return "طلب مخطئ";
      case 422:
        return "المحتوى غير قابل للمعالجة";
      case 423:
        return "المورد مغلق";
      case 424:
        return "فشل الاعتماديات";
      case 425:
        return "الطلب مبكر جدًا";
      case 426:
        return "الترقية مطلوبة";
      case 428:
        return "شرط مسبق مطلوب";
      case 429:
        return "الكثير من الطلبات";
      case 431:
        return "حقول رأس الطلب كبيرة جدًا";
      case 451:
        return "غير متوفر لأسباب قانونية";
      case 500:
        return "خطأ في الخادم الداخلي";
      case 501:
        return "غير متبنى";
      case 502:
        return "خطأ في البوابة";
      case 503:
        return "الخدمة غير متوفرة";
      case 504:
        return "بوابة مهلة زائدة";
      case 505:
        return "إصدار HTTP غير مدعوم";
      case 506:
        return "المتغير يتفاوض أيضًا";
      case 507:
        return "تخزين غير كافي";
      case 508:
        return "الكشف عن حلقة";
      case 510:
        return "لم يتم التمديد";
      case 511:
        return "المصادقة على الشبكة مطلوبة";
      default:
        return "خطأ غير معروف";
    }
  }
}
