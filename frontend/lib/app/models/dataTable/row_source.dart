import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/framwork/imodel.dart';
import 'package:flutter_website_aaron/app/models/dataTable/data_row.dart';

class RowSource<T extends IModel> extends DataTableSource {
  final List<T> dataList;
  final int count;
  RowSource({
    required this.dataList,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(dataList[index]); // Chame a função aqui
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}