import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Players/Model/PlayersTableCallback.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/Model/EmployeeTableCallbacks.dart';
import 'package:sandfriends_web/SharedComponents/Model/Employee.dart';
import 'package:sandfriends_web/SharedComponents/Model/Player.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayersDataSource extends DataGridSource {
  PlayersDataSource({
    required List<Player> players,
    required Function(PlayersTableCallback, Player, BuildContext) tableCallback,
    required BuildContext context,
  }) {
    _players = players
        .map<DataGridRow>(
          (player) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'name',
                value: "${player.firstName} ${player.lastName}",
              ),
              DataGridCell<String>(
                columnName: 'phoneNumber',
                value: player.phoneNumber,
              ),
              DataGridCell<String>(
                columnName: 'gender',
                value: player.gender == null ? "" : player.gender!.genderName,
              ),
              DataGridCell<String>(
                columnName: 'sport',
                value: player.sport == null ? "" : player.sport!.description,
              ),
              DataGridCell<String>(
                columnName: 'rank',
                value: player.rank == null ? "" : player.rank!.rankName,
              ),
              DataGridCell<Widget>(
                columnName: 'in_app',
                value: player.isStorePlayer
                    ? Container()
                    : Center(
                        child: SvgPicture.asset(
                        r"assets/icon/phone_hand.svg",
                        color: primaryBlue,
                      )),
              ),
              DataGridCell<Widget>(
                columnName: 'action',
                value: player.isStorePlayer
                    ? action(
                        player,
                        tableCallback,
                        context,
                      )
                    : Container(),
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _players = [];

  @override
  List<DataGridRow> get rows => _players;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 48,
              child: dataGridCell.value is Widget
                  ? dataGridCell.value
                  : Text(
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
      }).toList(),
    );
  }

  Widget action(
    Player playerRow,
    Function(PlayersTableCallback, Player, BuildContext) callback,
    BuildContext context,
  ) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(defaultBorderRadius),
      ),
      icon: SvgPicture.asset(
        r'assets/icon/three_dots.svg',
        height: 14,
        color: textDarkGrey,
      ),
      tooltip: "",
      itemBuilder: (BuildContext context) {
        List<PopupMenuItem> menuItems = [];
        if (playerRow.isStorePlayer) {
          menuItems = [
            PopupMenuItem(
              value: PlayersTableCallback.Edit,
              child: Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/edit.svg",
                    color: textDarkGrey,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Text(
                    'Editar',
                    style: TextStyle(
                      color: textDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: PlayersTableCallback.Delete,
              child: Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/delete.svg",
                    color: red,
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  Text(
                    'Deletar',
                    style: TextStyle(
                      color: red,
                    ),
                  ),
                ],
              ),
            ),
          ];
        }
        return menuItems;
      },
      elevation: 2,
      onSelected: (value) => callback(value, playerRow, context),
    );
  }
}
