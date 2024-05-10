import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';

import '../../../connection/api_connection.dart';

class FloridaTilePageController {
  FloridaTilePageController._();

  static FloridaTilePageController? _instance;

  static FloridaTilePageController get instance {
    _instance ??= FloridaTilePageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;

  Future<List<Buyer>> getBuyers() async {
    final result = await ApiConnection.instance.get(path: constants.buyers);
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
