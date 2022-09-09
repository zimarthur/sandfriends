import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'dart:convert';

import '../../widgets/SF_Dropdown.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

final _userDetailFormKey = GlobalKey<FormState>();

class UserDetailScreen extends StatefulWidget {
  static const routeName = 'user_detail';

  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreen();
}

class _UserDetailScreen extends State<UserDetailScreen> {
  bool showModal = false;

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
        if (Provider.of<UserProvider>(context, listen: false).user!.FirstName !=
            null) {
          firstNameController.text =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .FirstName!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.LastName !=
            null) {
          lastNameController.text =
              Provider.of<UserProvider>(context, listen: false).user!.LastName!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.Gender !=
            null) {
          genderValue =
              Provider.of<UserProvider>(context, listen: false).user!.Gender!;
        }
        if (Provider.of<UserProvider>(context, listen: false)
                .user!
                .PhoneNumber !=
            null) {
          phoneNumberController.text =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .PhoneNumber!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.Birthday !=
            null) {
          birthdayController.text =
              Provider.of<UserProvider>(context, listen: false).user!.Birthday!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.Height !=
            null) {
          heightController.text =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .Height
                  .toString();
        }
        if (Provider.of<UserProvider>(context, listen: false)
                .user!
                .HandPreference !=
            null) {
          handPreferenceValue =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .HandPreference!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.Rank !=
            null) {
          rankValue =
              Provider.of<UserProvider>(context, listen: false).user!.Rank!;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      showModal: showModal,
      titleText: "Meu Perfil",
      onTapReturn: () =>
          context.goNamed('home', params: {'initialPage': 'user_screen'}),
      appBarType: AppBarType.Secondary,
      rightWidget: Container(
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
      child: Container(
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
        Provider.of<UserProvider>(context, listen: false)
            .userFromJson(responseBody);
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
