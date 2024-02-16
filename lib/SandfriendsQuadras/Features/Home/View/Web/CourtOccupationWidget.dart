import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Home/ViewModel/HomeViewModel.dart';

import '../../../../SharedComponents/View/SFDivider.dart';
import '../../../../Utils/Constants.dart';
import 'OccupationWidget.dart';

class CourtOccupationWidget extends StatelessWidget {
  HomeViewModel viewModel;
  CourtOccupationWidget({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ocupação das suas quadras hoje",
          style: TextStyle(
            color: textDarkGrey,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(
          height: defaultPadding,
        ),
        OccupationWidget(
          title: "Geral",
          result: viewModel.averageOccupation,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
            vertical: defaultPadding,
          ),
          child: SFDivider(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: viewModel.courtsOccupation.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: defaultPadding),
                child: OccupationWidget(
                  title: viewModel.courtsOccupation[index].court.description,
                  result:
                      viewModel.courtsOccupation[index].occupationPercentage,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
