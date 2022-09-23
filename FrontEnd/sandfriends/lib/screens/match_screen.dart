import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/court.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/match_member.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/widgets/SF_TextField.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import '../models/sport.dart';
import '../models/store.dart';
import '../models/user.dart';
import '../models/validators.dart';
import '../providers/match_provider.dart';
import '../models/match.dart';
import '../providers/sport_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/Modal/SF_Modal.dart';
import '../widgets/Modal/SF_ModalMessage.dart';
import '../widgets/SFLoading.dart';

final _creatorNotesFormKey = GlobalKey<FormState>();

class MatchScreen extends StatefulWidget {
  final int matchUrl;
  MatchScreen({required this.matchUrl});
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool isLoading = true;
  bool showModal = false;
  Widget? modalWidget;

  bool isUserMatchCreator = false;
  bool isUserInMatch = false;

  Match currentMatch = Match();

  bool controllerHasChanged = false;
  TextEditingController creatorNotesController = TextEditingController();
  @override
  void initState() {
    GetMatchInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SFScaffold(
      onTapBackground: () {
        setState(() {
          showModal = false;
        });
      },
      appBarType: AppBarType.Primary,
      titleText: "Partida de ${currentMatch.userCreator}",
      onTapReturn: () {
        context.goNamed('home', params: {'initialPage': 'feed_screen'});
      },
      showModal: showModal,
      modalWidget: modalWidget,
      child: Stack(
        children: [
          isLoading
              ? Stack(
                  children: [
                    Container(
                      color: AppTheme.colors.secondaryBack,
                    ),
                    Container(
                      //loading
                      color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                      child: Center(
                        child: SFLoading(),
                      ),
                    )
                  ],
                )
              : Container(
                  color: AppTheme.colors.secondaryBack,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: ListView(
                    children: [
                      Container(
                        height: height * 0.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              //LOCAL
                              height: height * 0.03,
                              margin: EdgeInsets.only(top: height * 0.01),
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Local",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  ClipRRect(
                                    //IMAGEURL
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(
                                      currentMatch.store!.imageUrl,
                                      height: height * 0.13,
                                      width: height * 0.13,
                                    ),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.1)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        currentMatch.store!.name,
                                        textScaleFactor: 1.5,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.colors.primaryBlue),
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            r'assets\icon\location_ping.svg',
                                            color: AppTheme.colors.primaryBlue,
                                            width: 15,
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  right: width * 0.02)),
                                          Expanded(
                                            child: Text(
                                              "${currentMatch.store!.address}",
                                              style: TextStyle(
                                                color:
                                                    AppTheme.colors.primaryBlue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            currentMatch.court!.storeCourtName,
                                          ),
                                          Text(
                                            currentMatch.court!.isIndoor
                                                ? "Quadra Coberta"
                                                : "Quadra Descoberta",
                                            textScaleFactor: 0.8,
                                            style: TextStyle(
                                                color: AppTheme
                                                    .colors.textDarkGrey),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      isUserMatchCreator == false &&
                              currentMatch.creatorNotes == ""
                          ? Container()
                          : Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.03),
                                  child: Container(
                                    height: 1,
                                    color: AppTheme.colors.textLightGrey,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: height * 0.03,
                                      margin:
                                          EdgeInsets.only(top: height * 0.01),
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "Recado de ${currentMatch.userCreator}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    controllerHasChanged
                                        ? SFButton(
                                            textPadding:
                                                EdgeInsets.all(width * 0.02),
                                            buttonLabel: "Salvar",
                                            buttonType: ButtonType.Primary,
                                            onTap: () {
                                              if (_creatorNotesFormKey
                                                      .currentState
                                                      ?.validate() ==
                                                  true) {
                                                saveCreatorNotes();
                                              } else {}
                                            })
                                        : Container(),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.01),
                                  child: isUserMatchCreator
                                      ? Form(
                                          key: _creatorNotesFormKey,
                                          child: SFTextField(
                                              onChanged: (value) {
                                                setState(() {
                                                  if (creatorNotesController
                                                          .text !=
                                                      currentMatch
                                                          .creatorNotes) {
                                                    controllerHasChanged = true;
                                                  } else {
                                                    controllerHasChanged =
                                                        false;
                                                  }
                                                });
                                              },
                                              labelText: "",
                                              pourpose:
                                                  TextFieldPourpose.Multiline,
                                              maxLines: 5,
                                              controller:
                                                  creatorNotesController,
                                              validator: max255),
                                        )
                                      : Container(
                                          child:
                                              Text(currentMatch.creatorNotes),
                                          width: double.infinity),
                                ),
                              ],
                            ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: Container(
                          height: 1,
                          color: AppTheme.colors.textLightGrey,
                        ),
                      ),
                      Container(
                        height: height * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.03,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  "Detalhes da Partida",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.08),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Data:",
                                        ),
                                        Text(
                                          "${DateFormat("dd/MM/yyyy").format(currentMatch.day!)}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Horário:",
                                        ),
                                        Text(
                                          "${currentMatch.timeBegin} - ${currentMatch.timeFinish}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Preço:",
                                        ),
                                        Text(
                                          "R\$ ${currentMatch.price}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Esporte:",
                                        ),
                                        Text(
                                          "${currentMatch.sport!.description}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: Container(
                          height: 1,
                          color: AppTheme.colors.textLightGrey,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.03,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Jogadores",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05, vertical: height * 0.02),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: currentMatch.matchMembers.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  modalWidget = Container(
                                    height: height * 0.6,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Container(
                                          height: height * 0.25,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              CircleAvatar(
                                                backgroundColor:
                                                    AppTheme.colors.primaryBlue,
                                                radius: height * 0.075,
                                                child: CircleAvatar(
                                                  backgroundColor: AppTheme
                                                      .colors.secondaryPaper,
                                                  radius: height * 0.07,
                                                  child: CircleAvatar(
                                                    backgroundColor: AppTheme
                                                        .colors.primaryBlue,
                                                    radius: height * 0.065,
                                                    child: Container(
                                                      height: height * 0.06,
                                                      width: height * 0.06,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "${currentMatch.matchMembers[index].user!.FirstName![0].toUpperCase()}${currentMatch.matchMembers[index].user!.LastName![0].toUpperCase()}",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .secondaryBack,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: height * 0.1,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: height * 0.04,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "${currentMatch.matchMembers[index].user!.FirstName} ${currentMatch.matchMembers[index].user!.LastName}",
                                                          style: TextStyle(
                                                              color: AppTheme
                                                                  .colors
                                                                  .textBlue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.025,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "12 jogos",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textDarkGrey,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: height * 0.025,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          currentMatch
                                                                      .matchMembers[
                                                                          index]
                                                                      .user!
                                                                      .Age ==
                                                                  null
                                                              ? ""
                                                              : currentMatch
                                                                          .matchMembers[
                                                                              index]
                                                                          .user!
                                                                          .Age! <
                                                                      18
                                                                  ? "Sub-18"
                                                                  : currentMatch
                                                                              .matchMembers[index]
                                                                              .user!
                                                                              .Age! <
                                                                          40
                                                                      ? "Sub-40"
                                                                      : "40+",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textDarkGrey,
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
                                        Container(
                                          height: height * 0.2,
                                          width: width * 0.6,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Gênero:"),
                                                  Text(
                                                    currentMatch
                                                                .matchMembers[
                                                                    index]
                                                                .user!
                                                                .Gender ==
                                                            null
                                                        ? "-"
                                                        : currentMatch
                                                            .matchMembers[index]
                                                            .user!
                                                            .Gender!,
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .colors.textBlue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Rank:"),
                                                  Text(
                                                    currentMatch
                                                                .matchMembers[
                                                                    index]
                                                                .user!
                                                                .Rank ==
                                                            null
                                                        ? "-"
                                                        : currentMatch
                                                            .matchMembers[index]
                                                            .user!
                                                            .Rank!,
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .colors.textBlue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Mão:"),
                                                  Text(
                                                    currentMatch
                                                                .matchMembers[
                                                                    index]
                                                                .user!
                                                                .HandPreference ==
                                                            null
                                                        ? "-"
                                                        : currentMatch
                                                            .matchMembers[index]
                                                            .user!
                                                            .HandPreference!,
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .colors.textBlue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text("Altura:"),
                                                  Text(
                                                    currentMatch
                                                                .matchMembers[
                                                                    index]
                                                                .user!
                                                                .Height ==
                                                            null
                                                        ? "-"
                                                        : "${currentMatch.matchMembers[index].user!.Height!}m",
                                                    style: TextStyle(
                                                        color: AppTheme
                                                            .colors.textBlue,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        isUserMatchCreator &&
                                                currentMatch.matchMembers[index]
                                                        .user!.IdUser !=
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user!
                                                        .IdUser
                                            ? Container(
                                                width: width * 0.5,
                                                child: SFButton(
                                                    buttonLabel:
                                                        "Excluir Jogador",
                                                    buttonType:
                                                        ButtonType.Primary,
                                                    textPadding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                height * 0.01),
                                                    onTap: () {
                                                      RemoveMatchMember(
                                                          currentMatch
                                                              .matchMembers[
                                                                  index]
                                                              .user!
                                                              .IdUser!);
                                                    }),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  );

                                  showModal = true;
                                });
                              },
                              child: Container(
                                height: height * 0.08,
                                margin: EdgeInsets.symmetric(
                                    vertical: height * 0.005),
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: height * 0.04,
                                        bottom: height * 0.015,
                                        top: height * 0.015,
                                      ),
                                      padding:
                                          EdgeInsets.only(left: height * 0.06),
                                      alignment: Alignment.centerLeft,
                                      height: height * 0.05,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: currentMatch.matchMembers[index]
                                                .waitingApproval!
                                            ? AppTheme.colors.secondaryYellow
                                            : AppTheme.colors.primaryLightBlue,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              currentMatch.matchMembers[index]
                                                  .user!.FirstName!,
                                              style: TextStyle(
                                                color:
                                                    AppTheme.colors.textWhite,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          currentMatch.matchMembers[index]
                                                      .waitingApproval! &&
                                                  isUserMatchCreator
                                              ? Row(
                                                  children: [
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: InkWell(
                                                        onTap: () =>
                                                            InvitationResponse(
                                                                currentMatch
                                                                    .matchMembers[
                                                                        index]
                                                                    .user!
                                                                    .IdUser!,
                                                                true),
                                                        child: SvgPicture.asset(
                                                          r'assets\icon\confirm.svg',
                                                          color: AppTheme.colors
                                                              .secondaryGreen,
                                                          height: height * 0.03,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.02),
                                                      child: InkWell(
                                                        onTap: () =>
                                                            InvitationResponse(
                                                                currentMatch
                                                                    .matchMembers[
                                                                        index]
                                                                    .user!
                                                                    .IdUser!,
                                                                false),
                                                        child: SvgPicture.asset(
                                                          r'assets\icon\cancel.svg',
                                                          color: Colors.red,
                                                          height: height * 0.03,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: CircleAvatar(
                                        backgroundColor:
                                            AppTheme.colors.primaryBlue,
                                        radius: height * 0.032,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              AppTheme.colors.secondaryPaper,
                                          radius: height * 0.028,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                AppTheme.colors.primaryBlue,
                                            radius: height * 0.024,
                                            child: Container(
                                              height: height * 0.022,
                                              width: height * 0.022,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "${currentMatch.matchMembers[index].user!.FirstName![0].toUpperCase()}${currentMatch.matchMembers[index].user!.LastName![0].toUpperCase()}",
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .colors.secondaryBack,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: height * 0.03),
                        child: Container(
                          height: 1,
                          color: AppTheme.colors.textLightGrey,
                        ),
                      ),
                      isUserMatchCreator
                          ? Column(
                              children: [
                                Container(
                                  height: height * 0.05,
                                  child: SFButton(
                                    buttonLabel: "Convidar Jogadores",
                                    buttonType: ButtonType.Primary,
                                    iconPath: r"assets\icon\share.svg",
                                    onTap: () async {
                                      await Share.share(
                                          'Entre na minha partida!\n https://www.sandfriends.com.br/redirect/?ct=mtch&bd=${currentMatch.matchUrl}');
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: height * 0.01,
                                  ),
                                ),
                                Container(
                                  height: height * 0.05,
                                  child: SFButton(
                                    buttonLabel: "Cancelar Partida",
                                    buttonType: ButtonType.Secondary,
                                    onTap: () {
                                      CancelMatch();
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: height * 0.01,
                                  ),
                                ),
                              ],
                            )
                          : isUserInMatch
                              ? Column(
                                  children: [
                                    Container(
                                      height: height * 0.05,
                                      child: SFButton(
                                        buttonLabel: "Sair da Partida",
                                        buttonType: ButtonType.Secondary,
                                        onTap: () {
                                          LeaveMatch();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: height * 0.01,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Container(
                                      height: height * 0.05,
                                      child: SFButton(
                                        buttonLabel: "Entrar na Partida",
                                        buttonType: ButtonType.Primary,
                                        onTap: () {
                                          JoinMatch();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: height * 0.01,
                                      ),
                                    ),
                                  ],
                                ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> GetMatchInfo() async {
    if (Provider.of<UserProvider>(context, listen: false).user == null) {
      const storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: "AccessToken");
      bool isNewUser = false;
      String newAccessToken;

      if (accessToken != null) {
        var response = await http.post(
          Uri.parse('https://www.sandfriends.com.br/ValidateToken'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            <String, Object>{
              'AccessToken': accessToken,
            },
          ),
        );

        if (response.statusCode == 200) {
          Map<String, dynamic> responseBody = json.decode(response.body);
          final newAccessToken = responseBody['AccessToken'];
          await storage.write(key: "AccessToken", value: newAccessToken);
          if (responseBody['EmailConfirmationDate'] == null) {
            context.goNamed('login_signup');
          } else if (responseBody['IsNewUser'] == true) {
            context.goNamed('new_user_welcome');
          } else {
            response = await http.get(Uri.parse(
                'https://www.sandfriends.com.br/GetUser/' + newAccessToken));
            if (response.statusCode == 200) {
              Map<String, dynamic> responseBody = json.decode(response.body);
              Provider.of<UserProvider>(context, listen: false)
                  .userFromJson(responseBody);
            } else {
              print("deu ruim");
            }
          }
        } else {
          //o token não é valido
          context.goNamed('login_signup');
        }
      } else {
        //não tem token
        context.goNamed('login_signup');
      }
    }
    var response = await http.get(Uri.parse(
        'https://www.sandfriends.com.br/GetMatchInfo/${widget.matchUrl}'));

    if (response.statusCode == 200) {
      if (mounted) {
        currentMatch = Match();
        Map<String, dynamic> responseBody = json.decode(response.body);
        final responseMatch = responseBody['match'];
        final responseMatchMembers = responseBody['matchMembers'];
        final responseStoreCourt = responseBody['storeCourt'];
        final responseUsers = responseBody['users'];
        final responseStore = responseBody['store'];
        final responseStorePhoto = responseBody['storePhotos'];
        final responseSports = responseBody['sports'];

        if (Provider.of<SportProvider>(context, listen: false).sports.isEmpty) {
          for (int i = 0; i < responseSports.length; i++) {
            Provider.of<SportProvider>(context, listen: false).sports.add(
                  Sport(
                    idSport: responseSports[i]['IdSport'],
                    description: responseSports[i]['Description'],
                    photoUrl: responseSports[i]['SportPhoto'],
                  ),
                );
          }
        }
        if (Provider.of<StoreProvider>(context, listen: false).stores.isEmpty) {
          var newStore = Store();
          newStore.idStore = responseStore['IdStore'];
          newStore.name = responseStore['Name'];
          newStore.address = responseStore['Address'];
          newStore.latitude = responseStore['Latitude'];
          newStore.longitude = responseStore['Longitude'];
          newStore.imageUrl = responseStore['Logo'];
          newStore.descriptionText = responseStore['Description'];
          newStore.instagram = responseStore['Instagram'];
          newStore.phone = responseStore['Phone'];
          for (int photoIndex = 0;
              photoIndex < responseStorePhoto.length;
              photoIndex++) {
            newStore.addPhoto(responseStorePhoto[photoIndex]['storePhoto']);
          }
          Provider.of<StoreProvider>(context, listen: false)
              .stores
              .add(newStore);
        }
        List<User> usersList = [];
        for (int i = 0; i < responseUsers.length; i++) {
          var newUser = User();
          newUser.IdUser = responseUsers[i]['IdUser'];
          newUser.FirstName = responseUsers[i]['FirstName'];
          newUser.LastName = responseUsers[i]['LastName'];
          newUser.PhoneNumber = responseUsers[i]['PhoneNumber'];
          newUser.Gender = responseUsers[i]['Gender'];
          newUser.Birthday = responseUsers[i]['Birthday'];
          newUser.Age = responseUsers[i]['Age'];
          newUser.Rank = responseUsers[i]['Rank'];
          newUser.Height = responseUsers[i]['Height'];
          newUser.HandPreference = responseUsers[i]['HandPreference'];
          newUser.Photo = responseUsers[i]['Photo'];
          usersList.add(newUser);
        }

        isUserInMatch = false;
        for (int i = 0; i < responseMatchMembers.length; i++) {
          if (responseMatchMembers[i]['IdUser'] ==
              Provider.of<UserProvider>(context, listen: false).user!.IdUser) {
            isUserInMatch = true;
          }
          for (int userListIndex = 0;
              userListIndex < usersList.length;
              userListIndex++) {
            if (usersList[userListIndex].IdUser ==
                responseMatchMembers[i]['IdUser']) {
              currentMatch.matchMembers.add(
                MatchMember(
                  user: usersList[userListIndex],
                  idMatchMember: responseMatchMembers[i]['IdMatchMember'],
                  waitingApproval: responseMatchMembers[i]['WaitingApproval'],
                  matchCreator: responseMatchMembers[i]['IsMatchCreator'],
                ),
              );
              if (responseMatchMembers[i]['IsMatchCreator'] == true) {
                currentMatch.userCreator = usersList[userListIndex].FirstName!;
                if (Provider.of<UserProvider>(context, listen: false)
                        .user!
                        .IdUser ==
                    usersList[userListIndex].IdUser) {
                  isUserMatchCreator = true;
                } else {
                  isUserMatchCreator = false;
                }
              }
            }
          }
        }
        if (isUserMatchCreator == false) {
          currentMatch.matchMembers = currentMatch.matchMembers
              .where((member) =>
                  member.waitingApproval == false ||
                  member.user!.IdUser ==
                      Provider.of<UserProvider>(context, listen: false)
                          .user!
                          .IdUser)
              .toList();
        }
        currentMatch.idMatch = responseMatch['IdMatch'];
        Provider.of<StoreProvider>(context, listen: false)
            .stores
            .forEach((store) {
          if (store.idStore == responseMatch['IdStore']) {
            currentMatch.store = store;
          }
        });
        Provider.of<SportProvider>(context, listen: false)
            .sports
            .forEach((sport) {
          if (sport.idSport == responseMatch['IdSport']) {
            currentMatch.sport = sport;
          }
        });
        currentMatch.day =
            DateFormat("yyyy-MM-dd").parse(responseMatch['Date']);
        currentMatch.idMatch = responseMatch['IdMatch'];
        currentMatch.timeBegin = responseMatch['TimeBegin'];
        currentMatch.timeFinish = responseMatch['TimeEnd'];
        currentMatch.price = responseMatch['Cost'].toInt();
        currentMatch.matchUrl = responseMatch['MatchUrl'];
        currentMatch.creatorNotes = responseMatch['CreatorNotes'];

        creatorNotesController.text = currentMatch.creatorNotes;

        currentMatch.court = Court(responseStoreCourt['IdStoreCourt'],
            responseStoreCourt['Description'], responseStoreCourt['IsIndoor']);

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> InvitationResponse(int idUser, bool accepted) async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/InvitationResponse'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
          'idUser': idUser,
          'accepted': accepted,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus:
                accepted ? GenericStatus.Success : GenericStatus.Failed,
            message: accepted ? "Jogador Adicionado" : "Você recusou o convite",
            onTap: () {
              setState(() {
                showModal = false;
                isLoading = true;
                GetMatchInfo();
              });
            },
          );
          showModal = true;
        });
      }
    }
  }

  Future<void> JoinMatch() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/JoinMatch'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Solicitação enviada",
            onTap: () {
              setState(() {
                showModal = false;
                isLoading = true;
                GetMatchInfo();
              });
            },
          );
          showModal = true;
        });
      }
    }
  }

  Future<void> saveCreatorNotes() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SaveCreatorNotes'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
          'newCreatorNotes': creatorNotesController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentMatch.creatorNotes = creatorNotesController.text;
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Recado Salvo",
            onTap: () {
              setState(() {
                showModal = false;
                controllerHasChanged = false;
              });
            },
          );
          showModal = true;
        });
      }
    }
  }

  Future<void> LeaveMatch() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/LeaveMatch'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Você saiu da partida",
            onTap: () {
              setState(() {
                showModal = false;
                isLoading = true;
                GetMatchInfo();
              });
            },
          );
          showModal = true;
        });
      }
    }
  }

  Future<void> CancelMatch() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/CancelMatch'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Failed,
            message: "Sua partida foi cancelada",
            onTap: () {
              setState(() {
                showModal = false;
                context.goNamed('home', params: {'initialPage': 'feed_screen'});
                Provider.of<MatchProvider>(context, listen: false)
                    .needsRefresh = true;
                Provider.of<UserProvider>(context, listen: false)
                    .nextMatchNeedsRefresh = true;
              });
            },
          );
          showModal = true;
        });
      }
    }
  }

  Future<void> RemoveMatchMember(int idUserDelete) async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/RemoveMatchMember'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
          'idUserDelete': idUserDelete,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Jogador(a) excluído(a)",
            onTap: () {
              setState(() {
                showModal = false;
                isLoading = true;
                GetMatchInfo();
              });
            },
          );
          showModal = true;
        });
      }
    }
  }
}
