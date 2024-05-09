import 'package:flutter_website_aaron/app/framwork/imodel.dart';

class Seller implements IModel {
  final String seller;
  final String contactName;
  final String phone;
  final String state;
  final String tradingPartners;
  final int removed;

  Seller(
      {required this.seller,
      required this.contactName,
      required this.phone,
      required this.state,
      required this.tradingPartners,
      required this.removed});

  @override
  Map<String, dynamic> toJson() {
    return {
      'seller': seller,
      'contactName': contactName,
      'phone': phone,
      'state': state,
      'tradingPartners': tradingPartners,
      'removed': removed,
    };
  }
}