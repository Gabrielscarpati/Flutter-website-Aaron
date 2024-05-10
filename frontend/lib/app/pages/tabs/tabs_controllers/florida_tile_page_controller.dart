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
    final response =
        await ApiConnection.instance.get<List>(path: constants.buyers);
    final list = response.map((e) => Buyer.fromJson(e)).toList();
    return list;
  }

  Future<List<Warning>> getWarnings() async {
    final response =
        await ApiConnection.instance.get<List>(path: constants.logs);
    final list = response.map((e) => Warning.fromJson(e)).toList();
    return list;
  }
}
