import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Model/AvailableDay.dart';
import 'package:sandfriends/Common/Model/AvailableHour.dart';
import 'package:sandfriends/Common/Model/AvailableStore.dart';
import 'package:sandfriends/Common/Model/Store/StoreComplete.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';

import '../../../Common/Utils/Constants.dart';
import '../../Model/Store/Store.dart';
import '../../Model/Store/StoreUser.dart';
import 'AvailableStoreCard.dart';
import 'AvailableStoreCardWeb.dart';

class AvailableDayCard extends StatelessWidget {
  final AvailableDay availableDay;
  final AvailableStore? selectedStore;
  final AvailableHour? selectedAvailableHour;
  final Function(AvailableDay) onTapHour;
  final Function(Store) onGoToCourt;
  final bool selectedParent;
  final bool isRecurrent;
  final VoidCallback? resetSelectedAvailableHour;

  const AvailableDayCard({
    Key? key,
    required this.availableDay,
    required this.selectedStore,
    required this.selectedAvailableHour,
    required this.onTapHour,
    required this.onGoToCourt,
    required this.selectedParent,
    required this.isRecurrent,
    this.resetSelectedAvailableHour,
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
                    ? weekday[availableDay.weekday!]
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
            return kIsWeb
                ? AvailableStoreCardWeb(
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
                    resetSelectedAvailableHour: () {
                      if (resetSelectedAvailableHour != null) {
                        resetSelectedAvailableHour!();
                      }
                    },
                    onGoToCourt: (store) => onGoToCourt(store),
                    selectedParent: selectedParent == false ||
                            selectedStore == null ||
                            selectedStore!.store.idStore !=
                                availableDay.stores[index].store.idStore
                        ? false
                        : true,
                    isRecurrent: isRecurrent,
                  )
                : AvailableStoreCard(
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
