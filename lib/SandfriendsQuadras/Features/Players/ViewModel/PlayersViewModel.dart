import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import '../../../../Common/Components/SFPieChart.dart';
import '../../../../Common/Model/Gender.dart';
import '../../../../Common/Model/User/Player_old.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Model/User/UserStore.dart';
import '../../../../Remote/NetworkResponse.dart';
import '../../Menu/ViewModel/DataProvider.dart';
import '../../Menu/ViewModel/MenuProvider.dart';
import '../Model/PieChartKpi.dart';
import '../Model/PlayersDataSource.dart';
import '../Model/PlayersTableCallback.dart';
import '../Repository/PlayersRepo.dart';
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

  final List<UserStore> _players = [];
  List<UserStore> get players {
    List<UserStore> sortedPlayers = [];
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
          name: gender.name,
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
              .where(
                  (player) => player.preferenceSport!.idSport == sport.idSport)
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
      genderFilters.add(gender.name);
    });
    notifyListeners();
  }

  void filterGender(BuildContext context, String name) {
    filteredGender = genderFilters.firstWhere((gender) => gender == name);
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
              filteredGender == player.gender!.name) &&
          (filteredSport == defaultSport ||
              filteredSport == player.preferenceSport!.description) &&
          (player.fullName
              .toLowerCase()
              .contains(nameFilterController.text.toLowerCase()))) {
        _players.add(UserStore.copyFrom(player));
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
    UserStore player,
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

  void openStorePlayerWidget(BuildContext context, UserStore? existingPlayer) {
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

  void addPlayer(BuildContext context, UserStore player) {
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

  void editPlayer(BuildContext context, UserStore player) {
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

  void deletePlayer(BuildContext context, UserStore player) {
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

  openWhatsApp(BuildContext context, UserStore player) {
    if (player.phoneNumber != null) {
      LinkOpenerManager()
          .openLink(context, "whatsapp://send?phone=${player.phoneNumber}");
    }
  }
}
