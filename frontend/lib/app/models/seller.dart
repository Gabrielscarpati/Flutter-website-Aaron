import 'package:flutter_website_aaron/app/framework/imodel.dart';

class Seller implements IModel {
  final int id;
  final String name;
  final String phone;
  final String state;
  final int tradingPartners;
  final int removed;

  Seller(
      {required this.id,
      required this.name,
      required this.phone,
      required this.state,
      required this.tradingPartners,
      required this.removed});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'state': state,
      'trading_partners': tradingPartners,
      'removed': removed,
    };
  }

  factory Seller.fromJson(Map<String, dynamic> json) {
    return Seller(
      id: json['id'] ?? -1,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      state: json['state'] ?? '',
      tradingPartners: json['trading_partners'] ?? 0,
      removed: json['removed'] ?? 0,
    );
  }
}
