import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';
import 'package:flutter_website_aaron/app/shared/user_controller.dart';

import '../../../connection/api_connection.dart';

class ClientsPageController {
  ClientsPageController._();

  static ClientsPageController? _instance;

  static ClientsPageController get instance {
    _instance ??= ClientsPageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;
  final _userController = UserController.instance;

  Future<List<Buyer>> getBuyers() async {
    final currentUser = await _userController.getCurrentUser();
    final result = await ApiConnection.instance.get(
      path: constants.buyers,
      queryParameters: {
        'seller_id': currentUser.sellerId,
      },
    );
    final response = result['response'] as List;
    final list = response.map((e) => Buyer.fromJson(e)).toList();
    return list;
  }

  Future<List<Warning>> getWarnings() async {
    final result = await ApiConnection.instance.get(path: constants.logs);
    final response = result['response'] as List;
    final list = response.map((e) => Warning.fromJson(e)).toList();
    return list;
  }
}
