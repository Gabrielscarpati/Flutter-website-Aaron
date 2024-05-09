import 'package:dio/dio.dart';
import 'auth_interceptor.dart';

class ApiConnection {
  final String _url = "http://localhost:8080/";
  late final Dio _dio;

  static ApiConnection? _instance;

  static ApiConnection get instance {
    _instance ??= ApiConnection._();
    return _instance!;
  }

  ApiConnection._() {
    _dio = Dio();
    _dio.interceptors.add(AuthInterceptor());
  }

  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(
      _url + path,
      queryParameters: queryParameters,
    );

    final result = response.data;
    return result;
  }

  Future<Map<String, dynamic>> post({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.post(
      _url + path,
      queryParameters: queryParameters,
      data: data,
    );
    final result = response.data;
    return result;
  }

  Future<Map<String, dynamic>> put({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.put(
      _url + path,
      queryParameters: queryParameters,
      data: data,
    );
    final result = response.data;
    return result;
  }

  Future<Map<String, dynamic>> delete({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.delete(
      _url + path,
      queryParameters: queryParameters,
      data: data,
    );
    final result = response.data;
    return result;
  }

  Future<Response> login({
    required String path,
    required Map<String, dynamic> data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post(
      _url + path,
      queryParameters: queryParameters,
      data: data,
    );
  }
}