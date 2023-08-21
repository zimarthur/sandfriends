import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/View/AvailableDaysResult/AvailableStoreCard.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableDay.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableHour.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableStore.dart';
import 'package:sandfriends/SharedComponents/Model/Store.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';

import '../../../Utils/Constants.dart';

class AvailableDayCard extends StatelessWidget {
  AvailableDay availableDay;
  AvailableStore? selectedStore;
  AvailableHour? selectedAvailableHour;
  Function(AvailableDay) onTapHour;
  Function(Store) onGoToCourt;
  bool selectedParent;
  bool isRecurrent;

  AvailableDayCard({
    Key? key,
    required this.availableDay,
    required this.selectedStore,
    required this.selectedAvailableHour,
    required this.onTapHour,
    required this.onGoToCourt,
    required this.selectedParent,
    required this.isRecurrent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.03, vertical: height * 0.02),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(right: 5),
                child: SvgPicture.asset(
                  r'assets/icon/calendar.svg',
                  color: isRecurrent ? primaryLightBlue : primaryBlue,
                ),
              ),
              Text(
                isRecurrent
                    ? weekDaysPortuguese[availableDay.weekday!]
                    : DateFormat("dd/MM/yyyy").format(availableDay.day!),
                style: TextStyle(
                  color: isRecurrent ? primaryLightBlue : primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableDay.stores.length,
          itemBuilder: (context, index) {
            return AvailableStoreCard(
              availableStore: availableDay.stores[index],
              selectedAvailableHour: selectedAvailableHour,
              onTapHour: (avStore) {
                List<AvailableStore> availableStore = [];
                availableStore.add(avStore);
                AvailableDay avDay = AvailableDay(
                  day: availableDay.day,
                  stores: availableStore,
                  weekday: availableDay.weekday,
                );
                onTapHour(avDay);
              },
              onGoToCourt: (store) => onGoToCourt(store),
              selectedParent: selectedParent == false ||
                      selectedStore == null ||
                      selectedStore!.store.idStore !=
                          availableDay.stores[index].store.idStore
                  ? false
                  : true,
              isRecurrent: isRecurrent,
            );
          },
        ),
      ],
    );
  }
}
