import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/RecurrentMatchSearchSport/ViewModel/RecurrentMatchSearchSportViewModel.dart';
import 'package:sandfriends/SharedComponents/View/SFStandardScreen.dart';

import '../../../SharedComponents/View/SportSelector.dart';
import '../../../Utils/Constants.dart';

class RecurrentMatchSearchSportScreen extends StatefulWidget {
  const RecurrentMatchSearchSportScreen({Key? key}) : super(key: key);

  @override
  State<RecurrentMatchSearchSportScreen> createState() =>
      _RecurrentMatchSearchSportScreenState();
}

class _RecurrentMatchSearchSportScreenState
    extends State<RecurrentMatchSearchSportScreen> {
  final viewModel = RecurrentMatchSearchSportViewModel();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SFStandardScreen(
      pageStatus: viewModel.pageStatus,
      enableToolbar: false,
      child: Container(
        color: secondaryLightBlue,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.symmetric(
                  vertical: height * 0.01,
                  horizontal: width * 0.02,
                ),
                child: InkWell(
                  onTap: () => viewModel.onTapReturn(
                    context,
                  ),
                  child: Container(
                    height: width * 0.1,
                    width: width * 0.1,
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      r'assets\icon\arrow_left.svg',
                      color: secondaryBack,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SportSelector(
                  isRecurrentMatch: true,
                  onSportSelected: (sport) {
                    viewModel.onSportSelected(context, sport);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
