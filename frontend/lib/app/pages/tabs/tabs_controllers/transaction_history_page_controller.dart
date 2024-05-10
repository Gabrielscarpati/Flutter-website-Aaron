import 'package:flutter_website_aaron/app/models/order.dart';
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
    final response =
        await ApiConnection.instance.get<List>(path: constants.orders);
    final list = response.map((e) => Order.fromJson(e)).toList();
    return list;
  }
}
