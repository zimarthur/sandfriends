import 'package:flutter/material.dart';
import '../../../../../../Common/Utils/Constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../SharedComponents/Model/Reward.dart';
import 'package:intl/intl.dart';

class RewardsDataSource extends DataGridSource {
  RewardsDataSource({required List<Reward> rewards}) {
    _rewardss = rewards
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(
                  columnName: 'date',
                  value: DateFormat('dd/MM/yy').format(e.claimedDate)),
              DataGridCell<String>(columnName: 'hour', value: e.hour),
              DataGridCell<String>(
                  columnName: 'player', value: e.player.firstName),
              DataGridCell<String>(
                  columnName: 'reward', value: e.rewardItem.description),
            ]))
        .toList();
  }

  List<DataGridRow> _rewardss = [];

  @override
  List<DataGridRow> get rows => _rewardss;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(defaultPadding),
            child: Text(
              dataGridCell.value.toString(),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: divider,
          ),
        ],
      );
    }).toList());
  }
}
