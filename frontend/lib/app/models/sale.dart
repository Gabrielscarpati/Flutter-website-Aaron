import 'package:flutter_website_aaron/app/framework/imodel.dart';

class Sale implements IModel {
  final String seller;
  final String contactName;
  final String phone;
  final String state;
  final int tradingPartners;
  final int removed;

  Sale(
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
      'contact_name': contactName,
      'phone': phone,
      'state': state,
      'trading_partners': tradingPartners,
      'removed': removed,
    };
  }

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      seller: json['name'] ?? '',
      contactName: json['contact_name'] ?? '',
      phone: json['phone'] ?? '',
      removed: json['removed'] ?? '',
      state: json['state'] ?? '',
      tradingPartners: json['trading_partners'] ?? '',
    );
  }
}
