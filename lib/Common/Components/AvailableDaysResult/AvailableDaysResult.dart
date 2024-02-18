import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/AvailableHour.dart';
import 'package:sandfriends/Common/Model/AvailableStore.dart';
import 'package:sandfriends/Common/Model/Store/StoreComplete.dart';

import '../../../Common/Model/AvailableDay.dart';
import '../../../Common/Utils/Constants.dart';
import '../../../Sandfriends/Features/MatchSearch/View/MatchSearchResultTitle.dart';
import '../../Model/Store/StoreUser.dart';
import 'AvailableDayCard.dart';

class AvailableDaysResult extends StatefulWidget {
  final List<AvailableDay> availableDays;
  final AvailableDay? selectedAvailableDay;
  final AvailableStore? selectedStore;
  final AvailableHour? selectedAvailableHour;
  final bool isRecurrent;
  final Function(AvailableDay) onTapHour;
  final Function(StoreUser) onGoToCourt;

  const AvailableDaysResult({
    Key? key,
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
    return Column(
      children: [
        MatchSearchResultTitle(
          title: "Quadras",
          iconPath: r'assets/icon/court.svg',
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
