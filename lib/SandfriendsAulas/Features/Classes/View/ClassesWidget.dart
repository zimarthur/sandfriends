import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Sandfriends/Features/Home/View/Classes/ViewModel/ClassesViewModel.dart';

import '../../../../Common/Features/Court/View/DayFilter.dart';
import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import '../ViewModel/ClassesScreenViewModel.dart';
import 'ClassItem.dart';

class ClassesWidgetTeacher extends StatelessWidget {
  ClassesScreenAulasViewModel viewModel;
  ClassesWidgetTeacher({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DayFilter(
          date: viewModel.selectedDate,
          weekDay: null,
          onYesterday: () => viewModel.onYesterday(context),
          onTomorrow: () => viewModel.onTomorrow(context),
          themeColor: primaryBlue,
          onOpenDateModal: () => viewModel.openDateSelectorModal(context),
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AppMatchUser> matchesForSelectedDay = viewModel.matches
                .where((match) =>
                    areInTheSameDay(match.date, viewModel.selectedDate!))
                .toList();
            return matchesForSelectedDay.isEmpty
                ? Center(
                    child: Text(
                      "Nenhuma aula nessa dia",
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: matchesForSelectedDay.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == (matchesForSelectedDay.length - 1)
                              ? 60
                              : defaultPadding,
                        ),
                        child: ClassItem(
                          match: matchesForSelectedDay[index],
                          team: matchesForSelectedDay[index].team!,
                        ),
                      );
                    },
                  );
          }),
        ),
      ],
    );
  }
}
