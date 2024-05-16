import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Task implements IModel {
  final int id;
  final String sellerName;
  final int sandbox;
  final String description;
  final String expDte;

  Task({
    required this.id,
    required this.sellerName,
    required this.sandbox,
    required this.description,
    required this.expDte,
  });

  @override
  Map<String, dynamic> toJson() {
    if (sellerName.isNotEmpty) {
      return {
        'name': sellerName,
        'exp_dte': expDte,
        'id': id,
        'task': description,
        'sandbox': sandbox,
      };
    }

    return {
      'exp_dte': expDte,
      'id': id,
      'task': description,
      'sandbox': sandbox,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      sellerName: json['name'] ?? '',
      expDte: DateTime.tryParse(json['exp_dte'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['exp_dte']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['exp_dte'])),
      id: json['id'] ?? '',
      description: json['task'] ?? '',
      sandbox: json['sandbox'] ?? -1,
    );
  }
}
