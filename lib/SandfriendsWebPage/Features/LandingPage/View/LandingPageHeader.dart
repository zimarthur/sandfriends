import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/ViewModel/LandingPageViewModel.dart';

import '../../../../Common/Utils/Constants.dart';
import 'SearchFilter.dart';
import 'WebHeader.dart';

class LandingPageHeader extends StatelessWidget {
  const LandingPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LandingPageViewModel>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          color: primaryBlue,
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.1),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sua próxima partida está aqui",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Encontre sua quadra, conheça novos jogadores e muito mais!",
                style: TextStyle(
                  color: textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: defaultPadding,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          width: width,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: 60,
                color: primaryBlue,
              ),
              Positioned(
                top: 20,
                child: SearchFilter(
                  onTapLocation: () => viewModel.openCitySelectorModal(context),
                  onTapDate: () => viewModel.openDateSelectorModal(context),
                  onTapTime: () => viewModel.openTimeSelectorModal(context),
                  city: viewModel.cityFilter,
                  dates: viewModel.datesFilter,
                  time: viewModel.timeFilter,
                  onSearch: () => viewModel.searchCourts(context),
                  direction: Axis.horizontal,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
