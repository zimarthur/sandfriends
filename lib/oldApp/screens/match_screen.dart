import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/main.dart';
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/models/match_counter.dart';
import 'package:sandfriends/oldApp/models/store_day.dart';
import 'package:sandfriends/oldApp/providers/user_provider.dart';
import 'package:sandfriends/oldApp/widgets/SFAvatar.dart';
import 'package:sandfriends/oldApp/widgets/SF_Button.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:sandfriends/oldApp/widgets/SF_TextField.dart';
import 'dart:convert';
import 'package:share_plus/share_plus.dart';

import '../models/user.dart';
import '../models/validators.dart';
import '../providers/match_provider.dart';
import '../models/match.dart';
import '../theme/app_theme.dart';
import '../widgets/Modal/SFModalMessageCopy.dart';
import '../../SharedComponents/View/SFLoading.dart';

final _creatorNotesFormKey = GlobalKey<FormState>();

class MatchScreen extends StatefulWidget {
  final int matchUrl;
  final String returnTo;
  final String? returnToParam;
  final String? returnToParamValue;

  const MatchScreen({
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

  Match? currentMatch;

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
      titleText: currentMatch == null
          ? ""
          : "Partida de ${currentMatch!.matchCreator.firstName}",
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
      child: RefreshIndicator(
        onRefresh: GetMatchInfo,
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
                        child: const Center(
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
                            var auxStoreDay =
                                StoreDay(store: currentMatch!.court.store);

                            Provider.of<MatchProvider>(context, listen: false)
                                .selectedStoreDay = auxStoreDay;
                            context.goNamed('court_screen', params: {
                              'viewOnly': 'viewOnly',
                              'returnTo': 'match_screen',
                              'returnToParam': 'matchUrl',
                              'returnToParamValue': '${widget.matchUrl}',
                              'isRecurrentMatch': 'null'
                            });
                          },
                          child: SizedBox(
                            height: height * 0.2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  //LOCAL
                                  height: height * 0.03,
                                  margin: EdgeInsets.only(top: height * 0.01),
                                  child: const FittedBox(
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
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                        child: CachedNetworkImage(
                                          imageUrl: currentMatch!
                                              .court.store.imageUrl,
                                          height: height * 0.13,
                                          width: height * 0.13,
                                          placeholder: (context, url) =>
                                              Container(
                                            height: height * 0.13,
                                            width: height * 0.13,
                                            child: Center(
                                              child: SFLoading(),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            color: AppTheme.colors.textLightGrey
                                                .withOpacity(0.5),
                                            height: height * 0.13,
                                            width: height * 0.13,
                                            child: Center(
                                              child: Icon(Icons.dangerous),
                                            ),
                                          ),
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
                                            currentMatch!.court.store.name,
                                            textScaleFactor: 1.5,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: AppTheme
                                                    .colors.primaryBlue),
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
                                                  currentMatch!
                                                      .court.store.address,
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
                                                currentMatch!
                                                    .court.storeCourtName,
                                              ),
                                              Text(
                                                currentMatch!.court.isIndoor
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
                                (currentMatch!.creatorNotes == "")
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
                                            "Recado de ${currentMatch!.matchCreator.firstName}",
                                            style: const TextStyle(
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
                                                        currentMatch!
                                                            .creatorNotes) {
                                                      controllerHasChanged =
                                                          true;
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
                                        : SizedBox(
                                            child: Text(
                                                currentMatch!.creatorNotes),
                                            width: double.infinity),
                                  ),
                                ],
                              ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.03),
                          child: Container(
                            height: 1,
                            color: AppTheme.colors.textLightGrey,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    height: height * 0.03,
                                    child: const FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "Detalhes da Partida",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  currentMatch!.canceled
                                      ? SizedBox(
                                          height: height * 0.03,
                                          child: const FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "Cancelada",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        )
                                      : currentMatch!.date
                                              .isBefore(DateTime.now())
                                          ? SizedBox(
                                              height: height * 0.03,
                                              child: FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  "Encerrada",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: AppTheme.colors
                                                          .textLightGrey),
                                                ),
                                              ),
                                            )
                                          : Container()
                                ],
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
                                          const Text(
                                            "Data:",
                                          ),
                                          Text(
                                            DateFormat("dd/MM/yyyy")
                                                .format(currentMatch!.date),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Horário:",
                                          ),
                                          Text(
                                            "${currentMatch!.timeBegin} - ${currentMatch!.timeFinish}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Preço:",
                                          ),
                                          Text(
                                            "R\$ ${currentMatch!.cost}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Esporte:",
                                          ),
                                          Text(
                                            currentMatch!.sport.description,
                                            style: const TextStyle(
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
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.03),
                          child: Container(
                            height: 1,
                            color: AppTheme.colors.textLightGrey,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.03,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Text(
                                  referenceIsOpenMatch
                                      ? "Jogadores (${currentMatch!.activeMatchMembers}/$referenceMaxUsers)"
                                      : "Jogadores (${currentMatch!.activeMatchMembers})",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.05,
                              vertical: height * 0.02),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: currentMatch!.members.length,
                            itemBuilder: (context, index) {
                              if (currentMatch!.members[index].quit == true ||
                                  (currentMatch!.members[index].refused ==
                                      true) ||
                                  ((currentMatch!
                                              .members[index].waitingApproval ==
                                          true) &&
                                      (currentMatch!
                                              .members[index].user.idUser !=
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .user!
                                              .idUser) &&
                                      (isUserMatchCreator == false))) {
                                return Container();
                              } else {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      modalWidget = SizedBox(
                                        height: height * 0.6,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: height * 0.28,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SFAvatar(
                                                    height: height * 0.15,
                                                    user: currentMatch!
                                                        .members[index].user,
                                                    showRank: true,
                                                    editFile: null,
                                                    sport: currentMatch!.sport,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.12,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: height * 0.04,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              "${currentMatch!.members[index].user.firstName} ${currentMatch!.members[index].user.lastName}",
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .colors
                                                                    .textBlue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.025,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              currentMatch!
                                                                          .members[
                                                                              index]
                                                                          .user
                                                                          .matchCounter[
                                                                              0]
                                                                          .total ==
                                                                      1
                                                                  ? "${currentMatch!.members[index].user.matchCounter[0].total} jogo"
                                                                  : "${currentMatch!.members[index].user.matchCounter[0].total} jogos",
                                                              style: TextStyle(
                                                                color: AppTheme
                                                                    .colors
                                                                    .textDarkGrey,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.025,
                                                          child: FittedBox(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            child: Text(
                                                              currentMatch!
                                                                          .members[
                                                                              index]
                                                                          .user
                                                                          .age ==
                                                                      null
                                                                  ? ""
                                                                  : currentMatch!
                                                                              .members[
                                                                                  index]
                                                                              .user
                                                                              .age! <
                                                                          18
                                                                      ? "Sub-18"
                                                                      : currentMatch!.members[index].user.age! <
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
                                                              color: AppTheme
                                                                  .colors
                                                                  .textDarkGrey,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                right: width *
                                                                    0.01,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: height *
                                                                  0.025,
                                                              child: FittedBox(
                                                                fit: BoxFit
                                                                    .fitHeight,
                                                                child: Text(
                                                                  currentMatch!
                                                                              .members[index]
                                                                              .user
                                                                              .city ==
                                                                          null
                                                                      ? "-"
                                                                      : "${currentMatch!.members[index].user.city!.city} / ${currentMatch!.members[index].user.city!.state!.uf}",
                                                                  style:
                                                                      TextStyle(
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
                                            SizedBox(
                                              height: height * 0.2,
                                              width: width * 0.6,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text("Gênero:"),
                                                      Text(
                                                        currentMatch!
                                                                    .members[
                                                                        index]
                                                                    .user
                                                                    .gender ==
                                                                null
                                                            ? "-"
                                                            : currentMatch!
                                                                .members[index]
                                                                .user
                                                                .gender!
                                                                .name,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text("Rank:"),
                                                      ////////SFRANK
                                                      Text(
                                                        currentMatch!
                                                            .members[index]
                                                            .user
                                                            .rank[0]
                                                            .name,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text("Mão:"),
                                                      Text(
                                                        currentMatch!
                                                                    .members[
                                                                        index]
                                                                    .user
                                                                    .sidePreference ==
                                                                null
                                                            ? "-"
                                                            : currentMatch!
                                                                .members[index]
                                                                .user
                                                                .sidePreference!
                                                                .name,
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text("Altura:"),
                                                      Text(
                                                        currentMatch!
                                                                    .members[
                                                                        index]
                                                                    .user
                                                                    .height ==
                                                                null
                                                            ? "-"
                                                            : "${currentMatch!.members[index].user.height!}m",
                                                        style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textBlue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            isUserMatchCreator &&
                                                    currentMatch!.members[index]
                                                            .user.idUser !=
                                                        Provider.of<UserProvider>(
                                                                context,
                                                                listen: false)
                                                            .user!
                                                            .idUser &&
                                                    matchExpired == false
                                                ? SizedBox(
                                                    width: width * 0.5,
                                                    child: SFButton(
                                                        buttonLabel:
                                                            "Excluir Jogador",
                                                        buttonType:
                                                            ButtonType.Primary,
                                                        textPadding: EdgeInsets
                                                            .symmetric(
                                                                vertical:
                                                                    height *
                                                                        0.01),
                                                        onTap: () {
                                                          RemoveMatchMember(
                                                              currentMatch!
                                                                  .members[
                                                                      index]
                                                                  .user
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
                                          padding: EdgeInsets.only(
                                              left: height * 0.06),
                                          alignment: Alignment.centerLeft,
                                          height: height * 0.05,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: currentMatch!.members[index]
                                                    .waitingApproval
                                                ? AppTheme
                                                    .colors.secondaryYellow
                                                : AppTheme
                                                    .colors.primaryLightBlue,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  currentMatch!.members[index]
                                                      .user.firstName!,
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .colors.textWhite,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              currentMatch!.members[index]
                                                              .waitingApproval ==
                                                          true &&
                                                      isUserMatchCreator ==
                                                          false
                                                  ? Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.01),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            width * 0.02,
                                                        vertical: width * 0.01,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.colors
                                                            .secondaryPaper,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
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
                                              currentMatch!.members[index]
                                                          .waitingApproval &&
                                                      isUserMatchCreator &&
                                                      matchExpired == false
                                                  ? Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: InkWell(
                                                            onTap: () =>
                                                                InvitationResponse(
                                                                    currentMatch!
                                                                        .members[
                                                                            index]
                                                                        .user
                                                                        .idUser!,
                                                                    true),
                                                            child: SvgPicture
                                                                .asset(
                                                              r'assets\icon\confirm.svg',
                                                              color: AppTheme
                                                                  .colors
                                                                  .secondaryGreen,
                                                              height:
                                                                  height * 0.03,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      width *
                                                                          0.02),
                                                          child: InkWell(
                                                            onTap: () =>
                                                                InvitationResponse(
                                                                    currentMatch!
                                                                        .members[
                                                                            index]
                                                                        .user
                                                                        .idUser!,
                                                                    false),
                                                            child: SvgPicture
                                                                .asset(
                                                              r'assets\icon\cancel.svg',
                                                              color: Colors.red,
                                                              height:
                                                                  height * 0.03,
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
                                            user: currentMatch!
                                                .members[index].user,
                                            sport: currentMatch!.sport,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height * 0.03),
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
                                              currentMatch!.isOpenMatch =
                                                  !currentMatch!.isOpenMatch;
                                              if (currentMatch!.isOpenMatch ==
                                                  referenceIsOpenMatch) {
                                                currentMatch!.maxUsers =
                                                    referenceMaxUsers;
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Checkbox(
                                                  activeColor:
                                                      AppTheme.colors.textBlue,
                                                  value:
                                                      currentMatch!.isOpenMatch,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      currentMatch!
                                                          .isOpenMatch = value!;
                                                      if (currentMatch!
                                                              .isOpenMatch ==
                                                          referenceIsOpenMatch) {
                                                        currentMatch!.maxUsers =
                                                            referenceMaxUsers;
                                                      }
                                                    });
                                                  }),
                                              SizedBox(
                                                height: height * 0.03,
                                                child: FittedBox(
                                                  fit: BoxFit.fitHeight,
                                                  child: Text(
                                                    "Partida Aberta",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: currentMatch!
                                                                  .isOpenMatch ==
                                                              false
                                                          ? AppTheme.colors
                                                              .textDarkGrey
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
                                                  currentMatch!.isOpenMatch ||
                                              referenceMaxUsers !=
                                                  currentMatch!.maxUsers
                                          ? SFButton(
                                              textPadding:
                                                  EdgeInsets.all(width * 0.02),
                                              buttonLabel: "Salvar",
                                              buttonType: ButtonType.Primary,
                                              onTap: () {
                                                if (currentMatch!.isOpenMatch ==
                                                        true &&
                                                    currentMatch!.maxUsers <=
                                                        currentMatch!
                                                            .activeMatchMembers) {
                                                  setState(() {
                                                    modalWidget =
                                                        SFModalMessageCopy(
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
                                  currentMatch!.isOpenMatch == false
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
                                              const Text(
                                                "Quantos jogadores sua partida deve ter?",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w500),
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
                                                          currentMatch!
                                                              .reduceMaxUser();
                                                        });
                                                      },
                                                      child: Container(
                                                        height: height * 0.06,
                                                        width: height * 0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.colors
                                                              .primaryBlue,
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
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppTheme
                                                                  .colors
                                                                  .textWhite,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.04,
                                                      child: FittedBox(
                                                        fit: BoxFit.fitHeight,
                                                        child: Text(
                                                          "${currentMatch!.maxUsers}",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          currentMatch!
                                                              .increaseMaxUser();
                                                        });
                                                      },
                                                      child: Container(
                                                        height: height * 0.06,
                                                        width: height * 0.06,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme.colors
                                                              .primaryBlue,
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
                                                                  FontWeight
                                                                      .w700,
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
                                      ? SizedBox(
                                          height: height * 0.05,
                                          child: SFButton(
                                            buttonLabel: "Convidar Jogadores",
                                            buttonType: ButtonType.Primary,
                                            iconPath: r"assets\icon\share.svg",
                                            onTap: () async {
                                              await Share.share(
                                                  'Entre na minha partida!\n https://www.sandfriends.com.br/redirect/?ct=mtch&bd=${currentMatch!.matchUrl}');
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
                                      ? SizedBox(
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
                                  matchExpired == false
                                      ? Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: height * 0.01),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "*Cancelamento Gratuito até o dia ${currentMatch!.canCancelUpTo}",
                                            textScaleFactor: 0.9,
                                            style: TextStyle(
                                                color: AppTheme
                                                    .colors.textDarkGrey),
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : isUserInMatch
                                ? Column(
                                    children: [
                                      matchExpired == false
                                          ? SizedBox(
                                              height: height * 0.05,
                                              child: SFButton(
                                                buttonLabel: "Sair da Partida",
                                                buttonType:
                                                    ButtonType.Secondary,
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
                                          SizedBox(
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
      ),
    );
  }

  Future<void> GetMatchInfo() async {
    setState(() {
      isLoading = true;
    });
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

          final responseLogin = responseBody['UserLogin'];

          final newAccessToken = responseLogin['AccessToken'];
          await storage.write(key: "AccessToken", value: newAccessToken);

          if (responseLogin['EmailConfirmationDate'] == null) {
            context.goNamed('login_signup');
          } else if (responseLogin['IsNewUser'] == true) {
            context.goNamed('new_user_welcome');
          } else {
            final responseUser = responseBody['User'];
            final responseUserMatchCounter = responseBody['MatchCounter'];

            Provider.of<UserProvider>(context, listen: false).user =
                User.fromJson(responseUser);
            Provider.of<UserProvider>(context, listen: false)
                .userMatchCounterFromJson(
                    responseUserMatchCounter, categoriesProvider);
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
        Map<String, dynamic> responseBody = json.decode(response.body);
        final responseMatch = responseBody['Match'];
        final responseUsersMatchCounter = responseBody['UsersMatchCounter'];

        currentMatch = matchFromJson(responseMatch);

        isUserInMatch = false;
        for (int i = 0; i < currentMatch!.members.length; i++) {
          for (int j = 0; j < responseUsersMatchCounter.length; j++) {
            if (currentMatch!.members[i].user.idUser ==
                responseUsersMatchCounter[j]['IdUser']) {
              currentMatch!.members[i].user.matchCounter.clear();
              currentMatch!.members[i].user.matchCounter.add(MatchCounter(
                total: responseUsersMatchCounter[j]['MatchCounter'],
                sport: currentMatch!.sport,
              ));
            }
          }
          if (currentMatch!.members[i].user.idUser ==
              Provider.of<UserProvider>(context, listen: false).user!.idUser) {
            if (currentMatch!.members[i].quit == true ||
                currentMatch!.members[i].refused == true ||
                currentMatch!.members[i].waitingApproval == true) {
              isUserInMatch = false;
            } else {
              isUserInMatch = true;
            }

            if (currentMatch!.members[i].isMatchCreator) {
              isUserMatchCreator = true;
            } else {
              isUserMatchCreator = false;
            }
          }
        }

        referenceIsOpenMatch = responseMatch['OpenUsers'];
        if (currentMatch!.maxUsers == 0) {
          currentMatch!.maxUsers = 4;
          referenceMaxUsers = 4;
        } else {
          referenceMaxUsers = currentMatch!.maxUsers;
        }

        creatorNotesController.text = currentMatch!.creatorNotes;

        if ((currentMatch!.date.isBefore(DateTime.now())) ||
            ((currentMatch!.date.day == DateTime.now().day) &&
                (currentMatch!.timeInt < DateTime.now().hour)) ||
            (currentMatch!.canceled == true)) {
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
          'idMatch': currentMatch!.idMatch,
          'idUser': idUser,
          'accepted': accepted,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          'idMatch': currentMatch!.idMatch,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          'idMatch': currentMatch!.idMatch,
          'isOpenMatch': currentMatch!.isOpenMatch,
          'maxUsers': currentMatch!.maxUsers,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          referenceIsOpenMatch = currentMatch!.isOpenMatch;
          referenceMaxUsers = currentMatch!.maxUsers;
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          currentMatch!.creatorNotes = creatorNotesController.text;
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          'idMatch': currentMatch!.idMatch,
          'newCreatorNotes': creatorNotesController.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          currentMatch!.creatorNotes = creatorNotesController.text;
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          'idMatch': currentMatch!.idMatch,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
          'idMatch': currentMatch!.idMatch,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
            modalStatus: GenericStatus.Failed,
            message: "Sua partida foi cancelada",
            onTap: () {
              setState(() {
                showModal = false;
                context.goNamed('home', params: {'initialPage': 'feed_screen'});
                Provider.of<MatchProvider>(context, listen: false)
                    .needsRefresh = true;
                Provider.of<UserProvider>(context, listen: false)
                    .feedNeedsRefresh = true;
              });
            },
          );
          showModal = true;
        });
      } else if (response.statusCode == 416) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
            modalStatus: GenericStatus.Failed,
            message:
                "Você podia ter cancelado sua partida até o dia ${currentMatch!.canCancelUpTo}",
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
          'idMatch': currentMatch!.idMatch,
          'idUserDelete': idUserDelete,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          modalWidget = SFModalMessageCopy(
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
