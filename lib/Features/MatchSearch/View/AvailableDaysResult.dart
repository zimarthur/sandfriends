import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/MatchSearch/View/AvailableDayCard/AvailableDayCard.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';

import '../../../Utils/Constants.dart';
import 'MatchSearchResultTitle.dart';

class AvailableDaysResult extends StatefulWidget {
  MatchSearchViewModel viewModel;
  AvailableDaysResult({
    required this.viewModel,
  });

  @override
  State<AvailableDaysResult> createState() => _AvailableDaysResultState();
}

class _AvailableDaysResultState extends State<AvailableDaysResult> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        MatchSearchResultTitle(
          title: "Quadras",
          iconPath: r'assets\icon\court.svg',
          description: "Agende um horário na sua quadra de preferência",
        ),
        widget.viewModel.availableDays.isEmpty
            ? Container(
                margin: EdgeInsets.symmetric(
                  vertical: height * 0.04,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Nenhum horário disponível",
                  style: TextStyle(
                    color: textLightGrey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: widget.viewModel.availableDays.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AvailableDayCard(
                    availableDay: widget.viewModel.availableDays[index],
                    onTap: (avDay) => widget.viewModel.onSelectedHour(avDay),
                    viewModel: widget.viewModel,
                    selectedParent: widget.viewModel.selectedDay == null ||
                            widget.viewModel.availableDays[index].day !=
                                widget.viewModel.selectedDay!.day
                        ? false
                        : true,
                  );
                },
              ),
      ],
    );
  }
}
