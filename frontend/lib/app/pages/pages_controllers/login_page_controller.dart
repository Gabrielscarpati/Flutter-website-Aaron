import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';

import '../../connection/api_connection.dart';

class LoginPageController {
  LoginPageController._();

  static LoginPageController? _instance;

  static LoginPageController get instance {
    _instance ??= LoginPageController._();
    return _instance!;
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final constants = AppConstants.instance;

  Future<String?> authenticate() async {
    try {
      final response = await ApiConnection.instance.login(
        path: constants.login,
        data: {
          'email_user': emailController.text,
          'password': passwordController.text
        },
      );

      await Storage.tokenStorage.write(
        key: 'userId',
        value: jsonEncode({
          'token': response.data['response']['token'],
          'refreshToken': response.data['response']['refreshToken']
        }),
      );

      return null;
    } catch (_) {
      return 'Invalid credentials!';
    }
  }
}
