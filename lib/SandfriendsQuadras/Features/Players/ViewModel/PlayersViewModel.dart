import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/Features/Players/Model/PieChartKpi.dart';
import 'package:sandfriends_web/Features/Players/Model/PlayersDataSource.dart';
import 'package:sandfriends_web/Features/Players/Model/PlayersTableCallback.dart';
import 'package:sandfriends_web/Features/Players/Repository/PlayersRepoImp.dart';
import 'package:sandfriends_web/SharedComponents/Model/Gender.dart';
import 'package:sandfriends_web/SharedComponents/Model/Player.dart';
import 'package:sandfriends_web/SharedComponents/Model/Sport.dart';
import 'package:sandfriends_web/SharedComponents/View/SFPieChart.dart';
import 'package:sandfriends_web/Utils/LinkOpenerWeb.dart'
    if (dart.library.io) 'package:sandfriends_web/Utils/LinkOpenerMobile.dart';
import '../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../View/Web/StorePlayerWidget.dart';

class PlayersViewModel extends ChangeNotifier {
  final playersRepo = PlayersRepo();

  TextEditingController nameFilterController = TextEditingController();

  String defaultGender = "Todos gêneros";
  String defaultSport = "Todos esportes";

  List<Gender> availableGenders = [];
  List<Sport> availableSports = [];
  late String filteredGender;
  late String filteredSport;

  List<String> genderFilters = [];
  List<String> sportsFilters = [];

  final List<Player> _players = [];
  List<Player> get players {
    List<Player> sortedPlayers = [];
    sortedPlayers = _players;
    sortedPlayers.sort(
      (a, b) => a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase()),
    );
    return sortedPlayers;
  }

  List<PieChartKpi> get pieChartKpis => [
        PieChartKpi(pieChartitems: genderPieChartItems, title: "Gênero"),
        PieChartKpi(pieChartitems: sportPieChartItems, title: "Esporte"),
      ];
  List<PieChartItem> get genderPieChartItems {
    List<PieChartItem> items = [];
    availableGenders.forEach((gender) {
      items.add(
        PieChartItem(
          name: gender.genderName,
          value: players
              .where((player) => player.gender!.idGender == gender.idGender)
              .length
              .toDouble(),
        ),
      );
    });
    return items;
  }

  List<PieChartItem> get sportPieChartItems {
    List<PieChartItem> items = [];
    availableSports.forEach((sport) {
      items.add(
        PieChartItem(
          name: sport.description,
          value: players
              .where((player) => player.sport!.idSport == sport.idSport)
              .length
              .toDouble(),
        ),
      );
    });
    return items;
  }

  PlayersDataSource? playersDataSource;

  void initViewModel(BuildContext context) {
    setDefaultFilters(context);
    setPlayersDataSource(context);
  }

  void setDefaultFilters(BuildContext context) {
    filteredGender = defaultGender;
    filteredSport = defaultSport;
    sportsFilters.add(defaultSport);
    Provider.of<DataProvider>(context, listen: false)
        .availableSports
        .forEach((sport) {
      availableSports.add(sport);
      sportsFilters.add(sport.description);
    });
    genderFilters.add(defaultGender);
    Provider.of<DataProvider>(context, listen: false)
        .availableGenders
        .forEach((gender) {
      availableGenders.add(gender);
      genderFilters.add(gender.genderName);
    });
    notifyListeners();
  }

  void filterGender(BuildContext context, String genderName) {
    filteredGender = genderFilters.firstWhere((gender) => gender == genderName);
    setPlayersDataSource(context);
  }

  void filterSport(BuildContext context, String sportName) {
    filteredSport = sportsFilters.firstWhere((sport) => sport == sportName);
    setPlayersDataSource(context);
  }

  void filterName(BuildContext context) {
    setPlayersDataSource(context);
  }

  void setPlayersDataSource(BuildContext context) {
    _players.clear();
    Provider.of<DataProvider>(context, listen: false)
        .storePlayers
        .forEach((player) {
      if ((filteredGender == defaultGender ||
              filteredGender == player.gender!.genderName) &&
          (filteredSport == defaultSport ||
              filteredSport == player.sport!.description) &&
          (player.fullName
              .toLowerCase()
              .contains(nameFilterController.text.toLowerCase()))) {
        _players.add(Player.copyFrom(player));
      }
    });
    playersDataSource = PlayersDataSource(
      players: players,
      tableCallback: tableCallback,
      context: context,
    );
    notifyListeners();
  }

  void tableCallback(
    PlayersTableCallback callbackCode,
    Player player,
    BuildContext context,
  ) {
    switch (callbackCode) {
      case PlayersTableCallback.Edit:
        openStorePlayerWidget(context, player);
        break;
      case PlayersTableCallback.Delete:
        Provider.of<MenuProvider>(context, listen: false).setModalConfirmation(
            "Deseja mesmo excluir ${player.fullName}?",
            "Após a exclusão, os dados de ${player.firstName} não estarão mais disponíveis",
            () => deletePlayer(context, player), () {
          Provider.of<MenuProvider>(context, listen: false).closeModal();
        });
        break;
    }
  }

  void openStorePlayerWidget(BuildContext context, Player? existingPlayer) {
    Provider.of<MenuProvider>(context, listen: false)
        .setModalForm(StorePlayerWidget(
      editPlayer: existingPlayer,
      onReturn: () => closeModal(context),
      onSavePlayer: (player) => editPlayer(context, player),
      onCreatePlayer: (player) => addPlayer(context, player),
      sports: Provider.of<DataProvider>(context, listen: false).availableSports,
      ranks: Provider.of<DataProvider>(context, listen: false).availableRanks,
      genders:
          Provider.of<DataProvider>(context, listen: false).availableGenders,
    ));
  }

  void addPlayer(BuildContext context, Player player) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    playersRepo
        .addPlayer(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      player,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        Provider.of<DataProvider>(context, listen: false)
            .setPlayersResponse(responseBody);
        setPlayersDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Jogador(a) adicionado(a)!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void editPlayer(BuildContext context, Player player) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    playersRepo
        .editPlayer(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      player,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        Provider.of<DataProvider>(context, listen: false)
            .setPlayersResponse(responseBody);
        setPlayersDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Jogador(a) atualizado(a)!", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void deletePlayer(BuildContext context, Player player) {
    Provider.of<MenuProvider>(context, listen: false).setModalLoading();
    playersRepo
        .deleteStorePlayer(
      context,
      Provider.of<DataProvider>(context, listen: false).loggedAccessToken,
      player.id!,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );

        Provider.of<DataProvider>(context, listen: false)
            .setPlayersResponse(responseBody);
        setPlayersDataSource(context);
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModal("Jogador(a) excluído(a)", null, true);
      } else if (response.responseStatus ==
          NetworkResponseStatus.expiredToken) {
        Provider.of<MenuProvider>(context, listen: false).logout(context);
      } else {
        Provider.of<MenuProvider>(context, listen: false)
            .setMessageModalFromResponse(response);
      }
    });
  }

  void closeModal(BuildContext context) {
    Provider.of<MenuProvider>(context, listen: false).closeModal();
  }

  openWhatsApp(BuildContext context, Player player) {
    if (player.phoneNumber != null) {
      openLink(context, "whatsapp://send?phone=${player.phoneNumber}");
    }
  }
}
