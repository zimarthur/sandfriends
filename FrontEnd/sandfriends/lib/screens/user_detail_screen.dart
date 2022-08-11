import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../widgets/SF_Dropdown.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';

final _userDetailFormKey = GlobalKey<FormState>();

class UserDetailScreen extends StatefulWidget {
  static const routeName = 'user_detail';

  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreen();
}

class _UserDetailScreen extends State<UserDetailScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(000) 00000-00000');
  final TextEditingController birthdayController =
      MaskedTextController(mask: '00/00/0000');
  final TextEditingController heightController =
      MaskedTextController(mask: '0,00');

  String? genderValue;
  String? handPreferenceValue;
  String? rankValue;

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
        if (Provider.of<User>(context, listen: false).Birthday != null) {
          birthdayController.text =
              Provider.of<User>(context, listen: false).Birthday!;
        }
        if (Provider.of<User>(context, listen: false).Height != null) {
          heightController.text =
              Provider.of<User>(context, listen: false).Height.toString();
        }
        if (Provider.of<User>(context, listen: false).HandPreference != null) {
          handPreferenceValue =
              Provider.of<User>(context, listen: false).HandPreference!;
        }
        if (Provider.of<User>(context, listen: false).Rank != null) {
          rankValue = Provider.of<User>(context, listen: false).Rank!;
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
                Container(
                  width: width * 0.2,
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () {
                      context.goNamed('home',
                          params: {'initialPage': 'user_screen'});
                    },
                    child: SvgPicture.asset(
                      r'assets\icon\arrow_left.svg',
                      height: 8.7,
                      width: 13.2,
                    ),
                  ),
                ),
                Text(
                  "Meu Perfil",
                  style: TextStyle(
                    color: AppTheme.colors.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: width * 0.2,
                  child: SFButton(
                    buttonLabel: "Salvar",
                    buttonType: ButtonType.Primary,
                    onTap: () {
                      if (_userDetailFormKey.currentState?.validate() == true) {
                        print(rankValue);
                        print(genderValue);
                        updateUser(context);
                      } else {}
                    },
                  ),
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
          key: _userDetailFormKey,
          child: ListView(
            children: [
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
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
                    labelText: "Gônero",
                    items: const ["Masculino", "Feminino"],
                    validator: genderValidator,
                  )),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SFTextField(
                controller: birthdayController,
                pourpose: TextFieldPourpose.Numeric,
                labelText: "Aniversário",
                validator: birthdayValidator,
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SFTextField(
                controller: heightController,
                pourpose: TextFieldPourpose.Numeric,
                labelText: "Altura",
                validator: heightValidator,
              ),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SizedBox(
                  width: double.infinity,
                  child: SFDropdown(
                    controller: handPreferenceValue,
                    labelText: "Mão/pé de preferência",
                    items: const ["Esquerda", "Direita"],
                    validator: (value) {
                      if (value != null) {
                        handPreferenceValue = value;
                      }

                      return null;
                    },
                  )),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
              SizedBox(
                  width: double.infinity,
                  child: SFDropdown(
                    controller: rankValue,
                    labelText: "Rank",
                    items: const ["Inic.", "D", "C", "B", "A"],
                    validator: (value) {
                      if (value != null) {
                        rankValue = value;
                      }
                      return null;
                    },
                  )),
              Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateUser(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.put(
        Uri.parse('https://www.sandfriends.com.br/UpdateUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'AccessToken': accessToken,
          'FirstName': firstNameController.text,
          'LastName': lastNameController.text,
          'PhoneNumber': PhonenumberConverter(phoneNumberController.text),
          'Gender': genderValue!,
          'Birthday': birthdayController.text.isEmpty
              ? ""
              : DateTimeConverter(birthdayController.text),
          'Height': heightController.text.isEmpty
              ? ""
              : heightController.text.replaceAll(",", "."),
          'HandPreference':
              handPreferenceValue == null ? "" : handPreferenceValue!,
          'Rank': rankValue == null ? "" : rankValue!,
          'Photo': "",
        }),
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = json.decode(response.body);
        Provider.of<User>(context, listen: false).FirstName =
            responseBody['FirstName'];
        Provider.of<User>(context, listen: false).LastName =
            responseBody['LastName'];
        Provider.of<User>(context, listen: false).Gender =
            responseBody['Gender'];
        Provider.of<User>(context, listen: false).PhoneNumber =
            responseBody['PhoneNumber'];
        Provider.of<User>(context, listen: false).Birthday =
            responseBody['Birthday'];
        Provider.of<User>(context, listen: false).Rank = responseBody['Rank'];
        Provider.of<User>(context, listen: false).Height =
            responseBody['Height'];
        Provider.of<User>(context, listen: false).HandPreference =
            responseBody['HandPreference'];
        Provider.of<User>(context, listen: false).Photo = responseBody['Photo'];
        context.goNamed('home', params: {'initialPage': 'user_screen'});
      } else {
        print("deu ruim");
      }
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
      if (value.length != 16) {
        return "formato incorreto";
      } else {
        return null;
      }
    }
  }

  String? birthdayValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else {
      if (value.length != 10) {
        return "formato incorreto";
      } else {
        String convertedDatetime = DateTimeConverter(value);
        if (DateTime.tryParse(convertedDatetime) == null) {
          return "data não existe";
        } else {
          return null;
        }
      }
    }
  }

  String? heightValidator(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else {
      if (value.length < 0 || value.length < 3) {
        return "valor inválido";
      } else {
        return null;
      }
    }
  }

  String DateTimeConverter(String rawDateTime) {
    String day = rawDateTime.substring(0, 2);
    String month = rawDateTime.substring(3, 5);
    String year = rawDateTime.substring(6, 10);
    return year + "-" + month + "-" + day;
  }

  String PhonenumberConverter(String rawPhonenumber) {
    return rawPhonenumber.substring(1, 4) +
        rawPhonenumber.substring(6, 11) +
        rawPhonenumber.substring(12, 16);
  }
}
