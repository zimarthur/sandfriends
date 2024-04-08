import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/Modal/SFModalMessage.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Providers/Drawer/EnumDrawerPage.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Remote/NetworkResponse.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/Model/EnumClassView.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/Repo/ClassesRepo.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/Providers/Categories/CategoriesProvider.dart';
import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Sandfriends/Features/MatchSearch/View/CalendarModal.dart';

class ClassesScreenAulasViewModel extends MenuProviderAulas {
  final classesRepo = ClassesRepo();

  List<AppMatchUser> matches = [];
  late DateTime matchesStartDate;
  late DateTime matchesEndDate;

  void initClassesViewModel(BuildContext context) {
    matchesStartDate =
        Provider.of<TeacherProvider>(context, listen: false).matchesStartDate;
    matchesEndDate =
        Provider.of<TeacherProvider>(context, listen: false).matchesEndDate;
    matches = Provider.of<TeacherProvider>(context, listen: false).matches;
    selectedDate = DateTime.now();
    initMenuProviderAulas(
      context,
      DrawerPage.Classes,
    );
    currentWeekday = getSFWeekday(DateTime.now().weekday);
    notifyListeners();
  }

  ClassView classView = ClassView.Classes;
  void onChangedClassView(ClassView newClassView) {
    classView = newClassView;
    notifyListeners();
  }

  DateTime? selectedDate;
  late int currentWeekday;

  void onUpdateWeekday(int newWeekday) {
    currentWeekday = newWeekday;
    notifyListeners();
  }

  void onYesterday(BuildContext context) {
    selectedDate = selectedDate!.subtract(
      const Duration(
        days: 1,
      ),
    );
    notifyListeners();
    onChangeDate(context);
  }

  void onTomorrow(BuildContext context) {
    selectedDate = selectedDate!.add(
      const Duration(
        days: 1,
      ),
    );
    notifyListeners();
    onChangeDate(context);
  }

  void onChangeDate(BuildContext context) {
    if (selectedDate!.isAfter(matchesEndDate) ||
        selectedDate!.isBefore(matchesStartDate)) {
      Provider.of<StandardScreenViewModel>(context, listen: false).setLoading();
      classesRepo
          .searchClasses(
              context,
              Provider.of<EnvironmentProvider>(context, listen: false)
                  .accessToken!,
              selectedDate!)
          .then((response) {
        if (response.responseStatus == NetworkResponseStatus.success) {
          Map<String, dynamic> responseBody = json.decode(
            response.responseBody!,
          );
          matchesStartDate = DateFormat("dd/MM/yyyy").parse(
            responseBody["StartDate"],
          );
          matchesEndDate = DateFormat("dd/MM/yyyy").parse(
            responseBody["EndDate"],
          );
          matches.clear();
          for (var match in responseBody["Matches"]) {
            matches.add(
              AppMatchUser.fromJson(
                match,
                Provider.of<CategoriesProvider>(context, listen: false).hours,
                Provider.of<CategoriesProvider>(context, listen: false).sports,
                Provider.of<CategoriesProvider>(context, listen: false).ranks,
                Provider.of<CategoriesProvider>(context, listen: false).genders,
              ),
            );
          }
        }
        Provider.of<StandardScreenViewModel>(context, listen: false)
            .setPageStatusOk();
      });
    }
  }

  void openDateSelectorModal(BuildContext context) {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .addOverlayWidget(
      CalendarModal(
        allowMultiDates: false,
        allowPast: true,
        dateRange: [selectedDate],
        onSubmit: (newDates) {
          Provider.of<StandardScreenViewModel>(context, listen: false)
              .removeLastOverlay();
          if (newDates.length == 1) {
            selectedDate = newDates.first;
            notifyListeners();
            onChangeDate(context);
          }
        },
      ),
    );
  }

  void onAddClass(BuildContext context) {
    if (Provider.of<TeacherProvider>(context, listen: false)
        .teacher
        .teams
        .isEmpty) {
      Provider.of<StandardScreenViewModel>(context, listen: false)
          .addModalMessage(
        SFModalMessage(
          title: "Você precisa criar uma turma antes de agendar uma aula",
          buttonText: "Criar turma",
          onTap: () {
            Navigator.pushNamed(context, "/create_team");
          },
          isHappy: false,
        ),
      );
    } else {
      Navigator.pushNamed(context, "/recurrent_match_search");
    }
  }
}
