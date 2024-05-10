import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Log extends IModel {
  final String date;
  final String taskDescription;
  final String id;
  final String error;

  Log({
    required this.date,
    required this.taskDescription,
    required this.id,
    required this.error,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'taskDescription': taskDescription,
      'id': id,
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
      taskDescription: json['category'],
      id: json['id'] ?? '',
      error: json['message'] ?? '',
    );
  }
}
