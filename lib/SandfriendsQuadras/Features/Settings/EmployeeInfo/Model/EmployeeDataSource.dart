import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/Model/EmployeeTableCallbacks.dart';
import 'package:sandfriends_web/SharedComponents/Model/Employee.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({
    required List<Employee> employees,
    required Function(EmployeeTableCallbacks, Employee, BuildContext)
        tableCallback,
    required BuildContext context,
  }) {
    _loggedUser = employees.firstWhere((employee) => employee.isLoggedUser);
    _employees = employees
        .map<DataGridRow>(
          (employee) => DataGridRow(
            cells: [
              DataGridCell<String>(
                columnName: 'name',
                value:
                    "${employee.firstName} ${employee.lastName}${employee.isCourtOwner ? " (dono)" : ""}",
              ),
              DataGridCell<String>(
                columnName: 'email',
                value: employee.email,
              ),
              DataGridCell<Widget>(
                columnName: 'date',
                value: employee.registrationDate == null
                    ? Center(
                        child: Text(
                          "Aguard. confirmação",
                          style: TextStyle(color: secondaryYellow),
                        ),
                      )
                    : Center(
                        child: Text(
                          DateFormat('dd/MM/yy')
                              .format(employee.registrationDate!),
                        ),
                      ),
              ),
              DataGridCell<Widget>(
                columnName: 'admin',
                value: employee.admin
                    ? admin()
                    : const Center(
                        child: Text("-"),
                      ),
              ),
              DataGridCell<Widget>(
                columnName: 'action',
                value: action(
                  employee,
                  tableCallback,
                  context,
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  List<DataGridRow> _employees = [];
  Employee? _loggedUser;

  @override
  List<DataGridRow> get rows => _employees;

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
    Employee employeeRow,
    Function(EmployeeTableCallbacks, Employee, BuildContext) callback,
    BuildContext context,
  ) {
    List<PopupMenuItem> menuItems = [];
    if (_loggedUser!.isCourtOwner) {
      if (employeeRow.isCourtOwner) {
        //dono alterando suas proprias infos
        menuItems = [
          const PopupMenuItem(
            value: EmployeeTableCallbacks.Rename,
            child: Text(
              'Alterar meu nome',
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ),
        ];
      } else if (employeeRow.admin) {
        //dono alterabndo info de um admin
        menuItems = [
          const PopupMenuItem(
            value: EmployeeTableCallbacks.RemoveAdmin,
            child: Text(
              'Retirar admin.',
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ),
          const PopupMenuItem(
            value: EmployeeTableCallbacks.RemoveEmployee,
            child: Text(
              'Remover funcionário',
              style: TextStyle(
                color: red,
              ),
            ),
          ),
        ];
      } else {
        //dono alterando info de funcion.
        menuItems = [
          const PopupMenuItem(
            value: EmployeeTableCallbacks.GiveAdmin,
            child: Text(
              'Conceder admin.',
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ),
          const PopupMenuItem(
            value: EmployeeTableCallbacks.RemoveEmployee,
            child: Text(
              'Remover funcionário',
              style: TextStyle(
                color: red,
              ),
            ),
          ),
        ];
      }
    } else {
      if (employeeRow.isLoggedUser) {
        //admin ou func. trocando sua propria informação
        menuItems = [
          const PopupMenuItem(
            value: EmployeeTableCallbacks.Rename,
            child: Text(
              'Alterar meu nome',
              style: TextStyle(
                color: textDarkGrey,
              ),
            ),
          ),
        ];
      } else {
        return Container();
      }
    }
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
      itemBuilder: (BuildContext context) => menuItems,
      elevation: 2,
      onSelected: (value) => callback(value, employeeRow, context),
    );
  }
}

Widget admin() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgPicture.asset(
        r"assets/icon/user.svg",
        color: primaryBlue,
      ),
      const SizedBox(
        width: defaultPadding / 2,
      ),
      const Text(
        "Admin.",
        style: TextStyle(color: textBlue, fontWeight: FontWeight.bold),
      )
    ],
  );
}
