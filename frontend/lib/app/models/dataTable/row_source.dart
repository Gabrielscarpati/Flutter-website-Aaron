import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/framework/imodel.dart';
import 'package:flutter_website_aaron/app/models/dataTable/data_row.dart';

class RowSource<T extends IModel> extends DataTableSource {
  final List<T> dataList;
  final int count;
  final Function(T)? onTap;
  RowSource({
    required this.dataList,
    required this.count,
    this.onTap,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      if (onTap != null) {
        return recentFileDataRow(
          dataList[index],
          onTap: () => onTap!(dataList[index]),
        ); //
      }

      return recentFileDataRow(
        dataList[index],
      ); // Chame a função aqui
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
