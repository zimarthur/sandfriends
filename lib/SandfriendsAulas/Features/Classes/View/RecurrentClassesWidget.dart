import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/ViewModel/ClassesScreenViewModel.dart';

import '../../../../Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'ClassItem.dart';
import 'WeekdayRowSelector.dart';

class RecurrenClassesWidget extends StatelessWidget {
  ClassesScreenAulasViewModel viewModel;
  RecurrenClassesWidget({
    required this.viewModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekdayRowSelector(
          currentWeekday: viewModel.currentWeekday,
          onSelectedWeekday: (newWeekday) => viewModel.onUpdateWeekday(
            newWeekday,
          ),
        ),
        Expanded(
          child: Builder(builder: (context) {
            List<AppRecurrentMatchUser> recurrentMatchesForWeekday =
                Provider.of<TeacherProvider>(context)
                    .recurrentMatches
                    .where((recMatch) =>
                        recMatch.weekday == viewModel.currentWeekday)
                    .toList();
            return recurrentMatchesForWeekday.isEmpty
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
                    itemCount: recurrentMatchesForWeekday.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              index == (recurrentMatchesForWeekday.length - 1)
                                  ? 60
                                  : defaultPadding,
                        ),
                        child: ClassItem(
                          recMatch: recurrentMatchesForWeekday[index],
                          team: recurrentMatchesForWeekday[index].team!,
                          canRenewRecurrentMatch: true,
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
