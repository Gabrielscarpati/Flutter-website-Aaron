import 'dart:convert';

import 'package:flutter_website_aaron/app/models/user.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';
import 'package:flutter_website_aaron/app/shared/storage.dart';

import '../connection/api_connection.dart';

class UserController {
  UserController._();

  static UserController? _instance;
  final _constants = AppConstants.instance;

  static UserController get instance {
    _instance ??= UserController._();
    return _instance!;
  }

  Future<User> getCurrentUser() async {
    return _getCurrentUserModel();
  }

  Future<String> getCurrentSellerName() async {
    final currentUser = await _getCurrentUserModel();
    final result = await ApiConnection.instance.get(
      path: _constants.sellers,
      queryParameters: {
        'id': currentUser.sellerId,
      },
    );
    final response = result['response'] as List;
    return response.first['name'];
  }

  Future<User> _getCurrentUserModel() async {
    final currentUser = await StorageRepositor.getId(key: 'currentUser');
    if (currentUser.isNotEmpty) {
      return User.fromJson(jsonDecode(currentUser));
    }

    return User.empty();
  }

  Future<bool> currentUserIsAdmin() async {
    final currentUser = await _getCurrentUserModel();
    return currentUser.sellerId == 0;
  }
}
