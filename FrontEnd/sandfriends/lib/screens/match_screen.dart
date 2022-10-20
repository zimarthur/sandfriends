import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/main.dart';
import 'package:sandfriends/models/court.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/models/match_counter.dart';
import 'package:sandfriends/models/match_member.dart';
import 'package:sandfriends/models/store_day.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/widgets/SFAvatar.dart';
import 'package:sandfriends/widgets/SF_Button.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/widgets/SF_TextField.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import '../models/city.dart';
import '../models/region.dart';
import '../models/sport.dart';
import '../models/store.dart';
import '../models/user.dart';
import '../models/validators.dart';
import '../providers/match_provider.dart';
import '../models/match.dart';
import '../providers/categories_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/Modal/SF_ModalMessage.dart';
import '../widgets/SFLoading.dart';

final _creatorNotesFormKey = GlobalKey<FormState>();

class MatchScreen extends StatefulWidget {
  final int matchUrl;
  final String returnTo;
  final String? returnToParam;
  final String? returnToParamValue;

  MatchScreen({
    required this.matchUrl,
    required this.returnTo,
    this.returnToParam,
    this.returnToParamValue,
  });
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  bool isLoading = true;
  bool showModal = false;
  Widget? modalWidget;

  bool isUserMatchCreator = false;
  bool isUserInMatch = false;
  bool matchExpired = false;

  Match currentMatch = Match();

  bool controllerHasChanged = false;

