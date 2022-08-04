import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/enums.dart';
import '../../widgets/SF_Dropdown.dart';
import '../../providers/login_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';

final _newUserFormKey = GlobalKey<FormState>();

class NewUserForm extends StatefulWidget {
  static const routeName = 'user_detail';

  NewUserForm({Key? key}) : super(key: key);

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      new MaskedTextController(mask: '(000) 00000-00000');

  String? genderValue;

  User? userInfo;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        if (Provider.of<User>(context, listen: false).FirstName != null) {
          firstNameController.text =
              Provider.of<User>(context, listen: false).FirstName!;
        }
        if (Provider.of<User>(context, listen: false).LastName != null) {
          lastNameController.text =
              Provider.of<User>(context, listen: false).LastName!;
        }
        if (Provider.of<User>(context, listen: false).Gender != null) {
          genderValue = Provider.of<User>(context, listen: false).Gender!;
        }
        if (Provider.of<User>(context, listen: false).PhoneNumber != null) {
          phoneNumberController.text =
              Provider.of<User>(context, listen: false).PhoneNumber!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: SafeArea(
          child: Container(
            color: AppTheme.colors.secondaryBack,
            padding: const EdgeInsets.all(17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    context.goNamed('new_user_welcome');
                  },
                  child: SvgPicture.asset(
                    r'assets\icon\arrow_left.svg',
                    height: 8.7,
                    width: 13.2,
                  ),
                ),
                Text(
                  "Meu Perfil",
                  style: TextStyle(
                    color: AppTheme.colors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
                  r'assets\icon\info.svg',
                  height: 15,
                  width: 15,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: width * 0.05),
        color: AppTheme.colors.secondaryBack,
        width: double.infinity,
        child: Form(
          key: _newUserFormKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: height * 0.02),
                child: Text(
                  "Pra começar, fale um pouco sobre você.",
                  style: TextStyle(
                      color: AppTheme.colors.textBlue,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      height: 1.4),
                ),
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.02)),
              Text(
                "Quanto mais completo estiver o seu perfil, mais precisa será a sua busca por partidas personalizadas.",
                style: TextStyle(
                    color: AppTheme.colors.textDarkGrey,
                    fontWeight: FontWeight.w300,
                    fontSize: 14,
                    height: 1.7),
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.04)),
              SFTextField(
                controller: firstNameController,
                pourpose: TextFieldPourpose.Standard,
                labelText: "Nome",
                validator: nameValidator,
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SFTextField(
                controller: lastNameController,
                pourpose: TextFieldPourpose.Standard,
                labelText: "Sobrenome",
                validator: lastNameValidator,
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SFTextField(
                controller: phoneNumberController,
                pourpose: TextFieldPourpose.Numeric,
                labelText: "Celular",
                validator: phoneValidator,
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SizedBox(
                  width: double.infinity,
                  child: SFDropdown(
                    controller: genderValue,
                    labelText: "Gênero",
                    items: const ["Masculino", "Feminino"],
                    validator: genderValidator,
                  )),
              Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.04),
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height * 0.05,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                  child: SFButton(
                    buttonLabel: "Começar",
                    buttonType: ButtonType.Primary,
                    onTap: () {
                      if (_newUserFormKey.currentState?.validate() == true) {
                        addUserInfo(context);
                      } else {}
                      /*Provider.of<User>(context, listen: false).FirstName =
                              firstNameController.text;
                          Provider.of<User>(context, listen: false).LastName =
                              lastNameController.text;
                          Provider.of<User>(context, listen: false).Gender =
                              genderValue;
                          Provider.of<User>(context, listen: false).PhoneNumber =
                              phoneNumberController.text;
                          Provider.of<User>(context, listen: false).Birthday =
                              birthdayController.text;*/
                      //context.goNamed("new_user_form2");
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> addUserInfo(BuildContext context) async {
    final storage = new FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/AddUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'AccessToken': accessToken,
          'FirstName': firstNameController.text,
          'LastName': lastNameController.text,
          'PhoneNumber': PhonenumberConverter(phoneNumberController.text),
          'Gender': genderValue!,
        }),
      );
      context.goNamed('home');
    }
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "informe seu nome";
    } else {
      return null;
    }
  }

  String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "informe seu sobrenome";
    } else {
      return null;
    }
  }

  String? genderValidator(String? value) {
    if (value == null) {
      return "informe seu gênero";
    } else {
      genderValue = value;
      return null;
    }
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "informe seu celular";
    } else {
      print(value.length);
      if (value.length != 16) {
        return "formato incorreto";
      } else {
        return null;
      }
    }
  }

  String PhonenumberConverter(String rawPhonenumber) {
    return rawPhonenumber.substring(1, 4) +
        rawPhonenumber.substring(6, 11) +
        rawPhonenumber.substring(12, 16);
  }
}
