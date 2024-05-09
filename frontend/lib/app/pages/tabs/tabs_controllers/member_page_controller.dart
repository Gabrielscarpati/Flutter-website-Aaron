import 'package:flutter_website_aaron/app/models/seller.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';

import '../../../connection/api_connection.dart';

class MemberPageController {
  MemberPageController._();

  static MemberPageController? _instance;

  static MemberPageController get instance {
    _instance ??= MemberPageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;

  Future<List<Seller>> getSellers() async {
    final response =
        await ApiConnection.instance.get<List>(path: constants.sellers);
    final list = response.map((e) => Seller.fromJson(e)).toList();
    return list;
  }
}
