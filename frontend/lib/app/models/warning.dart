import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Warning extends IModel {
  final String date;
  final String customer;
  final int id;
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

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      date: DateTime.tryParse(json['created_at'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['created_at']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['created_at'])),
      customer: json['category'] ?? '',
      id: json['id'] ?? '',
      description: json['message'],
    );
  }
}
