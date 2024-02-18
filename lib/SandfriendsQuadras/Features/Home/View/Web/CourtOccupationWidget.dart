import 'package:flutter/material.dart';
import '../../../../../Common/Components/SFDivider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
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
