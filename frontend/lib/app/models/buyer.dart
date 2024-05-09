import 'package:flutter_website_aaron/app/framwork/imodel.dart';

class Buyer implements IModel {
  final String name;
  final String id;
  final String phone;
  final String city;
  final String state;
  final int zip;
  final bool current;

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
      'name': name,
      'id': id,
      'phone': phone,
      'city': city,
      'state': state,
      'zip': zip,
      'current': current,
    };
  }
}