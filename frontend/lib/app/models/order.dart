import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Order implements IModel {
  final int id;
  final int parentId;
  final String task;
  final String start;
  final String end;

  Order({
    required this.id,
    required this.parentId,
    required this.task,
    required this.start,
    required this.end,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'task': task,
      'start': start,
      'end': end,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      parentId: json['parent_id'] ?? '',
      task: json['task'] ?? '',
      start: DateTime.tryParse(json['start'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['start']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['start'])),
      end: DateTime.tryParse(json['end'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['end']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['end'])),
    );
  }
}
