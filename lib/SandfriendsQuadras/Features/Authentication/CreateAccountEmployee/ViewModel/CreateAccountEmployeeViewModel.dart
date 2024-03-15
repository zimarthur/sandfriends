import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:flutter/material.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../../../Common/Utils/PageStatus.dart';
import '../../../../../Remote/NetworkResponse.dart';
import '../../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/CreateAccountEmployeeRepo.dart';

class CreateAccountEmployeeViewModel extends ChangeNotifier {
  final _createAccountEmployeeRepo = CreateAccountEmployeeRepo();

  String addEmployeeToken = "";
  String email = "";
  String storeName = "";

  TextEditingController createAccountEmployeeFirstNameController =
      TextEditingController();
  TextEditingController createAccountEmployeeLastNameController =
      TextEditingController();
  TextEditingController createAccountEmployeePasswordController =
      TextEditingController();
  TextEditingController createAccountEmployeePasswordConfirmController =
      TextEditingController();
  bool isAbove18 = true;
  bool termsAgree = true;

  final createAccountEmployeeFormKey = GlobalKey<FormState>();

  void initCreateAccountEmployeeViewModel(BuildContext context, String token) {
    addEmployeeToken = token;
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    notifyListeners();
    _createAccountEmployeeRepo
        .validateNewEmployeeToken(context, addEmployeeToken)
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        email = responseBody["Email"];
        storeName = responseBody["StoreName"];
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
        notifyListeners();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            description: response.responseDescription,
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      }
    });
  }

  void createAccountEmployee(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    _createAccountEmployeeRepo
        .createAccountEmployee(
      context,
      addEmployeeToken,
      createAccountEmployeeFirstNameController.text,
      createAccountEmployeeLastNameController.text,
      createAccountEmployeePasswordController.text,
    )
        .then((response) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: response.responseTitle!,
          description: response.responseDescription,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.alert) {
              Navigator.pushNamed(context, '/login');
            }
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
          buttonText: response.responseStatus == NetworkResponseStatus.alert
              ? "Concluído"
              : "Voltar",
        ),
      );
    });
  }

  bool missingTerms() {
    return !isAbove18 || !termsAgree;
  }

  void onTapTermosDeUso(BuildContext context) {
    LinkOpenerManager().openLink(context, termsUse);
  }

  void onTapPoliticaDePrivacidade(BuildContext context) {
    LinkOpenerManager().openLink(context, privacyPolicy);
  }
}
