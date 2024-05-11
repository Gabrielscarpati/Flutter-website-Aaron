import 'dart:convert';

import 'package:dio/dio.dart';

import '../shared/storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await StorageRepositor.getId(key: 'userId');
    if (token.isNotEmpty) {
      options.headers['x-access-token'] = jsonDecode(token)['token'];
    }
    return handler.next(options);
  }
}
