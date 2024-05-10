// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/connection/api_connection.dart';
import 'package:flutter_website_aaron/app/pages/login_page.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';

import '../../main.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;

  ErrorInterceptor({
    required this.dio,
  });

  bool _lockAuthInterceptor = false;
  final _constants = AppConstants.instance;

  @override
  onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_lockAuthInterceptor) {
      final statusCode = err.response?.statusCode ?? 0;

      if (statusCode == 403) {
        _logOff();
      } else if (statusCode == 401) {
        try {
          _lockAuthInterceptor = true;

          final response = await _refreshToken(err.response!.requestOptions);

          _lockAuthInterceptor = false;
          return handler.resolve(response);
        } catch (error) {
          debugPrint(error.toString());
          _logOff();
        }
      }
    }

    _lockAuthInterceptor = false;
    return handler.next(err);
  }

  _logOff() async {
    await Storage.tokenStorage.delete(key: 'userId');

    navigatorKey.currentState?.pushReplacement(MaterialPageRoute(
      builder: (context) => const LoginPage(),
    ));
  }

  Future<dynamic> _refreshToken(RequestOptions requestOptions) async {
    //Atualiza o token
    final oldTokens = await Storage.tokenStorage.read(key: 'userId');

    if (oldTokens != null) {
      final newTokens = await ApiConnection.instance.post(
          path: _constants.refreshToken,
          data: {"refreshToken": jsonDecode(oldTokens)['refreshToken']});
      await Storage.tokenStorage
          .write(key: 'userId', value: jsonEncode(newTokens));
    }

    //refaz a requisição
    final response = await dio.fetch(requestOptions);
    return response;
  }
}
