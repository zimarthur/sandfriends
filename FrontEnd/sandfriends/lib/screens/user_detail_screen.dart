import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/models/city.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/match_counter.dart';
import 'package:sandfriends/models/region.dart';
import 'package:sandfriends/providers/categories_provider.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/SF_Dropdown.dart';
import '../../theme/app_theme.dart';
import '../../widgets/SF_Button.dart';
import '../../widgets/SF_TextField.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';
import '../models/rank.dart';
import '../models/sport.dart';
import '../widgets/Modal/SF_ModalMessage.dart';
import '../widgets/SFAvatar.dart';
import '../widgets/SFLoading.dart';

final _userDetailFormKey = GlobalKey<FormState>();
final _userPhoneNumberFormKey = GlobalKey<FormState>();

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailScreen> createState() => _UserDetailScreen();
}

class _UserDetailScreen extends State<UserDetailScreen> {
  bool showModal = false;
  Widget? modalWidget;
  bool isLoading = true;
  bool isEdited = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      MaskedTextController(mask: '(000) 00000-00000');
  final TextEditingController birthdayController =
      MaskedTextController(mask: '00/00/0000');
  final TextEditingController heightController =
      MaskedTextController(mask: '0,00');

  Sport? sportValue;

  String? genderValue;
  String? handPreferenceValue;
  Rank? rankValue;
  String? imagePath;
  bool? noImage = false;

  MatchCounter? matchCounterValue;

  User? referenceUserInfo;

  List<Region> allRegions = [];

  void setReferenceUserInfo(BuildContext context) {
    imagePath = null;
    referenceUserInfo = User(
      idUser: context.read<UserProvider>().user!.idUser,
      firstName: context.read<UserProvider>().user!.firstName,
      lastName: context.read<UserProvider>().user!.lastName,
      phoneNumber: context.read<UserProvider>().user!.phoneNumber,
      gender: context.read<UserProvider>().user!.gender,
      birthday: context.read<UserProvider>().user!.birthday,
      age: context.read<UserProvider>().user!.age,
      height: context.read<UserProvider>().user!.height,
      sidePreference: context.read<UserProvider>().user!.sidePreference,
      photo: context.read<UserProvider>().user!.photo,
      city: context.read<UserProvider>().user!.city,
      email: context.read<UserProvider>().user!.email,
    );
    referenceUserInfo!.preferenceSport =
        context.read<UserProvider>().user!.preferenceSport;

    for (int userRanks = 0;
        userRanks <
            Provider.of<UserProvider>(context, listen: false).user!.rank.length;
        userRanks++) {
      var auxRank = Provider.of<UserProvider>(context, listen: false)
          .user!
          .rank[userRanks];
      referenceUserInfo!.rank.add(Rank(
          idRankCategory: auxRank.idRankCategory,
          sport: auxRank.sport,
          rankSportLevel: auxRank.rankSportLevel,
          name: auxRank.name,
          color: auxRank.color));
    }
    for (int matchCounters = 0;
        matchCounters <
            Provider.of<UserProvider>(context, listen: false)
                .user!
                .matchCounter
                .length;
        matchCounters++) {
      var auxmatchCounter = Provider.of<UserProvider>(context, listen: false)
          .user!
          .matchCounter[matchCounters];
      referenceUserInfo!.matchCounter.add(MatchCounter(
        total: auxmatchCounter.total,
        sport: auxmatchCounter.sport,
      ));
    }
    setState(() {
      isEdited = false;
    });
  }

