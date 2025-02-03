import 'package:dio/dio.dart';
import 'package:tarsheed/src/core/apis/api.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(BaseOptions(
      baseUrl: ApiManager.baseUrl,
      headers: {
        "Authorization": ApiManager.authToken,
        "Connection": "keep-alive",
      },
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));
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
  }) {
    return dio.patch(
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
}
