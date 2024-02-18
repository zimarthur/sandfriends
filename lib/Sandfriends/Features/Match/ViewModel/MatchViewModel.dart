import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Sandfriends/Features/Match/View/MemberCardModal.dart';
import 'package:sandfriends/Sandfriends/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Common/Model/PaymentStatus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../Common/Components/Modal/ConfirmationModal.dart';
import '../../../../Common/Model/AppMatch/AppMatchUser.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Common/Utils/PageStatus.dart';
import '../../../../Common/Model/MatchCounter.dart';
import '../../../../Common/Model/MatchMember.dart';
import '../../../../Common/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../Providers/UserProvider/UserProvider.dart';
import '../../../../Common/Components/Modal/SFModalMessage.dart';
import '../Repository/MatchRepo.dart';

class MatchViewModel extends StandardScreenViewModel {
  final matchRepo = MatchRepo();

  String titleText = "";
  late AppMatchUser match;
  bool isMatchInstantiated = false;
  late UserComplete loggedUser;

  bool _copiedToClipboard = false;
  bool get copyToClipboard => _copiedToClipboard;
  void setCopyToClipBoard(bool newValue) {
    _copiedToClipboard = newValue;
    notifyListeners();
  }

  DateTime liveDatetime = DateTime.now();
  void setLiveDateTime(DateTime datetime) {
    liveDatetime = datetime;
    notifyListeners();
  }

  String? get timeToExpirePayment {
    if (liveDatetime.isAfter(match.paymentExpirationDate)) return null;
    int difference =
        match.paymentExpirationDate.difference(DateTime.now()).inSeconds;
    return "${(difference ~/ 60).toString().padLeft(2, '0')}:${(difference % 60).toString().padLeft(2, '0')}";
  }

  bool _isUserInMatch = false;
  bool get isUserInMatch => _isUserInMatch;
  set isUserInMatch(bool newValue) {
    _isUserInMatch = newValue;
    notifyListeners();
  }

  bool _isUserMatchCreator = false;
  bool get isUserMatchCreator => _isUserMatchCreator;
  set isUserMatchCreator(bool newValue) {
    _isUserMatchCreator = newValue;
    notifyListeners();
  }

  bool _matchExpired = false;
  bool get matchExpired => _matchExpired;
  set matchExpired(bool newValue) {
    _matchExpired = newValue;
    notifyListeners();
  }

  final creatorNotesFormKey = GlobalKey<FormState>();

  bool controllerHasChanged = false;

  void onCreatorNotesChanged(String newValue) {
    controllerHasChanged = match.creatorNotes != newValue;
    notifyListeners();
  }

  bool referenceIsOpenMatch = false;
  int referenceMaxUsers = 0;

  TextEditingController creatorNotesController = TextEditingController();

  bool get hideCreatorNotes => !isUserInMatch && match.creatorNotes == "";

  void initMatchViewModel(BuildContext context, String matchUrl) {
    loggedUser = Provider.of<UserProvider>(context, listen: false).user!;
    getMatchInfo(context, matchUrl);
    notifyListeners();
  }

  bool hideMember(MatchMember member, BuildContext context) {
    return (member.quit ||
        (member.refused) ||
        ((member.waitingApproval) &&
            (member.user.id !=
                Provider.of<UserProvider>(context, listen: false).user!.id) &&
            (isUserMatchCreator == false)));
  }

