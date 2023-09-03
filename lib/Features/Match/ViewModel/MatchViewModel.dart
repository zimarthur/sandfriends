import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Match/View/MemberCardModal.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/SharedComponents/Model/PaymentStatus.dart';
import 'package:sandfriends/SharedComponents/View/Modal/ConfirmationModal.dart';
import 'package:share_plus/share_plus.dart';

import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/Model/MatchCounter.dart';
import '../../../SharedComponents/Model/MatchMember.dart';
import '../../../SharedComponents/Model/User.dart';
import '../../../SharedComponents/Providers/CategoriesProvider/CategoriesProvider.dart';
import '../../../SharedComponents/Providers/RedirectProvider/EnvironmentProvider.dart';
import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/Modal/SFModalMessage.dart';
import '../../../Utils/PageStatus.dart';
import '../Repository/MatchRepoImp.dart';

class MatchViewModel extends ChangeNotifier {
  final matchRepo = MatchRepoImp();

  PageStatus pageStatus = PageStatus.LOADING;
  SFModalMessage modalMessage = SFModalMessage(
    message: "",
    onTap: () {},
    isHappy: true,
  );
  Widget? formWidget;

  String titleText = "";
  late AppMatch match;
  bool isMatchInstantiated = false;
  late User loggedUser;

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
            (member.user.idUser !=
                Provider.of<UserProvider>(context, listen: false)
                    .user!
                    .idUser) &&
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
        match = AppMatch.fromJson(
          responseBody['Match'],
          Provider.of<CategoriesProvider>(context, listen: false).hours,
          Provider.of<CategoriesProvider>(context, listen: false).sports,
        );
        final responseUsersMatchCounter = responseBody['UsersMatchCounter'];

        for (int i = 0; i < match.members.length; i++) {
          for (int j = 0; j < responseUsersMatchCounter.length; j++) {
            if (match.members[i].user.idUser ==
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
          if (match.members[i].user.idUser == loggedUser.idUser) {
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
          message: response.userMessage!,
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
        pageStatus = PageStatus.ERROR;
        notifyListeners();
      }
    });
  }

  void shareMatch(BuildContext context) async {
    if (match.paymentStatus == PaymentStatus.Pending) {
      modalMessage = SFModalMessage(
        message:
            "Você precisa finalizar o pagamento antes de convidar jogadores",
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

  void closeModal() {
    pageStatus = PageStatus.OK;
    notifyListeners();
  }

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
          message: response.userMessage!,
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

  void openMemberCardModal(MatchMember member) {
    formWidget = MemberCardModal(
      viewModel: this,
      member: member,
    );
    pageStatus = PageStatus.FORM;
    notifyListeners();
  }

  void invitationResponse(BuildContext context, int idUser, bool accepted) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .invitationResponse(
      context,
      loggedUser.accessToken,
      match.idMatch,
      idUser,
      accepted,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        modalMessage = SFModalMessage(
          message: accepted ? "Convite aceito" : "Convite recusado",
          onTap: () {
            getMatchInfo(context, match.matchUrl);
          },
          isHappy: accepted,
        );
      } else {
        modalMessage = SFModalMessage(
          message: response.userMessage!,
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
      pageStatus = PageStatus.ERROR;
      notifyListeners();
    });
  }

  void removeMatchMember(BuildContext context, int idUser) {
    pageStatus = PageStatus.LOADING;
    notifyListeners();
    matchRepo
        .removeMatchMember(
          context,
          loggedUser.accessToken,
          match.idMatch,
          idUser,
        )
        .then(
          (response) => defaultResponse(
            response,
            context,
          ),
        );
  }

  void confirmCancelMatch(BuildContext context) {
    formWidget = ConfirmationModal(
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
    if (!userHasConfiguredRank(context)) {
      modalMessage = SFModalMessage(
        message:
            "Para entrar em uma partida aberta você precisa configurar seu rank em ${match.sport.description}",
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
        message: "Você precisa finalizar o pagamento antes de abrir a partida",
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
        message:
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
          message:
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
      message: response.userMessage!,
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
