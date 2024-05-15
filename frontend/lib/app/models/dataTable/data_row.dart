import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/framework/imodel.dart';

DataRow recentFileDataRow(IModel data, {void Function()? onTap}) {
  var cells = data.toJson().entries.map((e) {
    if (e.value is bool) {
      return DataCell(
          e.value ? const Icon(Icons.check) : const Icon(Icons.close));
    } else {
      return DataCell(Text('${e.value}'));
    }
  }).toList();

  if (onTap != null) {
    return DataRow(
        cells: cells,
        onSelectChanged: (tapped) {
          if (tapped != null && tapped) {
            onTap.call();
          }
        });
  }

  return DataRow(
    cells: cells,
  );
}
