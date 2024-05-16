import 'package:flutter_website_aaron/app/models/task.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';
import 'package:flutter_website_aaron/app/shared/user_controller.dart';

import '../../../connection/api_connection.dart';

class TransactionHistoryPageController {
  TransactionHistoryPageController._();

  static TransactionHistoryPageController? _instance;

  static TransactionHistoryPageController get instance {
    _instance ??= TransactionHistoryPageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;
  final _userController = UserController.instance;

  Future<List<Task>> getTasks() async {
    final currentUser = await _userController.getCurrentUser();

    Map<String, dynamic> result = <String, dynamic>{};
    if (currentUser.sellerId == 0) {
      result = await ApiConnection.instance.get(path: constants.queues);
    } else {
      result = await ApiConnection.instance.get(
        path: constants.queues,
        queryParameters: {
          'seller_id': currentUser.sellerId,
        },
      );
    }

    final response = result['response'] as List;
    final list = response.map((e) => Task.fromJson(e)).toList();
    return list;
  }

  Future<List<Log>> getLogs() async {
    final result = await ApiConnection.instance.get(path: constants.logs);
    final response = result['response'] as List;
    final list = response.map((e) => Log.fromJson(e)).toList();
    return list;
  }
}
