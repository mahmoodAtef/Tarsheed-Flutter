import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:tarsheed/src/core/apis/api.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: ApiManager.baseUrl,
      headers: {
        "Authorization": ApiManager.authToken != null
            ? "Bearer ${ApiManager.authToken}"
            : null,
        "Connection": "keep-alive",
      },
      connectTimeout: const Duration(minutes: 10),
      receiveTimeout: const Duration(minutes: 10),
    ));
    // customization
    dio.interceptors.add(PrettyDioLogger(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
        filter: (options, args) {
          return !args.isResponse || !args.hasUint8ListData;
        }));
  }

  static Future<Response> getData({
    required String path,
    Map<String, dynamic>? query,
  }) async {
    return await dio.get(
      path,
      queryParameters: query,
    );
  }

  static Future<Response> postData({
    required String path,
    Map<String, dynamic>? query,
    dynamic data,
    String? token,
  }) async {
    if (token != null) {
      dio.options.headers["Authorization"] = "Bearer $token";
    }
    return await dio.post(
      path,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putData({
    required String path,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.put(
      path,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> putDataFormData({
    required String path,
    Map<String, dynamic>? query,
    required FormData data,
    String? token,
  }) async {
    return await dio.put(
      path,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> patchData({
    required String path,
    Map<String, dynamic>? query,
    required Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.patch(
      path,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> deleteData({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    return await dio.delete(
      path,
      queryParameters: query,
      data: data,
    );
  }

  static Future<Response> postFormData(String path, FormData formData) async {
    return await dio.post(
      path,
      data: formData,
    );
  }

  static void setToken(String token) {
    dio.options.headers["Authorization"] = "Bearer $token";
  }
}
