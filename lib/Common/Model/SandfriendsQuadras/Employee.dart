import 'package:intl/intl.dart';

class Employee {
  int idEmployee;
  String firstName;
  String lastName;
  String email;
  bool admin;
  DateTime? registrationDate;
  bool isLoggedUser;
  bool isCourtOwner;
  bool allowNotifications;

  String get fullName => "$firstName $lastName";

  Employee({
    required this.idEmployee,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.admin,
    required this.registrationDate,
    this.isLoggedUser = false,
    required this.isCourtOwner,
    required this.allowNotifications,
  });

  factory Employee.fromJson(Map<String, dynamic> parsedJson) {
    return Employee(
      idEmployee: parsedJson["IdEmployee"],
      firstName: parsedJson["FirstName"] ?? "",
      lastName: parsedJson["LastName"] ?? "",
      email: parsedJson["Email"],
      admin: parsedJson["Admin"],
      registrationDate: parsedJson["EmailConfirmationDate"] == null
          ? null
          : DateFormat("dd/MM/yyyy").parse(parsedJson["EmailConfirmationDate"]),
      isLoggedUser: false,
      isCourtOwner: parsedJson["StoreOwner"],
      allowNotifications: parsedJson["AllowNotifications"] ?? false,
    );
  }

  factory Employee.copyFrom(Employee refEmployee) {
    return Employee(
      idEmployee: refEmployee.idEmployee,
      firstName: refEmployee.firstName,
      lastName: refEmployee.lastName,
      email: refEmployee.email,
      admin: refEmployee.admin,
      registrationDate: refEmployee.registrationDate,
      isCourtOwner: refEmployee.isCourtOwner,
      isLoggedUser: refEmployee.isLoggedUser,
      allowNotifications: refEmployee.allowNotifications,
    );
  }
}
