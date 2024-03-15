import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Common/Utils/Constants.dart';
import 'PlayersTableCallback.dart';

class PlayersDataSource extends DataGridSource {
  PlayersDataSource({
    required List<UserStore> players,
    required Function(PlayersTableCallback, UserStore, BuildContext)
        tableCallback,
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
                value: player.gender == null ? "" : player.gender!.name,
              ),
              DataGridCell<String>(
                columnName: 'sport',
                value: player.preferenceSport == null
                    ? ""
                    : player.preferenceSport!.description,
              ),
              DataGridCell<String>(
                columnName: 'rank',
                value: player.rank == null ? "" : player.rank!.name,
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
    UserStore playerRow,
    Function(PlayersTableCallback, UserStore, BuildContext) callback,
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
