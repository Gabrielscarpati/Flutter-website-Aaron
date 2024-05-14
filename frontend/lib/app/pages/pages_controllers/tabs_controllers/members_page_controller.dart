import 'package:flutter_website_aaron/app/models/seller.dart';
import 'package:flutter_website_aaron/app/shared/app_constants.dart';

import '../../../connection/api_connection.dart';

class MembersPageController {
  MembersPageController._();

  static MembersPageController? _instance;

  static MembersPageController get instance {
    _instance ??= MembersPageController._();
    return _instance!;
  }

  final constants = AppConstants.instance;

  Future<List<Seller>> getSellersDetails() async {
    final result =
        await ApiConnection.instance.get(path: constants.sellersDetails);
    final response = result['response'] as List;
    final list = response.map((e) => Seller.fromJson(e)).toList();
    return list;
  }
}
