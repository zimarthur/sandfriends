import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/SFModalMessage.dart';
import 'package:sandfriends/Common/Model/Gender.dart';
import 'package:sandfriends/Common/Model/Sport.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';

import '../../../../Common/Model/Rank.dart';
import '../../../../Common/Model/Team.dart';
import '../../../../Common/Providers/Environment/EnvironmentProvider.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../Repo/CreateTeamRepo.dart';

class CreateTeamViewModel extends StandardScreenViewModel {
  final createTeamRepo = CreateTeamRepo();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  late Team newTeam;

  void initCreateTeamViewModel(BuildContext context) {
    hasClassPlansSet(context);
    Sport sport = Provider.of<UserProvider>(context, listen: false)
        .user!
        .preferenceSport!;
    newTeam = Team(
      idTeam: null,
      name: "",
      description: "",
      creationDate: DateTime.now(),
      sport: sport,
      gender:
          Provider.of<CategoriesProvider>(context, listen: false).genders.first,
      rank: Provider.of<CategoriesProvider>(context, listen: false)
          .ranks
          .where((rank) => rank.sport == sport)
          .toList()
          .firstWhere((rank) => rank.isNeutralRank),
    );
    notifyListeners();
  }

  bool hasClassPlansSet(BuildContext context) {
    if (Provider.of<TeacherProvider>(context, listen: false)
            .teacher
            .hasSetMinClassPlans ==
        false) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .addModalMessage(
          SFModalMessage(
            title:
                "Você precisa cadastrar seus planos de aula antes de criar uma turma",
            buttonText: "Ver planos de aula",
            onTap: () {
              Navigator.pushNamed(context, "/class_plans");
            },
            isHappy: false,
          ),
        );
      });
      return false;
    }
    return true;
  }

  String get maxSizeDescriptionText => "${newTeam.description.length}/255";
  void onChangedDescription(String newValue) {
    newTeam.description = newValue;
    notifyListeners();
  }

  void onCreateTeam(BuildContext context) {
    if (hasClassPlansSet(context) == false) {
      return;
    }
    String? errorString;
    if (nameController.text.isEmpty) {
      errorString = "Digite o nome da turma";
    } else if (nameController.text.length > 44) {
      errorString = "O nome deve ter no máximo 45 caracteres";
    } else if (descriptionController.text.isEmpty) {
      errorString = "Dê uma descrição para essa turma";
    } else if (descriptionController.text.length > 254) {
      errorString = "A descrição deve ter no máximo 45 caracteres";
    }
    if (errorString != null) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: errorString,
          onTap: () {},
          isHappy: false,
        ),
      );
      return;
    }
    newTeam.name = nameController.text;
    newTeam.description = descriptionController.text;
    Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
    createTeamRepo
        .addTeam(
      context,
      Provider.of<EnvironmentProvider>(context, listen: false).accessToken!,
      newTeam,
    )
        .then((response) {
      if (response.responseStatus == NetworkResponseStatus.success) {
        Map<String, dynamic> responseBody = json.decode(
          response.responseBody!,
        );
        Provider.of<TeacherProvider>(context, listen: false).addTeam(
          Team.fromJson(
            responseBody["NewTeam"],
            Provider.of<CategoriesProvider>(context, listen: false).hours,
            Provider.of<CategoriesProvider>(context, listen: false).sports,
            Provider.of<CategoriesProvider>(context, listen: false).ranks,
            Provider.of<CategoriesProvider>(context, listen: false).genders,
          ),
        );
        Navigator.pop(context);
        notifyListeners();
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
            isHappy: false,
          ),
        );
      }
      FocusScope.of(context).unfocus();
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .setPageStatusOk();
    });
  }

  void updateSport(Sport sport) {
    newTeam.sport = sport;
    notifyListeners();
  }

  void updateRank(Rank rank) {
    newTeam.rank = rank;
    notifyListeners();
  }

  void updateGender(Gender gender) {
    newTeam.gender = gender;
    notifyListeners();
  }
}
