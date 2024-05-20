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

  Future<List<Buyer>> getBuyers(int? sellerId) async {
    final currentUser = await _userController.getCurrentUser();
    final result = await ApiConnection.instance.get(
      path: constants.buyers,
      queryParameters: {
        'seller_id': sellerId ?? currentUser.sellerId,
      },
    );
    final response = result['response'] as List;
    final list = response.map((e) => Buyer.fromJson(e)).toList();
    return list;
  }

  Future<List<Warning>> getWarnings(int? sellerId) async {
    final result = await ApiConnection.instance.get(path: constants.logs);
    final response = result['response'] as List;
    final wholeList = response.map((e) => Warning.fromJson(e)).toList();
    if (sellerId == null) {
      return wholeList;
    }

    final filteredList =
        wholeList.where((log) => log.sellerId == sellerId).toList();
    return filteredList;
  }
}
