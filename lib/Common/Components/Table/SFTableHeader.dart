import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Utils/Constants.dart';

GridColumn SFTableHeader(String columnName, String columnTitle) {
  return GridColumn(
    columnName: columnName,
    autoFitPadding: const EdgeInsets.symmetric(horizontal: 10.0),
    label: Column(
      children: [
        Expanded(
          child: Container(
            alignment: Alignment.center,
            child: Text(
              columnTitle,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: textDarkGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Container(
          height: 2,
          width: double.infinity,
          color: divider,
        ),
      ],
    ),
  );
}
