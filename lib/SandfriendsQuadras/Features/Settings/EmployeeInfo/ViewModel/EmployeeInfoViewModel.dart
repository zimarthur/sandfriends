import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Model/SandfriendsQuadras/Employee.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../Menu/ViewModel/StoreProvider.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../Model/EmployeeDataSource.dart';
import '../Model/EmployeeTableCallbacks.dart';
import '../Repository/EmployeeInfoRepo.dart';
import '../View/AddEmployeeWidget.dart';
import '../View/RenameEmployeeWidget.dart';

class EmployeeInfoViewModel extends ChangeNotifier {
  final employeeInfoRepo = EmployeeInfoRepo();

  List<Employee> employees = [];

  void initEmployeeScreen(BuildContext context) {
    setEmployeesDataSource(context);
  }

  EmployeeDataSource? employeesDataSource;

  void setEmployeesDataSource(BuildContext context) {
    employees.clear();
    Provider.of<StoreProvider>(context, listen: false)
        .employees
        .forEach((employee) {
      employees.add(Employee.copyFrom(employee));
    });
    employeesDataSource = EmployeeDataSource(
      employees: employees,
      tableCallback: tableCallback,
      context: context,
    );
    notifyListeners();
  }

  void tableCallback(
    EmployeeTableCallbacks callbackCode,
    Employee employee,
    BuildContext context,
  ) {
    switch (callbackCode) {
      case EmployeeTableCallbacks.Rename:
        Provider.of<MenuProvider>(context, listen: false).setModalForm(
          RenameEmployeeWidget(
            onRename: (firstName, lastName) => renameEmployee(
              context,
              firstName,
              lastName,
            ),
            onReturn: () =>
                Provider.of<MenuProvider>(context, listen: false).closeModal(),
          ),
        );

        break;
      case EmployeeTableCallbacks.GiveAdmin:
        Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
            "Deseja mesmo conceder acesso de administrador a ${employee.firstName}?",
            "${employee.firstName} terá acesso a todos seus relatórios financeiros",
            () {
          changeEmployeeAdmin(context, employee, true);
        }, () {
          Provider.of<MenuProvider>(context, listen: false).closeModal();
        });

        break;
      case EmployeeTableCallbacks.RemoveAdmin:
        Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
            "Deseja mesmo retirar acessor de administrador de ${employee.firstName}?",
            "", () {
          changeEmployeeAdmin(context, employee, false);
        }, () {
          Provider.of<MenuProvider>(context, listen: false).closeModal();
        });
        break;
      case EmployeeTableCallbacks.RemoveEmployee:
        Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
            "Deseja mesmo remover ${employee.firstName} de sua equipe?", "",
            () {
          removeEmployee(context, employee);
        }, () {
          Provider.of<MenuProvider>(context, listen: false).closeModal();
        });
        break;
    }
  }

  void goToAddEmployee(BuildContext context, EmployeeInfoViewModel viewModel) {
    Provider.of<MenuProvider>(context, listen: false).setModalForm(
      AddEmployeeWidget(
        onAdd: (p0) => addEmployee(context, p0),
        onReturn: () =>
            Provider.of<MenuProvider>(context, listen: false).closeModal(),
      ),
    );
  }

  void closeModal(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  void addEmployee(BuildContext context, String employeeEmail) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    employeeInfoRepo
        .addEmployee(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      employeeEmail,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setEmployeesFromResponse(context, response.responseBody!);
        setEmployeesDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Membro adicionado!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }

  void changeEmployeeAdmin(
    BuildContext context,
    Employee employee,
    bool isAdmin,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    employeeInfoRepo
        .changeEmployeeAdmin(
            context,
            Provider.of<StoreProvider>(context, listen: false)
                .loggedAccessToken,
            employee.idEmployee,
            isAdmin)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setEmployeesFromResponse(context, response.responseBody!);
        setEmployeesDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Sua equipe foi atualizada!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }

  void renameEmployee(
    BuildContext context,
    String firstName,
    String lastName,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    employeeInfoRepo
        .renameEmployee(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      firstName,
      lastName,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setEmployeesFromResponse(context, response.responseBody!);
        setEmployeesDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Seu nome foi atualizado!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }

  void removeEmployee(
    BuildContext context,
    Employee employee,
  ) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    employeeInfoRepo
        .removeEmployee(
      context,
      Provider.of<StoreProvider>(context, listen: false).loggedAccessToken,
      employee.idEmployee,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Provider.of<StoreProvider>(context, listen: false)
            .setEmployeesFromResponse(context, response.responseBody!);
        setEmployeesDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Sua equipe foi atualizada!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(
          response,
        );
      }
    });
  }
}