  Future<void> getMatchInfo(BuildContext context, String matchUrl) async {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo.getMatchInfo(context, matchUrl).then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        setCopyToClipBoard(false);
        match = AppMatchUser.fromJson(
          responseBody['Match'],
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        );
        final responseUsersMatchCounter = responseBody['UsersMatchCounter'];

        for (int i = 0; i < match.members.length; i++) {
          for (int j = 0; j < responseUsersMatchCounter.length; j++) {
            if (match.members[i].user.id ==
                responseUsersMatchCounter[j]['IdUser']) {
              match.members[i].user.matchCounter.clear();
              match.members[i].user.matchCounter.add(
                MatchCounter(
                  total: responseUsersMatchCounter[j]['MatchCounter'],
                  sport: match.sport,
                ),
              );
            }
          }
          if (match.members[i].user.id == loggedUser.id) {
            if (match.members[i].quit == true ||
                match.members[i].refused == true ||
                match.members[i].waitingApproval == true) {
              _isUserInMatch = false;
            } else {
              _isUserInMatch = true;
            }

            if (match.members[i].isMatchCreator) {
              isUserMatchCreator = true;
            } else {
              isUserMatchCreator = false;
            }
          }
        }

        referenceIsOpenMatch = match.isOpenMatch;
        if (match.maxUsers == 0) {
          match.maxUsers = 4;
          referenceMaxUsers = 4;
        } else {
          referenceMaxUsers = match.maxUsers;
        }

        titleText = "Partida de ${match.matchCreator.firstName}";
        creatorNotesController.text = match.creatorNotes;

        if ((match.date.isBefore(DateTime.now())) ||
            ((match.date.day == DateTime.now().day) &&
                (match.timeBegin.hour < DateTime.now().hour)) ||
            (match.canceled == true)) {
          matchExpired = true;
        }
        isMatchInstantiated = true;
        pageStatus = PageStatus.OK;
        notifyListeners();
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              Navigator.pushNamed(context, '/home');
            }
          },
          isHappy: false,
        );
        canTapBackground = false;

        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void shareMatch(BuildContext context) async {
    if (match.paymentStatus == PaymentStatus.Pending) {
      modalMessage = SFModalMessage(
        title: "Você precisa finalizar o pagamento antes de convidar jogadores",
        onTap: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        isHappy: false,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    } else {
      await Share.share(
          'Entre na minha partida!\n ${Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder("/redirect/?ct=mtch&bd=${match.matchUrl}")}');
    }
  }

  @override
  void onTapReturn(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, '/home');
    }
  }

  void onTapStore(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/court',
      arguments: {
        'store': match.court.store!,
      },
    );
  }

  void saveCreatorNotes(BuildContext context) {
    if (creatorNotesFormKey.currentState?.validate() == true) {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      matchRepo
          .saveCreatorNotes(
        context,
        loggedUser.accessToken,
        match.idMatch,
        creatorNotesController.text,
      )
          .then((response) {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () {
            closeModal();
            if (response.responseStatus == NetworkResponseStatus.alert) {
              match.creatorNotes = creatorNotesController.text;
              controllerHasChanged = false;
            }
            notifyListeners();
          },
          isHappy: response.responseStatus == NetworkResponseStatus.alert,
        );

        pageStatus = PageStatus.ERROR;
        notifyListeners();
      });
    }
  }

  void openMemberCardModal(BuildContext context, MatchMember member) {
    widgetForm = MemberCardModal(
      viewModel: this,
      member: member,
      onAccept: () => invitationResponse(context, member.user.id!, true),
      onRefuse: () => invitationResponse(context, member.user.id!, false),
      onRemove: () => removeMatchMember(context, member.user.id!),
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void invitationResponse(BuildContext context, int id, bool accepted) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .invitationResponse(
      context,
      loggedUser.accessToken,
      match.idMatch,
      id,
      accepted,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        modalMessage = SFModalMessage(
          title: accepted ? "Convite aceito" : "Convite recusado",
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
            getMatchInfo(context, match.matchUrl);
          },
          isHappy: accepted,
        );
      } else {
        modalMessage = SFModalMessage(
          title: response.responseTitle!,
          onTap: () {
            if (response.responseStatus == NetworkResponseStatus.expiredToken) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login_signup',
                (Route<dynamic> route) => false,
              );
            } else {
              pageStatus = PageStatus.OK;
              notifyListeners();
            }
          },
          isHappy: accepted,
        );
      }
      canTapBackground = false;

      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void removeMatchMember(BuildContext context, int id) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .removeMatchMember(
          context,
          loggedUser.accessToken,
          match.idMatch,
          id,
        )
        .then(
          (response) => defaultResponse(
            response,
            context,
          ),
        );
  }

  void confirmCancelMatch(BuildContext context) {
    widgetForm = ConfirmationModal(
        message: "Deseja mesmo cancelar a partida?",
        onConfirm: () => cancelMatch(context),
        onCancel: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        isHappy: false);
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void cancelMatch(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .cancelMatch(
          context,
          loggedUser.accessToken,
          match.idMatch,
        )
        .then(
          (response) => defaultResponse(
            response,
            context,
          ),
        );
  }

  void leaveMatch(BuildContext context) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .leaveMatch(
          context,
          loggedUser.accessToken,
          match.idMatch,
        )
        .then((response) => defaultResponse(response, context));
  }

  void joinMatch(BuildContext context) {
    if (!userHasConfiguredRank(context) && match.isOpenMatch) {
      modalMessage = SFModalMessage(
        title:
            "Configure seu rank em ${match.sport.description} para entrar em uma partida aberta",
        onTap: () {
          Navigator.pushNamed(
            context,
            "/user_details",
            arguments: {
              'initSport': match.sport,
              'userDetailsModal': UserDetailsModals.Rank,
            },
          );
        },
        buttonIconPath: r"assets/icon/configure.svg",
        buttonText: "Configurar",
        isHappy: false,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    } else {
      pageStatus = PageStatus.LOADING;
      notifyListeners();
      matchRepo
          .joinMatch(
            context,
            loggedUser.accessToken,
            match.idMatch,
          )
          .then((response) => defaultResponse(response, context));
    }
  }

  bool userHasConfiguredRank(BuildContext context) {
    return Provider.of<UserProvider>(context, listen: false)
            .user!
            .ranks
            .firstWhere((rank) => rank.sport.idSport == match.sport.idSport)
            .rankSportLevel !=
        0;
  }

  void saveOpenMatchChanges(BuildContext context) {
    if (match.paymentStatus == PaymentStatus.Pending) {
      modalMessage = SFModalMessage(
        title: "Você precisa finalizar o pagamento antes de abrir a partida",
        onTap: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        isHappy: false,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    } else if (!userHasConfiguredRank(context)) {
      modalMessage = SFModalMessage(
        title:
            "Antes de abrir uma partida você precisa configurar seu rank em ${match.sport.description}",
        onTap: () {
          pageStatus = PageStatus.OK;
          notifyListeners();
        },
        isHappy: false,
      );
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    } else {
      if (match.isOpenMatch == true &&
          match.maxUsers <= match.activeMatchMembers) {
        modalMessage = SFModalMessage(
          title:
              "O número de jogadores que você deseja para sua partida deve ser maior do que o número de jogadores atual",
          onTap: () {
            pageStatus = PageStatus.OK;
            notifyListeners();
          },
          isHappy: false,
        );
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      } else {
        pageStatus = PageStatus.LOADING;
        notifyListeners();
        matchRepo
            .saveOpenMatch(context, loggedUser.accessToken, match.idMatch,
                match.isOpenMatch, match.maxUsers)
            .then(
              (response) => defaultResponse(
                response,
                context,
              ),
            );
      }
    }
  }

  void defaultResponse(NetworkResponse response, BuildContext context) {
    modalMessage = SFModalMessage(
      title: response.responseTitle!,
      onTap: () {
        if (response.responseStatus == NetworkResponseStatus.alert) {
          getMatchInfo(context, match.matchUrl);
        } else {
          pageStatus = PageStatus.OK;
          notifyListeners();
        }
      },
      isHappy: response.responseStatus == NetworkResponseStatus.alert,
    );
    pageStatus = PageStatus.ERROR;
    notifyListeners();
  }
}
