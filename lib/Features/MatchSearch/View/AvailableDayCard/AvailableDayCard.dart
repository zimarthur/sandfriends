import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Features/MatchSearch/View/AvailableDayCard/AvailableStoreCard.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableDay.dart';
import 'package:sandfriends/SharedComponents/Model/AvailableStore.dart';

import '../../../../Utils/Constants.dart';

class AvailableDayCard extends StatelessWidget {
  AvailableDay availableDay;
  Function(AvailableDay) onTap;
  MatchSearchViewModel viewModel;
  bool selectedParent;

  AvailableDayCard({
    required this.availableDay,
    required this.onTap,
    required this.viewModel,
    required this.selectedParent,
  });

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
                child: SvgPicture.asset(r'assets\icon\calendar.svg'),
              ),
              Text(
                DateFormat("dd/MM/yyyy").format(availableDay.day),
                style:
                    TextStyle(color: primaryBlue, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: availableDay.stores.length,
          itemBuilder: (context, index) {
            return AvailableStoreCard(
              availableStore: availableDay.stores[index],
              onTap: (avStore) {
                List<AvailableStore> availableStore = [];
                availableStore.add(avStore);
                AvailableDay avDay =
                    AvailableDay(day: availableDay.day, stores: availableStore);
                onTap(avDay);
              },
              viewModel: viewModel,
              selectedParent: selectedParent == false ||
                      viewModel.selectedStore == null ||
                      viewModel.selectedStore!.idStore !=
                          availableDay.stores[index].store.idStore
                  ? false
                  : true,
            );
          },
        ),
      ],
    );
  }
}
