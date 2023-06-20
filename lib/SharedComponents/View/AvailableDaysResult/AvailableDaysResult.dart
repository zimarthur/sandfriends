import 'package:flutter/material.dart';
import 'package:sandfriends/SharedComponents/View/AvailableDaysResult/AvailableDayCard.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableStore.dart';
import 'package:sandfriends/SharedComponents/Model/Store.dart';

import '../../Model/AvailableDay.dart';
import '../../../Utils/Constants.dart';
import '../../../Features/MatchSearch/View/MatchSearchResultTitle.dart';

class AvailableDaysResult extends StatefulWidget {
  List<AvailableDay> availableDays;
  AvailableDay? selectedAvailableDay;
  AvailableStore? selectedStore;
  AvailableHour? selectedAvailableHour;
  bool isRecurrent;
  Function(AvailableDay) onTapHour;
  Function(Store) onGoToCourt;

  AvailableDaysResult({Key? key, 
    required this.availableDays,
    required this.selectedAvailableDay,
    required this.selectedStore,
    required this.selectedAvailableHour,
    required this.onTapHour,
    required this.onGoToCourt,
    this.isRecurrent = false,
  }) : super(key: key);

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
          description: widget.isRecurrent
              ? "Seja mensalista na sua quadra de preferência"
              : "Agende um horário na sua quadra de preferência",
          themeColor: widget.isRecurrent ? primaryLightBlue : primaryBlue,
        ),
        widget.availableDays.isEmpty
            ? Container(
                margin: EdgeInsets.symmetric(
                  vertical: height * 0.04,
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Nenhum horário disponível",
                  style: TextStyle(
                    color: textLightGrey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: widget.availableDays.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AvailableDayCard(
                    availableDay: widget.availableDays[index],
                    onTapHour: (avDay) => widget.onTapHour(avDay),
                    selectedParent: widget.selectedAvailableDay == null ||
                            (!widget.isRecurrent &&
                                widget.availableDays[index].day !=
                                    widget.selectedAvailableDay!.day) ||
                            (widget.isRecurrent &&
                                widget.availableDays[index].weekday !=
                                    widget.selectedAvailableDay!.weekday)
                        ? false
                        : true,
                    selectedStore: widget.selectedStore,
                    selectedAvailableHour: widget.selectedAvailableHour,
                    onGoToCourt: (store) => widget.onGoToCourt(store),
                    isRecurrent: widget.isRecurrent,
                  );
                },
              ),
      ],
    );
  }
}