  @override
  void initState() {
    sportValue =
        Provider.of<CategoriesProvider>(context, listen: false).sports[0];
    setReferenceUserInfo(context);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        if (referenceUserInfo!.firstName != null) {
          firstNameController.text = referenceUserInfo!.firstName!;
        }
        if (referenceUserInfo!.lastName != null) {
          lastNameController.text = referenceUserInfo!.lastName!;
        }
        if (referenceUserInfo!.gender != null) {
          genderValue = referenceUserInfo!.gender!.name;
        }
        if (referenceUserInfo!.phoneNumber != null) {
          phoneNumberController.text = referenceUserInfo!.phoneNumber!;
        }
        if (referenceUserInfo!.birthday != null) {
          birthdayController.text = referenceUserInfo!.birthday!;
        }
        if (referenceUserInfo!.height != null) {
          heightController.text = referenceUserInfo!.height.toString();
        }
        if (referenceUserInfo!.sidePreference != null) {
          handPreferenceValue = referenceUserInfo!.sidePreference!.name;
        }

        //PARA ATUALIZAR VALORES QUANDO TELA É INICIADA
        for (int i = 0;
            i <
                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .rank
                    .length;
            i++) {
          if (Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .rank[i]
                  .sport ==
              sportValue) {
            rankValue =
                Provider.of<UserProvider>(context, listen: false).user!.rank[i];
          }
        }
        for (int i = 0;
            i <
                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .matchCounter
                    .length;
            i++) {
          if (Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .matchCounter[i]
                  .sport
                  .idSport ==
              sportValue!.idSport) {
            matchCounterValue =
                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .matchCounter[i];
          }
        }
        /////////////
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      showModal: showModal,
      modalWidget: modalWidget,
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      titleText: "Meu Perfil",
      onTapReturn: () {
        //RESET PROVIDER
        Provider.of<UserProvider>(context, listen: false).user =
            referenceUserInfo!;
        context.goNamed('home', params: {'initialPage': 'user_screen'});
      },
      appBarType: AppBarType.Secondary,
      rightWidget: SizedBox(
        width: width * 0.2,
        child: SFButton(
          buttonLabel: "Salvar",
          buttonType: isEdited ? ButtonType.Primary : ButtonType.Disabled,
          onTap: () {
            if (isEdited) {
              updateUser(context);
            }
          },
        ),
      ),
      child: isLoading
          ? Container(
              color: AppTheme.colors.primaryBlue.withOpacity(0.3),
              child: const Center(
                child: SFLoading(),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.02),
              child: ListView(
                children: [
                  Padding(padding: EdgeInsets.only(bottom: height * 0.01)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.06,
                    ),
                    child: Text(
                      "Esporte",
                      style: TextStyle(
                        color: AppTheme.colors.textBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Row(
                      children: [
                        Expanded(
                          child: SFDropdown(
                            onChanged: (String? newValue) {
                              setState(() {
                                for (int i = 0;
                                    i <
                                        Provider.of<CategoriesProvider>(context,
                                                listen: false)
                                            .sports
                                            .length;
                                    i++) {
                                  if (Provider.of<CategoriesProvider>(context,
                                              listen: false)
                                          .sports[i]
                                          .description ==
                                      newValue) {
                                    sportValue =
                                        Provider.of<CategoriesProvider>(context,
                                                listen: false)
                                            .sports[i];
                                  }
                                }

                                for (int j = 0;
                                    j <
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user!
                                            .rank
                                            .length;
                                    j++) {
                                  if (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user!
                                          .rank[j]
                                          .sport
                                          .idSport ==
                                      sportValue!.idSport) {
                                    rankValue = Provider.of<UserProvider>(
                                            context,
                                            listen: false)
                                        .user!
                                        .rank[j];
                                  }
                                }
                                for (int k = 0;
                                    k <
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user!
                                            .matchCounter
                                            .length;
                                    k++) {
                                  if (Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user!
                                          .matchCounter[k]
                                          .sport
                                          .idSport ==
                                      sportValue!.idSport) {
                                    matchCounterValue =
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user!
                                            .matchCounter[k];
                                  }
                                }
                              });
                            },
                            controller: sportValue!.description,
                            labelText: "",
                            items: Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .sports
                                .map((e) => e.description)
                                .toList(),
                            validator: (value) {
                              return null;
                            },
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .preferenceSport = sportValue;
                              if (sportValue!.idSport !=
                                  referenceUserInfo!.preferenceSport!.idSport) {
                                isEdited = true;
                              } else {
                                isEdited = false;
                              }
                            });
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              child: sportValue!.idSport ==
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user!
                                          .preferenceSport!
                                          .idSport
                                  ? SvgPicture.asset(
                                      r"assets\icon\favorite_selected.svg",
                                      width: width * 0.06,
                                    )
                                  : SvgPicture.asset(
                                      r"assets\icon\favorite_unselected.svg",
                                      width: width * 0.06,
                                    )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                    child: Text(
                      "Alterne entre os esportes para informar seu nível em cada um deles.",
                      style: TextStyle(color: AppTheme.colors.textDarkGrey),
                      textScaleFactor: 0.8,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.04),
                    child: Container(
                      height: height * 0.55,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryPaper,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.colors.primaryDarkBlue,
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1,
                              color: AppTheme.colors.primaryDarkBlue)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: height * 0.28,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    UpdateField(
                                        EnumProfileFields.Photo, context);
                                  },
                                  child: SizedBox(
                                    height: height * 0.15,
                                    width: height * 0.2,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: SvgPicture.asset(
                                            r'assets\icon\edit.svg',
                                          ),
                                        ),
                                        Center(
                                          child: SFAvatar(
                                            showRank: true,
                                            height: height * 0.15,
                                            sport: sportValue!,
                                            user: Provider.of<UserProvider>(
                                                    context,
                                                    listen: false)
                                                .user!,
                                            editFile: imagePath,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.12,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          UpdateField(
                                              EnumProfileFields.Name, context);
                                        },
                                        child: SizedBox(
                                          height: height * 0.04,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "${Provider.of<UserProvider>(context, listen: false).user!.firstName!} ${Provider.of<UserProvider>(context, listen: false).user!.lastName!}",
                                              style: TextStyle(
                                                color: AppTheme.colors.textBlue,
                                                fontWeight: FontWeight.w700,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: height * 0.025,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            matchCounterValue!.total == 1
                                                ? "${matchCounterValue!.total} jogo"
                                                : "${matchCounterValue!.total} jogos",
                                            style: TextStyle(
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          UpdateField(
                                              EnumProfileFields.Age, context);
                                        },
                                        child: SizedBox(
                                          height: height * 0.025,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              Provider.of<UserProvider>(context,
                                                              listen: false)
                                                          .user!
                                                          .age ==
                                                      null
                                                  ? "-"
                                                  : Provider.of<UserProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .user!
                                                              .age! <
                                                          18
                                                      ? "Sub-18"
                                                      : Provider.of<UserProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .user!
                                                                  .age! <
                                                              40
                                                          ? "Sub-40"
                                                          : "40+",
                                              style: TextStyle(
                                                color: AppTheme
                                                    .colors.textDarkGrey,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            modalWidget = SizedBox(
                                              height: height * 0.7,
                                              child: const Center(
                                                child: SFLoading(),
                                              ),
                                            );
                                            showModal = true;
                                            UpdateField(
                                                EnumProfileFields.Region,
                                                context);
                                          });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset(
                                              r'assets\icon\location_ping.svg',
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: width * 0.01,
                                              ),
                                            ),
                                            SizedBox(
                                              height: height * 0.025,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  Provider.of<UserProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .user!
                                                              .city ==
                                                          null
                                                      ? "-"
                                                      : "${Provider.of<UserProvider>(context, listen: false).user!.city!.city} / ${Provider.of<UserProvider>(context, listen: false).user!.city!.state!.uf}",
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .colors.textDarkGrey,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 0.2,
                            width: width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Gênero:"),
                                    InkWell(
                                      onTap: () {
                                        if (Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user!
                                                .gender ==
                                            null) {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .indexEditModal = 0;
                                        } else {
                                          for (int i = 0;
                                              i <
                                                  Provider.of<CategoriesProvider>(
                                                          context,
                                                          listen: false)
                                                      .genders
                                                      .length;
                                              i++) {
                                            if (Provider.of<CategoriesProvider>(
                                                        context,
                                                        listen: false)
                                                    .genders[i]
                                                    .idGender ==
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .user!
                                                    .gender!
                                                    .idGender) {
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .indexEditModal = i;
                                            }
                                          }
                                        }
                                        UpdateField(
                                            EnumProfileFields.Gender, context);
                                      },
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user!
                                                    .gender ==
                                                null
                                            ? "-"
                                            : Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user!
                                                .gender!
                                                .name,
                                        style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Rank:"),
                                    InkWell(
                                      onTap: () {
                                        Rank userRankOnSport =
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user!
                                                .rank
                                                .where((rank) =>
                                                    rank.sport.idSport ==
                                                    sportValue!.idSport)
                                                .first;
                                        List<Rank> possibleRanks =
                                            Provider.of<CategoriesProvider>(
                                                    context,
                                                    listen: false)
                                                .ranks
                                                .where((rank) =>
                                                    rank.sport.idSport ==
                                                    sportValue!.idSport)
                                                .toList();
                                        for (int i = 0;
                                            i < possibleRanks.length;
                                            i++) {
                                          if (possibleRanks[i].idRankCategory ==
                                              userRankOnSport.idRankCategory) {
                                            Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .indexEditModal = i;
                                          }
                                        }

                                        UpdateField(
                                            EnumProfileFields.Rank, context);
                                      },
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .user!
                                            .rank
                                            .where((rank) =>
                                                rank.sport.idSport ==
                                                sportValue!.idSport)
                                            .first
                                            .name,
                                        style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Mão/Pé:"),
                                    InkWell(
                                      onTap: () {
                                        if (Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user!
                                                .sidePreference ==
                                            null) {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .indexEditModal = 0;
                                        } else {
                                          for (int i = 0;
                                              i <
                                                  Provider.of<CategoriesProvider>(
                                                          context,
                                                          listen: false)
                                                      .sidePreferences
                                                      .length;
                                              i++) {
                                            if (Provider.of<CategoriesProvider>(
                                                        context,
                                                        listen: false)
                                                    .sidePreferences[i]
                                                    .idSidePreference ==
                                                Provider.of<UserProvider>(
                                                        context,
                                                        listen: false)
                                                    .user!
                                                    .sidePreference!
                                                    .idSidePreference) {
                                              Provider.of<UserProvider>(context,
                                                      listen: false)
                                                  .indexEditModal = i;
                                            }
                                          }
                                        }
                                        UpdateField(
                                            EnumProfileFields.HandPreference,
                                            context);
                                      },
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user!
                                                    .sidePreference ==
                                                null
                                            ? "-"
                                            : Provider.of<UserProvider>(context,
                                                    listen: false)
                                                .user!
                                                .sidePreference!
                                                .name,
                                        style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Altura:"),
                                    InkWell(
                                      onTap: () {
                                        UpdateField(
                                            EnumProfileFields.Height, context);
                                      },
                                      child: Text(
                                        Provider.of<UserProvider>(context,
                                                        listen: false)
                                                    .user!
                                                    .height ==
                                                null
                                            ? "-"
                                            : "${Provider.of<UserProvider>(context, listen: false).user!.height!.toStringAsFixed(2)}m",
                                        style: TextStyle(
                                          color: AppTheme.colors.textBlue,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.02,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                    ),
                    child: Text(
                      "Celular",
                      style: TextStyle(
                        color: AppTheme.colors.textBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.01)),
                  Form(
                    key: _userPhoneNumberFormKey,
                    child: SFTextField(
                      onChanged: (value) {
                        if (_userPhoneNumberFormKey.currentState?.validate() ==
                            true) {
                          Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .phoneNumber =
                              PhonenumberConverter(phoneNumberController.text);
                          setState(() {
                            if (PhonenumberConverter(
                                    phoneNumberController.text) !=
                                referenceUserInfo!.phoneNumber) {
                              isEdited = true;
                            } else {
                              isEdited = false;
                            }
                          });
                        }
                      },
                      controller: phoneNumberController,
                      pourpose: TextFieldPourpose.Numeric,
                      labelText: "",
                      validator: phoneValidator,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Text(
                      "Nenhum jogador terá acesso ao seu celular",
                      style: TextStyle(color: AppTheme.colors.textDarkGrey),
                      textScaleFactor: 0.8,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                    ),
                    child: Text(
                      "Email",
                      style: TextStyle(
                        color: AppTheme.colors.textBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.01)),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.02,
                    ),
                    child: Text(
                      referenceUserInfo!.email!,
                      style: TextStyle(
                        color: AppTheme.colors.textBlue,
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: height * 0.03)),
                ],
              ),
            ),
    );
  }

  void UpdateField(EnumProfileFields field, BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    setState(() {
      switch (field) {
        case EnumProfileFields.Name:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Form(
              key: _userDetailFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SFTextField(
                      labelText: "Nome",
                      pourpose: TextFieldPourpose.Standard,
                      controller: firstNameController,
                      validator: nameValidator),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                  ),
                  SFTextField(
                      labelText: "Sobrenome",
                      pourpose: TextFieldPourpose.Standard,
                      controller: lastNameController,
                      validator: lastNameValidator),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                  ),
                  SFButton(
                      buttonLabel: "Concluído",
                      buttonType: ButtonType.Primary,
                      textPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                      ),
                      onTap: () {
                        if (_userDetailFormKey.currentState?.validate() ==
                            true) {
                          if ((referenceUserInfo!.firstName !=
                                  firstNameController.text) ||
                              (referenceUserInfo!.lastName !=
                                  lastNameController.text)) {
                            isEdited = true;
                          } else {
                            isEdited = false;
                          }
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .firstName = firstNameController.text;
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .lastName = lastNameController.text;
                          setState(() {
                            showModal = false;
                          });
                        }
                      })
                ],
              ),
            ),
          );
          showModal = true;
          break;
        case EnumProfileFields.Age:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Form(
              key: _userDetailFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SFTextField(
                      labelText: "Aniversário",
                      pourpose: TextFieldPourpose.Numeric,
                      controller: birthdayController,
                      validator: birthdayValidator),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Text(
                      "A sua idade será categorizada em faixas de idade. Ninguém terá acesso à sua idade exata.",
                      style: TextStyle(color: AppTheme.colors.textDarkGrey),
                      textScaleFactor: 0.8,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.03),
                  ),
                  SFButton(
                      buttonLabel: "Concluído",
                      buttonType: ButtonType.Primary,
                      textPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                      ),
                      onTap: () {
                        if (_userDetailFormKey.currentState?.validate() ==
                            true) {
                          if (referenceUserInfo!.birthday !=
                              birthdayController.text) {
                            isEdited = true;
                          } else {
                            isEdited = false;
                          }
                          if (birthdayController.text.isEmpty) {
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .birthday = "-";
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .age = null;
                          } else {
                            DateTime currentDate = DateTime.now();
                            DateTime birthDate = DateTime.parse(
                                DateTimeConverter(birthdayController.text));
                            int age = currentDate.year - birthDate.year;
                            int month1 = currentDate.month;
                            int month2 = birthDate.month;
                            if (month2 > month1) {
                              age--;
                            } else if (month1 == month2) {
                              int day1 = currentDate.day;
                              int day2 = birthDate.day;
                              if (day2 > day1) {
                                age--;
                              }
                            }

                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .birthday = birthdayController.text;
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .age = age;
                          }
                          setState(() {
                            showModal = false;
                          });
                        }
                      })
                ],
              ),
            ),
          );
          showModal = true;
          break;
        case EnumProfileFields.Height:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Form(
              key: _userDetailFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SFTextField(
                      labelText: "Altura",
                      pourpose: TextFieldPourpose.Numeric,
                      controller: heightController,
                      validator: heightValidator),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.02),
                  ),
                  SFButton(
                      buttonLabel: "Concluído",
                      buttonType: ButtonType.Primary,
                      textPadding: EdgeInsets.symmetric(
                        vertical: height * 0.02,
                      ),
                      onTap: () {
                        if (_userDetailFormKey.currentState?.validate() ==
                            true) {
                          if (heightController.text == "") {
                            if (referenceUserInfo!.height == null) {
                              isEdited = false;
                            } else {
                              isEdited = true;
                            }
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .height = null;
                          } else {
                            if (referenceUserInfo!.height !=
                                double.parse(heightController.text
                                    .replaceAll(",", "."))) {
                              isEdited = true;
                            } else {
                              isEdited = false;
                            }
                            Provider.of<UserProvider>(context, listen: false)
                                    .user!
                                    .height =
                                double.parse(
                                    heightController.text.replaceAll(",", "."));
                          }

                          setState(() {
                            showModal = false;
                          });
                        }
                      })
                ],
              ),
            ),
          );
          showModal = true;
          break;
        case EnumProfileFields.Gender:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        Provider.of<CategoriesProvider>(context, listen: false)
                            .genders
                            .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .indexEditModal = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.02),
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.05),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.secondaryBack,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? AppTheme.colors.primaryBlue
                                  : AppTheme.colors.textLightGrey,
                              width: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? 2
                                  : 1,
                            ),
                          ),
                          child: Text(
                            Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .genders[index]
                                .name,
                            style: TextStyle(
                                color: index ==
                                        Provider.of<UserProvider>(context)
                                            .indexEditModal
                                    ? AppTheme.colors.textBlue
                                    : AppTheme.colors.textDarkGrey),
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
                      Provider.of<UserProvider>(context, listen: false)
                          .user!
                          .gender = Provider.of<CategoriesProvider>(context,
                                  listen: false)
                              .genders[
                          Provider.of<UserProvider>(context, listen: false)
                              .indexEditModal];
                      if (referenceUserInfo!.gender!.name !=
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .gender!
                              .name) {
                        isEdited = true;
                      } else {
                        isEdited = false;
                      }
                      setState(() {
                        showModal = false;
                      });
                    })
              ],
            ),
          );
          showModal = true;
          break;
        case EnumProfileFields.HandPreference:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount:
                        Provider.of<CategoriesProvider>(context, listen: false)
                            .sidePreferences
                            .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .indexEditModal = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.02),
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.05),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.secondaryBack,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? AppTheme.colors.primaryBlue
                                  : AppTheme.colors.textLightGrey,
                              width: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? 2
                                  : 1,
                            ),
                          ),
                          child: Text(
                            Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .sidePreferences[index]
                                .name,
                            style: TextStyle(
                                color: index ==
                                        Provider.of<UserProvider>(context)
                                            .indexEditModal
                                    ? AppTheme.colors.textBlue
                                    : AppTheme.colors.textDarkGrey),
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
                      Provider.of<UserProvider>(context, listen: false)
                          .user!
                          .sidePreference = Provider.of<CategoriesProvider>(
                                  context,
                                  listen: false)
                              .sidePreferences[
                          Provider.of<UserProvider>(context, listen: false)
                              .indexEditModal];
                      if (referenceUserInfo!.sidePreference!.name !=
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .sidePreference!
                              .name) {
                        isEdited = true;
                      } else {
                        isEdited = false;
                      }
                      setState(() {
                        showModal = false;
                      });
                    })
              ],
            ),
          );
          showModal = true;
          break;

        case EnumProfileFields.Rank:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: height * 0.3,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: Provider.of<CategoriesProvider>(context,
                            listen: false)
                        .ranks
                        .where(
                            (rank) => rank.sport.idSport == sportValue!.idSport)
                        .length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .indexEditModal = index;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: height * 0.02),
                          padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                              horizontal: width * 0.05),
                          decoration: BoxDecoration(
                            color: AppTheme.colors.secondaryBack,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? AppTheme.colors.primaryBlue
                                  : AppTheme.colors.textLightGrey,
                              width: index ==
                                      Provider.of<UserProvider>(context)
                                          .indexEditModal
                                  ? 2
                                  : 1,
                            ),
                          ),
                          child: Text(
                            Provider.of<CategoriesProvider>(context,
                                    listen: false)
                                .ranks
                                .where((rank) =>
                                    rank.sport.idSport == sportValue!.idSport)
                                .toList()[index]
                                .name,
                            style: TextStyle(
                                color: index ==
                                        Provider.of<UserProvider>(context)
                                            .indexEditModal
                                    ? AppTheme.colors.textBlue
                                    : AppTheme.colors.textDarkGrey),
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
                      Rank selectedRank = Provider.of<CategoriesProvider>(
                                  context,
                                  listen: false)
                              .ranks
                              .where((rank) =>
                                  rank.sport.idSport == sportValue!.idSport)
                              .toList()[
                          Provider.of<UserProvider>(context, listen: false)
                              .indexEditModal];
                      for (int i = 0;
                          i <
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .rank
                                  .length;
                          i++) {
                        if (Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .rank[i]
                                .sport
                                .idSport ==
                            sportValue!.idSport) {
                          Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .rank[i] = selectedRank;
                        }
                      }
                      for (int j = 0; j < referenceUserInfo!.rank.length; j++) {
                        if (referenceUserInfo!.rank[j].sport.idSport ==
                            sportValue!.idSport) {
                          if (referenceUserInfo!.rank[j].idRankCategory !=
                              selectedRank.idRankCategory) {
                            isEdited = true;
                          } else {
                            isEdited = false;
                          }
                          break;
                        }
                      }
                      setState(() {
                        showModal = false;
                      });
                    })
              ],
            ),
          );
          showModal = true;
          break;
        case EnumProfileFields.Region:
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
                                      for (var cityList in region.cities) {
                                        if (cityList.city == city.city) {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user!
                                              .city = City(
                                            cityId: cityList.cityId,
                                            city: cityList.city,
                                            state: Region(
                                              idState:
                                                  allRegions[index].idState,
                                              state: allRegions[index].state,
                                              uf: allRegions[index].uf,
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  }
                                  if (referenceUserInfo!.city!.cityId !=
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .user!
                                          .city!
                                          .cityId) {
                                    isEdited = true;
                                  } else {
                                    isEdited = false;
                                  }
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
          break;
        case EnumProfileFields.Photo:
          modalWidget = Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.04,
              vertical: height * 0.04,
            ),
            height: width * 1.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Toque para escolher uma nova foto.",
                  style: TextStyle(color: AppTheme.colors.textDarkGrey),
                ),
                Column(
                  children: [
                    SFAvatar(
                      height: width * 0.7,
                      user: Provider.of<UserProvider>(context, listen: false)
                          .user!,
                      showRank: false,
                      editFile: imagePath,
                      onTap: () {
                        if (noImage == false) {
                          pickImage().then((value) {
                            setState(() {
                              UpdateField(EnumProfileFields.Photo, context);
                            });
                          });
                        }
                      },
                    ),
                    CheckboxListTile(
                        title: Text(
                          "Não escolher foto",
                          style: TextStyle(
                            color: AppTheme.colors.textDarkGrey,
                          ),
                        ),
                        value: noImage,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (newValue) {
                          setState(() {
                            noImage = newValue;
                            if (noImage == true) {
                              imagePath = null;
                              Provider.of<UserProvider>(context, listen: false)
                                  .user!
                                  .photo = null;
                            }
                            UpdateField(EnumProfileFields.Photo, context);
                          });
                        }),
                  ],
                ),
                SFButton(
                    buttonLabel: "Concluído",
                    buttonType: ButtonType.Primary,
                    textPadding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                    ),
                    onTap: () {
                      setState(() {
                        showModal = false;
                        if ((imagePath != null) ||
                            ((referenceUserInfo!.photo != "") &&
                                (noImage == true))) {
                          isEdited = true;
                        }
                      });
                    })
              ],
            ),
          );
          showModal = true;

          break;
        default:
      }
    });
  }

  Future<void> updateUser(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");

    String photo = "";
    if (Provider.of<UserProvider>(context, listen: false).user!.photo != null) {
      photo = Provider.of<UserProvider>(context, listen: false).user!.photo!;
    }
    File imageFile;
    List<int> imageBytes;
    if (imagePath != null) {
      imageFile = File(imagePath!);
      imageBytes = imageFile.readAsBytesSync();
      photo = base64Encode(imageBytes);
    }

    if (accessToken != null) {
      setState(() {
        isLoading = true;
      });
      List<Map<String, dynamic>> rankJson = [];
      for (int i = 0;
          i <
              Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .rank
                  .length;
          i++) {
        rankJson.add({
          "idUser":
              Provider.of<UserProvider>(context, listen: false).user!.idUser,
          "idRankCategory": Provider.of<UserProvider>(context, listen: false)
              .user!
              .rank[i]
              .idRankCategory,
          "idSport": Provider.of<UserProvider>(context, listen: false)
              .user!
              .rank[i]
              .sport
              .idSport
        });
      }

      var response = await http.put(
        Uri.parse('https://www.sandfriends.com.br/UpdateUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'AccessToken': accessToken,
          'FirstName': Provider.of<UserProvider>(context, listen: false)
              .user!
              .firstName!,
          'LastName':
              Provider.of<UserProvider>(context, listen: false).user!.lastName!,
          'PhoneNumber': Provider.of<UserProvider>(context, listen: false)
              .user!
              .phoneNumber!,
          'IdGender':
              Provider.of<UserProvider>(context, listen: false).user!.gender ==
                      null
                  ? ""
                  : Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .gender!
                      .idGender,
          'Birthday': birthdayController.text.isEmpty
              ? ""
              : DateTimeConverter(
                  Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .birthday!),
          'Height': Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .height ==
                  null
              ? ""
              : Provider.of<UserProvider>(context, listen: false).user!.height!,
          'SidePreference': Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .sidePreference ==
                  null
              ? ""
              : Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .sidePreference!
                  .idSidePreference,
          'Rank': rankJson,
          'Photo': photo,
          'IdCity':
              Provider.of<UserProvider>(context, listen: false).user!.city ==
                      null
                  ? ""
                  : Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .city!
                      .cityId,
          'IdSport': Provider.of<UserProvider>(context, listen: false)
              .user!
              .preferenceSport!
              .idSport,
        }),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            isLoading = false;
            showModal = true;
            modalWidget = SFModalMessage(
              modalStatus: GenericStatus.Success,
              message: "Suas informações foram atualizadas!",
              onTap: () {
                setState(() {
                  Map<String, dynamic> responseBody =
                      json.decode(response.body);
                  Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .photo = responseBody['Photo'];
                  setReferenceUserInfo(context);
                  showModal = false;
                });
              },
            );
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            showModal = true;
            modalWidget = SFModalMessage(
              modalStatus: GenericStatus.Failed,
              message:
                  "Não foi possível alterar suas informações. Tente novamente.",
              onTap: () {
                setState(() {
                  showModal = false;
                });
              },
            );
          });
        }
        print("deu ruim");
      }
    }
  }

  Future<void> GetAllCities(BuildContext context) async {
    var response = await http
        .get(Uri.parse('https://www.sandfriends.com.br/GetAllCities'));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      final responseCities = responseBody['Cities'];
      final responseStates = responseBody['States'];

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
              responseCities[cityIndex]['State']['IdState']) {
            allRegions[allRegionsIndex].cities.add(City(
                  cityId: responseCities[cityIndex]['IdCity'],
                  city: responseCities[cityIndex]['City'],
                ));
          }
        }
      }
    }
  }

  Future pickImage() async {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file == null) return;
    imagePath = file.path;
    setState(() {});
  }

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return "informe seu nome";
    } else {
      return null;
    }
  }

  String? lastNameValidator(String? value) {
    if (value == null || value.isEmpty || value == "") {
      return "informe seu sobrenome";
    } else {
      return null;
    }
  }

  String? genderValidator(String? value) {
    if (value == null || value == "") {
      return "informe seu gênero";
    } else {
      genderValue = value;
      return null;
    }
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty || value == "") {
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
    if (value == null || value.isEmpty || value == "") {
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
    if (value == null || value.isEmpty || value == "") {
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
    RegExp exp = RegExp(r"[^0-9]");
    return rawPhonenumber.replaceAll(exp, '');
  }
}
