import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Order implements IModel {
  final int id;
  final String sellerName;
  final int sandbox;
  final String task;
  final String expDte;

  Order({
    required this.id,
    required this.sellerName,
    required this.sandbox,
    required this.task,
    required this.expDte,
  });

  @override
  Map<String, dynamic> toJson() {
    if (sellerName.isNotEmpty) {
      return {
        'name': sellerName,
        'exp_dte': expDte,
        'id': id,
        'task': task,
        'sandbox': sandbox,
      };
    }

    return {
      'exp_dte': expDte,
      'id': id,
      'task': task,
      'sandbox': sandbox,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      sellerName: json['name'] ?? '',
      expDte: DateTime.tryParse(json['exp_dte'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['exp_dte']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['exp_dte'])),
      id: json['id'] ?? '',
      task: json['task'] ?? '',
      sandbox: json['sandbox'] ?? -1,
    );
  }
}
