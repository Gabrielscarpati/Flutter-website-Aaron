import 'package:flutter_website_aaron/app/framework/imodel.dart';

class Warning extends IModel {
  final String date;
  final String customer;
  final String id;
  final String description;

  Warning(
      {required this.date,
      required this.customer,
      required this.id,
      required this.description});

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'customer': customer,
      'id': id,
      'description': description,
    };
  }
}
