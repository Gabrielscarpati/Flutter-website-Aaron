import 'package:flutter_website_aaron/app/framework/imodel.dart';

class Order implements IModel {
  final String date;
  final int numberOrder;
  final int document;
  final String sendReceived;
  final String status;

  Order({
    required this.date,
    required this.numberOrder,
    required this.document,
    required this.sendReceived,
    required this.status,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'numberOrder': numberOrder,
      'document': document,
      'sendReceived': sendReceived,
      'status': status,
    };
  }
}