  bool referenceIsOpenMatch = false;
  int referenceMaxUsers = 0;

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
        if (widget.returnToParam == null) {
          context.goNamed(
            widget.returnTo,
          );
        } else {
          context.goNamed(widget.returnTo,
              params: {widget.returnToParam!: widget.returnToParamValue!});
        }
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
                      InkWell(
                        onTap: () {
                          setState(() {
                            isLoading = true;
                          });
                          var auxStoreDay = StoreDay();
                          auxStoreDay.store = currentMatch.store!;
                          Provider.of<MatchProvider>(context, listen: false)
                              .selectedStoreDay = auxStoreDay;
                          context.goNamed('court_screen', params: {
                            'viewOnly': 'viewOnly',
                            'returnTo': 'match_screen',
                            'returnToParam': 'matchUrl',
                            'returnToParamValue': '${widget.matchUrl}',
                          });
                        },
                        child: Container(
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
                                        padding: EdgeInsets.only(
                                            right: width * 0.1)),
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
                                              color:
                                                  AppTheme.colors.primaryBlue),
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              r'assets\icon\location_ping.svg',
                                              color:
                                                  AppTheme.colors.primaryBlue,
                                              width: 15,
                                            ),
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: width * 0.02)),
                                            Expanded(
                                              child: Text(
                                                "${currentMatch.store!.address}",
                                                style: TextStyle(
                                                  color: AppTheme
                                                      .colors.primaryBlue,
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
                                              currentMatch
                                                  .court!.storeCourtName,
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
                      ),
                      isUserMatchCreator == false &&
                              (currentMatch.creatorNotes == "" ||
                                  currentMatch.creatorNotes == null)
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
                                  child: isUserMatchCreator == true &&
                                          matchExpired == false
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
                                referenceIsOpenMatch
                                    ? "Jogadores (${currentMatch.activeMatchMembers}/${referenceMaxUsers})"
                                    : "Jogadores (${currentMatch.activeMatchMembers})",
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
                                          height: height * 0.28,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SFAvatar(
                                                height: height * 0.15,
                                                user: currentMatch
                                                    .matchMembers[index].user!,
                                                showRank: true,
                                                editFile: null,
                                                sport: currentMatch.sport,
                                              ),
                                              Container(
                                                height: height * 0.12,
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: height * 0.04,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "${currentMatch.matchMembers[index].user!.firstName} ${currentMatch.matchMembers[index].user!.lastName}",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textBlue,
                                                            fontWeight:
                                                                FontWeight.w700,
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
                                                                      .matchCounter[
                                                                          0]
                                                                      .total ==
                                                                  1
                                                              ? "${currentMatch.matchMembers[index].user!.matchCounter[0].total} jogo"
                                                              : "${currentMatch.matchMembers[index].user!.matchCounter[0].total} jogos",
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
                                                                      .age ==
                                                                  null
                                                              ? ""
                                                              : currentMatch
                                                                          .matchMembers[
                                                                              index]
                                                                          .user!
                                                                          .age! <
                                                                      18
                                                                  ? "Sub-18"
                                                                  : currentMatch
                                                                              .matchMembers[index]
                                                                              .user!
                                                                              .age! <
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
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SvgPicture.asset(
                                                          r'assets\icon\location_ping.svg',
                                                          color: AppTheme.colors
                                                              .textDarkGrey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            right: width * 0.01,
                                                          ),
                                                        ),
                                                        Container(
                                                          height:
                                                              height * 0.025,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              currentMatch
                                                                          .matchMembers[
                                                                              index]
                                                                          .user!
                                                                          .region ==
                                                                      null
                                                                  ? "-"
                                                                  : "${currentMatch.matchMembers[index].user!.region!.selectedCity!.city} / ${currentMatch.matchMembers[index].user!.region!.uf}",
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
                                                                .gender ==
                                                            null
                                                        ? "-"
                                                        : currentMatch
                                                            .matchMembers[index]
                                                            .user!
                                                            .gender!
                                                            .name,
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
                                                  ////////SFRANK
                                                  Text(
                                                    currentMatch
                                                        .matchMembers[index]
                                                        .user!
                                                        .rank[0]
                                                        .name,
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
                                                                .sidePreference ==
                                                            null
                                                        ? "-"
                                                        : currentMatch
                                                            .matchMembers[index]
                                                            .user!
                                                            .sidePreference!
                                                            .name,
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
                                                                .height ==
                                                            null
                                                        ? "-"
                                                        : "${currentMatch.matchMembers[index].user!.height!}m",
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
                                                        .user!.idUser !=
                                                    Provider.of<UserProvider>(
                                                            context,
                                                            listen: false)
                                                        .user!
                                                        .idUser &&
                                                matchExpired == false
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
                                                              .idUser!);
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
                                                  .user!.firstName!,
                                              style: TextStyle(
                                                color:
                                                    AppTheme.colors.textWhite,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          currentMatch.matchMembers[index]
                                                          .waitingApproval ==
                                                      true &&
                                                  isUserMatchCreator == false
                                              ? Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: width * 0.01),
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: width * 0.02,
                                                    vertical: width * 0.01,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: AppTheme
                                                        .colors.secondaryPaper,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16),
                                                  ),
                                                  child: Text(
                                                    "Solic. Enviada",
                                                    style: TextStyle(
                                                      color: AppTheme.colors
                                                          .secondaryYellow,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                          currentMatch.matchMembers[index]
                                                      .waitingApproval! &&
                                                  isUserMatchCreator &&
                                                  matchExpired == false
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
                                                                    .idUser!,
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
                                                                    .idUser!,
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
                                      child: SFAvatar(
                                        height: height * 0.064,
                                        showRank: true,
                                        editFile: null,
                                        user: currentMatch
                                            .matchMembers[index].user!,
                                        sport: currentMatch.sport,
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
                      isUserMatchCreator && matchExpired == false
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            currentMatch.isOpenMatch =
                                                !currentMatch.isOpenMatch;
                                            if (currentMatch.isOpenMatch ==
                                                referenceIsOpenMatch) {
                                              currentMatch.maxUsers =
                                                  referenceMaxUsers;
                                            }
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            Checkbox(
                                                activeColor:
                                                    AppTheme.colors.textBlue,
                                                value: currentMatch.isOpenMatch,
                                                onChanged: (value) {
                                                  setState(() {
                                                    currentMatch.isOpenMatch =
                                                        value!;
                                                    if (currentMatch
                                                            .isOpenMatch ==
                                                        referenceIsOpenMatch) {
                                                      currentMatch.maxUsers =
                                                          referenceMaxUsers;
                                                    }
                                                  });
                                                }),
                                            Container(
                                              height: height * 0.03,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Partida Aberta",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: currentMatch
                                                                .isOpenMatch ==
                                                            false
                                                        ? AppTheme
                                                            .colors.textDarkGrey
                                                        : AppTheme
                                                            .colors.textBlue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    referenceIsOpenMatch !=
                                                currentMatch.isOpenMatch ||
                                            referenceMaxUsers !=
                                                currentMatch.maxUsers
                                        ? SFButton(
                                            textPadding:
                                                EdgeInsets.all(width * 0.02),
                                            buttonLabel: "Salvar",
                                            buttonType: ButtonType.Primary,
                                            onTap: () {
                                              if (currentMatch.isOpenMatch ==
                                                      true &&
                                                  currentMatch.maxUsers <=
                                                      currentMatch.matchMembers
                                                          .length) {
                                                setState(() {
                                                  modalWidget = SFModalMessage(
                                                    modalStatus:
                                                        GenericStatus.Failed,
                                                    message:
                                                        "O número de jogadores que você deseja para sua partida deve ser maior do que o número de jogadores atual",
                                                    onTap: () {
                                                      setState(() {
                                                        showModal = false;
                                                      });
                                                    },
                                                  );
                                                  showModal = true;
                                                });
                                              } else {
                                                saveOpenMatch();
                                              }
                                            })
                                        : Container(),
                                  ],
                                ),
                                currentMatch.isOpenMatch == false
                                    ? Text(
                                        "Torne a partida aberta para permitir que novos jogadores solicitem para jogar com você!",
                                        style: TextStyle(
                                          color: AppTheme.colors.textDarkGrey,
                                        ),
                                        textScaleFactor: 0.85,
                                      )
                                    : Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: height * 0.01,
                                        ),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Quantos jogadores sua partida deve ter?",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.2,
                                                vertical: height * 0.02,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        if (currentMatch
                                                                .maxUsers >
                                                            1) {
                                                          currentMatch
                                                              .maxUsers--;
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      height: height * 0.06,
                                                      width: height * 0.06,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .colors.primaryBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    height *
                                                                        0.03),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "-",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppTheme
                                                                .colors
                                                                .textWhite,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: height * 0.04,
                                                    child: FittedBox(
                                                      fit: BoxFit.fitHeight,
                                                      child: Text(
                                                        "${currentMatch.maxUsers}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        currentMatch.maxUsers++;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: height * 0.06,
                                                      width: height * 0.06,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .colors.primaryBlue,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    height *
                                                                        0.03),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "+",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: AppTheme
                                                                .colors
                                                                .textWhite,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height * 0.03),
                                  child: Container(
                                    height: 1,
                                    color: AppTheme.colors.textLightGrey,
                                  ),
                                ),
                              ],
                            )
                          : Container(),
                      isUserMatchCreator
                          ? Column(
                              children: [
                                matchExpired == false
                                    ? Container(
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
                                      )
                                    : Container(),
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: height * 0.01,
                                  ),
                                ),
                                matchExpired == false
                                    ? Container(
                                        height: height * 0.05,
                                        child: SFButton(
                                          buttonLabel: "Cancelar Partida",
                                          buttonType: ButtonType.Secondary,
                                          onTap: () {
                                            CancelMatch();
                                          },
                                        ),
                                      )
                                    : Container(),
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
                                    matchExpired == false
                                        ? Container(
                                            height: height * 0.05,
                                            child: SFButton(
                                              buttonLabel: "Sair da Partida",
                                              buttonType: ButtonType.Secondary,
                                              onTap: () {
                                                LeaveMatch();
                                              },
                                            ),
                                          )
                                        : Container(),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: height * 0.01,
                                      ),
                                    ),
                                  ],
                                )
                              : matchExpired == false
                                  ? Column(
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
                                    )
                                  : Container(),
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
          final responseLogin = responseBody['login'];
          final responseUser = responseBody['user'];
          final responseUserRanks = responseBody['userRanks'];
          final responseUserMatchCounter = responseBody['matchCounter'];
          final responseUserCity = responseBody['userCity'];
          final responseUserState = responseBody['userState'];

          Provider.of<UserProvider>(context, listen: false).userFromJson(
              responseUser,
              Provider.of<CategoriesProvider>(context, listen: false));
          Provider.of<UserProvider>(context, listen: false).userRankFromJson(
              responseUserRanks,
              Provider.of<CategoriesProvider>(context, listen: false));
          Provider.of<UserProvider>(context, listen: false)
              .userMatchCounterFromJson(responseUserMatchCounter,
                  Provider.of<CategoriesProvider>(context, listen: false));
          Provider.of<UserProvider>(context, listen: false).user!.email =
              responseBody['userEmail'];

          Provider.of<UserProvider>(context, listen: false).user!.region =
              Region(
                  idState: responseUserState['IdState'],
                  state: responseUserState['State'],
                  uf: responseUserState['UF']);
          Provider.of<UserProvider>(context, listen: false)
                  .user!
                  .region!
                  .selectedCity =
              City(
                  cityId: responseUserCity['IdCity'],
                  city: responseUserCity['City']);

          final newAccessToken = responseLogin['AccessToken'];
          await storage.write(key: "AccessToken", value: newAccessToken);
          if (responseLogin['EmailConfirmationDate'] == null) {
            context.goNamed('login_signup');
          } else if (responseLogin['IsNewUser'] == true) {
            context.goNamed('new_user_welcome');
          } else {
            context.go('/home/feed_screen');
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
        final responseUsersMatchCounter = responseBody['usersMatchCounter'];
        final responseUsersRanks = responseBody['userRanks'];

        if (Provider.of<CategoriesProvider>(context, listen: false)
            .sports
            .isEmpty) {
          for (int i = 0; i < responseSports.length; i++) {
            Provider.of<CategoriesProvider>(context, listen: false).sports.add(
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
          newStore.phone = responseStore['PhoneNumber1'];
          for (int photoIndex = 0;
              photoIndex < responseStorePhoto.length;
              photoIndex++) {
            newStore.addPhoto(responseStorePhoto[photoIndex]['Photo']);
          }
          Provider.of<StoreProvider>(context, listen: false)
              .stores
              .add(newStore);
        }
        List<User> usersList = [];
        for (int i = 0; i < responseUsers.length; i++) {
          var gender;
          var sidePreference;
          for (int j = 0;
              j <
                  Provider.of<CategoriesProvider>(context, listen: false)
                      .genders
                      .length;
              j++) {
            if (Provider.of<CategoriesProvider>(context, listen: false)
                    .genders[j]
                    .idGender ==
                responseUsers[i]['IdGenderCategory']) {
              gender = Provider.of<CategoriesProvider>(context, listen: false)
                  .genders[j];
            }
          }
          for (int k = 0;
              k <
                  Provider.of<CategoriesProvider>(context, listen: false)
                      .sidePreferences
                      .length;
              k++) {
            if (Provider.of<CategoriesProvider>(context, listen: false)
                    .sidePreferences[k]
                    .idSidePreference ==
                responseUsers[i]['IdSidePreferenceCategory']) {
              sidePreference =
                  Provider.of<CategoriesProvider>(context, listen: false)
                      .sidePreferences[k];
            }
          }
          var newUser = User(
            idUser: responseUsers[i]['IdUser'],
            firstName: responseUsers[i]['FirstName'],
            lastName: responseUsers[i]['LastName'],
            phoneNumber: responseUsers[i]['PhoneNumber'],
            gender: gender,
            birthday: responseUsers[i]['Birthday'],
            age: responseUsers[i]['Age'],
            height: responseUsers[i]['Height'],
            sidePreference: sidePreference,
            photo: responseUsers[i]['Photo'],
          );

          bool foundUserRank = false;
          var newRank;
          for (int userRanksIndex = 0;
              userRanksIndex < responseUsersRanks.length;
              userRanksIndex++) {
            if (responseUsersRanks[userRanksIndex]['IdUser'] ==
                newUser.idUser) {
              Provider.of<CategoriesProvider>(context, listen: false)
                  .ranks
                  .forEach((rank) {
                if (rank.idRankCategory ==
                    responseUsersRanks[userRanksIndex]['IdRankCategory']) {
                  newRank = rank;
                  foundUserRank = true;
                }
              });
            }
          }
          if (foundUserRank == false) {
            Provider.of<CategoriesProvider>(context, listen: false)
                .ranks
                .forEach((rank) {
              if ((rank.rankSportLevel == 0) &&
                  (rank.sport.idSport == responseMatch['IdSport'])) {
                newRank = rank;
              }
            });
          }
          newUser.rank.add(newRank);

          for (int matchCounterIndex = 0;
              matchCounterIndex < responseUsersMatchCounter.length;
              matchCounterIndex++) {
            if (responseUsersMatchCounter[matchCounterIndex]['IdUser'] ==
                newUser.idUser) {
              var newSport;
              Provider.of<CategoriesProvider>(context, listen: false)
                  .sports
                  .forEach((sport) {
                if (sport.idSport == responseMatch['IdSport']) {
                  newSport = sport;
                }
              });
              newUser.matchCounter.add(
                MatchCounter(
                  total: responseUsersMatchCounter[matchCounterIndex]
                      ['MatchCounter'],
                  sport: newSport,
                ),
              );
            }
          }
          usersList.add(newUser);
        }

        isUserInMatch = false;
        for (int i = 0; i < responseMatchMembers.length; i++) {
          if (responseMatchMembers[i]['IdUser'] ==
              Provider.of<UserProvider>(context, listen: false).user!.idUser) {
            isUserInMatch = true;
          }
          for (int userListIndex = 0;
              userListIndex < usersList.length;
              userListIndex++) {
            if (usersList[userListIndex].idUser ==
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
                currentMatch.userCreator = usersList[userListIndex].firstName!;
                if (Provider.of<UserProvider>(context, listen: false)
                        .user!
                        .idUser ==
                    usersList[userListIndex].idUser) {
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
                  member.user!.idUser ==
                      Provider.of<UserProvider>(context, listen: false)
                          .user!
                          .idUser)
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
        Provider.of<CategoriesProvider>(context, listen: false)
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
        currentMatch.price = responseMatch['Cost'];
        currentMatch.matchUrl = responseMatch['MatchUrl'];
        currentMatch.creatorNotes = responseMatch['CreatorNotes'];
        currentMatch.canceled = responseMatch['Canceled'];
        currentMatch.isOpenMatch = responseMatch['OpenUsers'];
        if (responseMatch['MaxUsers'] == 0) {
          currentMatch.maxUsers = 4;
        } else {
          currentMatch.maxUsers = responseMatch['MaxUsers'];
        }

        referenceIsOpenMatch = responseMatch['OpenUsers'];
        if (responseMatch['MaxUsers'] == 0) {
          referenceMaxUsers = 4;
        } else {
          referenceMaxUsers = responseMatch['MaxUsers'];
        }

        creatorNotesController.text = currentMatch.creatorNotes;

        currentMatch.court = Court(responseStoreCourt['IdStoreCourt'],
            responseStoreCourt['Description'], responseStoreCourt['IsIndoor']);

        if ((currentMatch.day!.isBefore(DateTime.now())) ||
            ((currentMatch.day!.day == DateTime.now().day) &&
                (currentMatch.timeInt < DateTime.now().hour)) ||
            (currentMatch.canceled == true)) {
          matchExpired = true;
        }
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

  Future<void> saveOpenMatch() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/SaveOpenMatch'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, Object>{
          'accessToken': accessToken,
          'idMatch': currentMatch.idMatch!,
          'isOpenMatch': currentMatch.isOpenMatch,
          'maxUsers': currentMatch.maxUsers,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          referenceIsOpenMatch = currentMatch.isOpenMatch;
          referenceMaxUsers = currentMatch.maxUsers;
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message: "Sua partida foi alterada",
            onTap: () {
              setState(() {
                showModal = false;
              });
            },
          );
          showModal = true;
        });
      } else {
        setState(() {
          currentMatch.creatorNotes = creatorNotesController.text;
          isLoading = false;
          modalWidget = SFModalMessage(
            modalStatus: GenericStatus.Success,
            message:
                "Não foi possível alterar suas informações. Tente novamente.",
            onTap: () {
              setState(() {
                showModal = false;
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
