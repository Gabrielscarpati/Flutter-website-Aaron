import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:intl/intl.dart';

class Order implements IModel {
  final int id;
  final int parentId;
  final String task;
  final String beginDte;
  final String end;

  Order({
    required this.id,
    required this.parentId,
    required this.task,
    required this.beginDte,
    required this.end,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'begin_dte': beginDte,
      'id': id,
      'task': task,
      'parent_id': parentId,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      parentId: json['parent_id'] ?? '',
      task: json['task'] ?? '',
      beginDte: DateTime.tryParse(json['begin_dte'].toString()) != null
          ? DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['begin_dte']))
          : DateFormat('MM/dd/yyyy')
              .add_jm()
              .format(DateTime.parse(json['begin_dte'])),
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
