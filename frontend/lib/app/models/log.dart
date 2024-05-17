import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Log extends IModel {
  final int id;
  final int taskId;
  final String taskDescription;
  final String date;
  final String error;
  final int buyerId;
  final String buyerName;

  Log({
    required this.id,
    required this.taskId,
    required this.taskDescription,
    required this.date,
    required this.error,
    required this.buyerId,
    required this.buyerName,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'taskDescription': taskDescription,
      'id': id,
      'buyer_id': buyerId,
      'buyer_name': buyerName,
      'error': error,
    };
  }

  factory Log.fromJson(Map<String, dynamic> json) {
    return Log(
      date: DateTime.tryParse(json['created_at'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['created_at']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['created_at'])),
      taskDescription: json['message'],
      id: json['id'] ?? '',
      error: json['category'] ?? '',
      taskId: json['task_id'] ?? '',
      buyerId: json['buyer_id'] ?? -1,
      buyerName: json['buyer_name'] ?? '',
    );
  }
}
