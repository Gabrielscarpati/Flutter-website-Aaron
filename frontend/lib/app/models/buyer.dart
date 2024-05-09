import 'package:flutter_website_aaron/app/framework/imodel.dart';

class Buyer implements IModel {
  final int id;
  final String name;
  final String phone;
  final String city;
  final String state;
  final String zip;
  final int current;

  Buyer(
      {required this.name,
      required this.id,
      required this.phone,
      required this.city,
      required this.state,
      required this.zip,
      required this.current});

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'city': city,
      'state': state,
      'zip': zip,
      'current': current,
    };
  }

  factory Buyer.fromJson(Map<String, dynamic> json) {
    return Buyer(
      city: json['city'] ?? '',
      current: json['active'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      state: json['state'] ?? '',
      zip: json['zip'] ?? '',
    );
  }
}
