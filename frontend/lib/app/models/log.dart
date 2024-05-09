import 'package:flutter_website_aaron/app/framework/imodel.dart';

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
}
