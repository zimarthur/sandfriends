import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/models/match_counter.dart';
import 'package:sandfriends/oldApp/providers/categories_provider.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'dart:convert';

import '../../../SharedComponents/Model/City.dart';
import '../../models/region.dart';
import '../../providers/user_provider.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';

final _newUserFormKey = GlobalKey<FormState>();

class NewUserForm extends StatefulWidget {
  const NewUserForm({Key? key}) : super(key: key);

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(000) 00000-00000');

  List<Region> allRegions = [];

  bool termsAgreeValue = false;

  bool showModal = false;
  Widget modalWidget = Container();
  bool isLoading = true;

  bool isFormValid = false;

  User? dum;
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).user = User(
        idUser: -1, firstName: "", lastName: "", photo: "", email: "email");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        dum = Provider.of<UserProvider>(context, listen: false).user;
        if (Provider.of<UserProvider>(context, listen: false).user!.firstName !=
            null) {
          firstNameController.text =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .firstName!;
        }
        if (Provider.of<UserProvider>(context, listen: false).user!.lastName !=
            null) {
          lastNameController.text =
              Provider.of<UserProvider>(context, listen: false).user!.lastName!;
        }
        if (Provider.of<UserProvider>(context, listen: false)
                .user!
                .phoneNumber !=
            null) {
          phoneNumberController.text =
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .phoneNumber!;
        }
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      titleText: "Meu Perfil",
      onTapReturn: () {
        context.goNamed('new_user_welcome');
      },
      appBarType: AppBarType.Secondary,
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      child: isLoading
          ? Container(
              color: AppTheme.colors.primaryBlue.withOpacity(0.3),
              child: const Center(
                child: SFLoading(),
              ),
            )
          : Container(
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
                    SFButton(
                      textPadding:
                          EdgeInsets.symmetric(vertical: height * 0.01),
                      buttonLabel: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user ==
                                  null ||
                              Provider.of<UserProvider>(context, listen: false)
                                      .user!
                                      .preferenceSport ==
                                  null
                          ? "Selecione seu esporte de preferência"
                          : Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .preferenceSport!
                              .description,
                      buttonType: ButtonType.Secondary,
                      onTap: () {
                        setState(() {
                          modalWidget = Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.04,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: height * 0.05,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                      "Selecione seu esporte de preferência",
                                      style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.3,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: Provider.of<CategoriesProvider>(
                                            context,
                                            listen: false)
                                        .sports
                                        .length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .indexEditModal = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              bottom: height * 0.02),
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.02,
                                              horizontal: width * 0.05),
                                          decoration: BoxDecoration(
                                            color:
                                                AppTheme.colors.secondaryBack,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                              color: index ==
                                                      Provider.of<UserProvider>(
                                                              context)
                                                          .indexEditModal
                                                  ? AppTheme.colors.primaryBlue
                                                  : AppTheme
                                                      .colors.textLightGrey,
                                              width: index ==
                                                      Provider.of<UserProvider>(
                                                              context)
                                                          .indexEditModal
                                                  ? 2
                                                  : 1,
                                            ),
                                          ),
                                          child: Text(
                                            Provider.of<CategoriesProvider>(
                                                    context,
                                                    listen: false)
                                                .sports[index]
                                                .description,
                                            style: TextStyle(
                                                color: index ==
                                                        Provider.of<UserProvider>(
                                                                context)
                                                            .indexEditModal
                                                    ? AppTheme.colors.textBlue
                                                    : AppTheme
                                                        .colors.textDarkGrey),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SFButton(
                                    buttonLabel: "Concluído",
                                    buttonType: ButtonType.Primary,
                                    textPadding: EdgeInsets.symmetric(
                                      vertical: height * 0.02,
                                    ),
                                    onTap: () {
                                      Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user!
                                              .preferenceSport =
                                          Provider.of<CategoriesProvider>(
                                                  context,
                                                  listen: false)
                                              .sports[Provider.of<UserProvider>(
                                                  context,
                                                  listen: false)
                                              .indexEditModal];
                                      setState(() {
                                        showModal = false;
                                        formValidation();
                                      });
                                    })
                              ],
                            ),
                          );
                          showModal = true;
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    SFButton(
                      iconFirst: true,
                      textPadding:
                          EdgeInsets.symmetric(vertical: height * 0.01),
                      buttonLabel: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .user!
                                  .city ==
                              null
                          ? "Selecione sua cidade"
                          : "${Provider.of<UserProvider>(context, listen: false).user!.city!.city} / ${Provider.of<UserProvider>(context, listen: false).user!.city!.state!.uf}",
                      buttonType: ButtonType.Secondary,
                      iconPath: r"assets\icon\location_ping.svg",
                      onTap: () {
                        setState(() {
                          showModal = false;
                          isLoading = true;
                        });
                        GetAllCities(context).then((value) {
                          setState(() {
                            modalWidget = SizedBox(
                              height: height * 0.7,
                              child: ListView.builder(
                                itemCount: allRegions.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ExpansionTile(
                                    title: Text(
                                      allRegions[index].state,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    children: allRegions[index]
                                        .cities
                                        .map(
                                          (city) => InkWell(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: height * 0.01),
                                              child: Text(city.city),
                                            ),
                                            onTap: () {
                                              setState(() {
                                                for (var region in allRegions) {
                                                  if (region.state ==
                                                      allRegions[index].state) {
                                                    for (var cityList
                                                        in region.cities) {
                                                      if (cityList.city ==
                                                          city.city) {
                                                        Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .user!
                                                            .city = City(
                                                          cityId:
                                                              cityList.cityId,
                                                          city: cityList.city,
                                                          state: Region(
                                                              idState:
                                                                  allRegions[
                                                                          index]
                                                                      .idState,
                                                              state: allRegions[
                                                                      index]
                                                                  .state,
                                                              uf: allRegions[
                                                                      index]
                                                                  .uf),
                                                        );
                                                      }
                                                    }
                                                  }
                                                }
                                                formValidation();
                                                showModal = false;
                                              });
                                            },
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            );
                            isLoading = false;
                            showModal = true;
                          });
                        });
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                    InkWell(
                      onTap: () {
                        setState(() {
                          termsAgreeValue = !termsAgreeValue;
                          formValidation();
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                              value: termsAgreeValue,
                              fillColor: MaterialStateProperty.all<Color>(
                                  AppTheme.colors.primaryBlue),
                              onChanged: (value) {
                                setState(() {
                                  termsAgreeValue = value!;
                                });
                              }),
                          RichText(
                            text: TextSpan(
                              text: 'Eu li e concordo com os  ',
                              style: TextStyle(
                                  color: AppTheme.colors.textDarkGrey),
                              children: [
                                TextSpan(
                                    text: 'termos de uso',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.colors.textBlue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        print('Terms of Service"');
                                      }),
                                const TextSpan(text: "."),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: height * 0.04),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: height * 0.05,
                        padding: EdgeInsets.symmetric(horizontal: width * 0.14),
                        child: SFButton(
                          buttonLabel: "Começar",
                          buttonType: isFormValid
                              ? ButtonType.Primary
                              : ButtonType.Disabled,
                          onTap: () {
                            if (isFormValid) {
                              if (_newUserFormKey.currentState?.validate() ==
                                  true) {
                                addUserInfo(context);
                              }
                            }
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

  void formValidation() {
    if (Provider.of<UserProvider>(context, listen: false).user!.city != null &&
        Provider.of<UserProvider>(context, listen: false)
                .user!
                .preferenceSport !=
            null &&
        termsAgreeValue == true) {
      isFormValid = true;
    } else {
      isFormValid = false;
    }
  }

  Future<void> GetAllCities(BuildContext context) async {
    var response = await http
        .get(Uri.parse('https://www.sandfriends.com.br/GetAllCities'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      final responseCities = responseBody['cities'];
      final responseStates = responseBody['states'];

      allRegions.clear();

      for (int stateIndex = 0;
          stateIndex < responseStates.length;
          stateIndex++) {
        allRegions.add(Region(
          idState: responseStates[stateIndex]['IdState'],
          state: responseStates[stateIndex]['State'],
          uf: responseStates[stateIndex]['UF'],
        ));
      }
      for (int cityIndex = 0; cityIndex < responseCities.length; cityIndex++) {
        for (int allRegionsIndex = 0;
            allRegionsIndex < allRegions.length;
            allRegionsIndex++) {
          if (allRegions[allRegionsIndex].idState ==
              responseCities[cityIndex]['IdState']) {
            allRegions[allRegionsIndex].cities.add(City(
                  cityId: responseCities[cityIndex]['IdCity'],
                  city: responseCities[cityIndex]['City'],
                ));
          }
        }
      }
    }
  }

  Future<void> addUserInfo(BuildContext context) async {
    const storage = FlutterSecureStorage();
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
          'IdCity': Provider.of<UserProvider>(context, listen: false)
              .user!
              .city!
              .cityId,
          'IdSport': Provider.of<UserProvider>(context, listen: false)
              .user!
              .preferenceSport!
              .idSport,
        }),
      );
      Provider.of<UserProvider>(context, listen: false).user!.firstName =
          firstNameController.text;
      Provider.of<UserProvider>(context, listen: false).user!.lastName =
          lastNameController.text;
      Provider.of<UserProvider>(context, listen: false).user!.phoneNumber =
          PhonenumberConverter(phoneNumberController.text);
      for (int i = 0;
          i <
              Provider.of<CategoriesProvider>(context, listen: false)
                  .sports
                  .length;
          i++) {
        Provider.of<UserProvider>(context, listen: false)
            .user!
            .matchCounter
            .add(MatchCounter(
                total: 0,
                sport: Provider.of<CategoriesProvider>(context, listen: false)
                    .sports[i]));
      }

      context.goNamed('home', params: {'initialPage': 'feed_screen'});
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
