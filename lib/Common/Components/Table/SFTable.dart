import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../Utils/Constants.dart';

class SFTable extends StatefulWidget {
  double height;
  double width;
  List<GridColumn> headers;
  DataGridSource source;

  SFTable({
    super.key,
    required this.height,
    required this.width,
    required this.headers,
    required this.source,
  });

  @override
  State<SFTable> createState() => _SFTableState();
}

class _SFTableState extends State<SFTable> {
  @override
  Widget build(BuildContext context) {
    double columnWidth = widget.width / widget.headers.length < 100
        ? 100
        : widget.width / widget.headers.length;
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        border: Border.all(color: divider, width: 2),
        color: secondaryPaper,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            headerColor: secondaryBack,
          ),
          child: SfDataGrid(
            columnWidthMode: ColumnWidthMode.fill,
            headerGridLinesVisibility: GridLinesVisibility.none,
            gridLinesVisibility: GridLinesVisibility.none,
            source: widget.source,
            columns: widget.headers,
          ),
        ),
      ),
    );
  }
}
