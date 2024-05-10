import 'package:flutter_website_aaron/app/models/order.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';

import '../../../connection/api_connection.dart';

class TransactionHistoryPageController {
  TransactionHistoryPageController._();

  static TransactionHistoryPageController? _instance;

  static TransactionHistoryPageController get instance {
    _instance ??= TransactionHistoryPageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;

  Future<List<Order>> getOrders() async {
    final result = await ApiConnection.instance.get(path: constants.queues);
    final response = result['response'] as List;
    final list = response.map((e) => Order.fromJson(e)).toList();
    return list;
  }

  Future<List<Log>> getLogs() async {
    final result = await ApiConnection.instance.get(path: constants.logs);
    final response = result['response'] as List;
    final list = response.map((e) => Log.fromJson(e)).toList();
    return list;
  }
}
