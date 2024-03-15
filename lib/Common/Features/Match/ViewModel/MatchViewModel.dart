import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/User/UserComplete.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Common/Features/Match/View/MemberCardModal.dart';
import 'package:sandfriends/Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Common/Model/PaymentStatus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Components/Modal/ConfirmationModal.dart';
import '../../../Model/AppMatch/AppMatchUser.dart';
import '../../../Providers/Environment/EnvironmentProvider.dart';
import '../../../Utils/PageStatus.dart';
import '../../../Model/MatchCounter.dart';
import '../../../Model/MatchMember.dart';
import '../../../Providers/Categories/CategoriesProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/Modal/SFModalMessage.dart';
import '../Repository/MatchRepo.dart';

class MatchViewModel extends ChangeNotifier {
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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
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
          ),
        );
        //canTapBackground = false;
      }
    });
  }

  void shareMatch(BuildContext context) async {
    if (match.paymentStatus == PaymentStatus.Pending) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title:
              "Você precisa finalizar o pagamento antes de convidar jogadores",
          onTap: () {},
          isHappy: false,
        ),
      );
    } else {
      await Share.share(
          'Entre na minha partida!\n ${Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
        "/partida/${match.matchUrl}",
        isDeepLink: true,
      )}');
    }
  }

  void copyMatchUrlClipboard(BuildContext context) async {
    await Clipboard.setData(
      ClipboardData(
        text:
            Provider.of<EnvironmentProvider>(context, listen: false).urlBuilder(
          "/partida/${match.matchUrl}",
          isDeepLink: true,
        ),
      ),
    );
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
      '/quadra/${match.court.store!.url}',
      arguments: {
        'store': match.court.store!,
      },
    );
  }

  void saveCreatorNotes(BuildContext context) {
    if (creatorNotesFormKey.currentState?.validate() == true) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      matchRepo
          .saveCreatorNotes(
        context,
        loggedUser.accessToken,
        match.idMatch,
        creatorNotesController.text,
      )
          .then((response) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus == NetworkResponseStatus.alert) {
                match.creatorNotes = creatorNotesController.text;
                controllerHasChanged = false;
              }
              notifyListeners();
            },
            isHappy: response.responseStatus == NetworkResponseStatus.alert,
          ),
        );
      });
    }
  }

  void openMemberCardModal(BuildContext context, MatchMember member) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      MemberCardModal(
        viewModel: this,
        member: member,
        onAccept: () => invitationResponse(context, member.user.id!, true),
        onRefuse: () => invitationResponse(context, member.user.id!, false),
        onRemove: () => removeMatchMember(context, member.user.id!),
      ),
    );
  }

  void invitationResponse(BuildContext context, int id, bool accepted) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: accepted ? "Convite aceito" : "Convite recusado",
            onTap: () {
              getMatchInfo(context, match.matchUrl);
            },
            isHappy: accepted,
          ),
        );
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title: response.responseTitle!,
            onTap: () {
              if (response.responseStatus ==
                  NetworkResponseStatus.expiredToken) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login_signup',
                  (Route<dynamic> route) => false,
                );
              }
            },
            isHappy: accepted,
          ),
        );
      }
      //canTapBackground = false;
    });
  }

  void removeMatchMember(BuildContext context, int id) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      ConfirmationModal(
        message: "Deseja mesmo cancelar a partida?",
        onConfirm: () => cancelMatch(context),
        onCancel: () {},
        isHappy: false,
      ),
    );
  }

  void cancelMatch(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
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
          buttonIconPath: r"assets/icon/config.svg",
          buttonText: "Configurar",
          isHappy: false,
        ),
      );
    } else {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();

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
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Você precisa finalizar o pagamento antes de abrir a partida",
          onTap: () {},
          isHappy: false,
        ),
      );
    } else if (!userHasConfiguredRank(context)) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title:
              "Antes de abrir uma partida você precisa configurar seu rank em ${match.sport.description}",
          onTap: () {},
          isHappy: false,
        ),
      );
    } else {
      if (match.isOpenMatch == true &&
          match.maxUsers <= match.activeMatchMembers) {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title:
                "O número de jogadores que você deseja para sua partida deve ser maior do que o número de jogadores atual",
            onTap: () {},
            isHappy: false,
          ),
        );
      } else {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setLoading();

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
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addModalMessage(
      SFModalMessage(
        title: response.responseTitle!,
        onTap: () {
          if (response.responseStatus == NetworkResponseStatus.alert) {
            getMatchInfo(context, match.matchUrl);
          }
        },
        isHappy: response.responseStatus == NetworkResponseStatus.alert,
      ),
    );
  }
}
