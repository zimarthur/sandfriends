import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/DownloadMobile.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Web/LandingPageFooter.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/Web/LandingPageHeader.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/ReservationSteps.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/SearchFilter.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

import '../../../../../Common/Components/AvailableDaysResult/AvailableDaysResult.dart';
import '../../../../../Sandfriends/Features/MatchSearch/View/NoMachesFound.dart';
import '../../ViewModel/LandingPageViewModel.dart';

class LandingPageWidgetWeb extends StatefulWidget {
  const LandingPageWidgetWeb({super.key});

  @override
  State<LandingPageWidgetWeb> createState() => _LandingPageWidgetWebState();
}

class _LandingPageWidgetWebState extends State<LandingPageWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final viewModel = Provider.of<LandingPageViewModel>(context, listen: false);
    return Container(
      color: secondaryBackWeb,
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WebHeader(),
          Expanded(
            child: viewModel.hasUserSearched == false
                ? CustomScrollView(slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(children: [
                        LandingPageHeader(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: width * (1 - defaultWebScreenWidth)),
                          child: ReservationSteps(),
                        ),
                        SizedBox(
                          height: defaultPadding * 2,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        LandingPageFooter()
                      ]),
                    ),
                  ])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2,
                            vertical: defaultPadding),
                        child: SearchFilter(
                          onTapLocation: () =>
                              viewModel.openCitySelectorModal(context),
                          onTapDate: () =>
                              viewModel.openDateSelectorModal(context),
                          onTapTime: () =>
                              viewModel.openTimeSelectorModal(context),
                          city: viewModel.cityFilter,
                          dates: viewModel.datesFilter,
                          time: viewModel.timeFilter,
                          onSearch: () => viewModel.searchCourts(context),
                          direction: Axis.vertical,
                        ),
                      ),
                      Expanded(
                        child: viewModel.availableDays.isEmpty
                            ? const NoMatchesFound()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: defaultPadding),
                                child: SingleChildScrollView(
                                  child: AvailableDaysResult(
                                    availableDays: viewModel.availableDays,
                                    onTapHour: (avDay) {
                                      viewModel.onSelectedHour(avDay);
                                      viewModel.goToCourt(
                                        context,
                                        viewModel.selectedStore!.store,
                                      );
                                    },
                                    onGoToCourt: (store) => viewModel.goToCourt(
                                      context,
                                      store,
                                      noArguments: true,
                                    ),
                                    selectedAvailableDay: viewModel.selectedDay,
                                    selectedStore: viewModel.selectedStore,
                                    selectedAvailableHour:
                                        viewModel.selectedHour,
                                    isRecurrent: false,
                                    showDescription: false,
                                    resetSelectedAvailableHour: () =>
                                        viewModel.resetSelectedAvailableHour(),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
