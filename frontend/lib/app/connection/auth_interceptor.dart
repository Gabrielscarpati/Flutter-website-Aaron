import 'package:dio/dio.dart';

import '../shared/storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await Storage.tokenStorage.read(key: 'userId');
    options.headers['x-access-token'] = token;
    return handler.next(options);
  }

  // @override
  // void onError(DioException err, ErrorInterceptorHandler handler) {
  //   if (err.response!.statusCode == 401) {
  //     handler.resolve(response)
  //   }
  // }
}
