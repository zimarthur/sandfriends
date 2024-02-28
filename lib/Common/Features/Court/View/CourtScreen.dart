import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Features/Court/View/Web/CourtWidgetWeb.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../Model/Hour.dart';
import '../../../Model/Sport.dart';
import '../../../Model/Store/StoreComplete.dart';
import '../../../StandardScreen/StandardScreen.dart';
import '../Model/CourtAvailableHours.dart';
import '../ViewModel/CourtViewModel.dart';
import 'Mobile/CourtWidgetMobile.dart';

class CourtScreen extends StatefulWidget {
  final String storeUrl;
  final StoreUser? store;
  final List<CourtAvailableHours>? courtAvailableHours;
  final HourPriceUser? selectedHourPrice;
  final DateTime? selectedDate;
  final int? selectedWeekday;
  final Sport? selectedSport;
  final bool? isRecurrent;
  final bool canMakeReservation;
  final Hour? searchStartPeriod;
  final Hour? searchEndPeriod;

  const CourtScreen({
    super.key,
    required this.storeUrl,
    this.store,
    this.courtAvailableHours,
    this.selectedHourPrice,
    this.selectedDate,
    this.selectedWeekday,
    this.selectedSport,
    this.isRecurrent,
    required this.canMakeReservation,
    this.searchStartPeriod,
    this.searchEndPeriod,
  });

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  final viewModel = CourtViewModel();

  @override
  void initState() {
    viewModel.initCourtViewModel(
      context,
      widget.store,
      widget.storeUrl,
      widget.courtAvailableHours,
      widget.selectedHourPrice,
      widget.selectedDate,
      widget.selectedWeekday,
      widget.selectedSport,
      widget.isRecurrent,
      widget.canMakeReservation,
      widget.searchStartPeriod,
      widget.searchEndPeriod,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CourtViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CourtViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            enableToolbar: false,
            background: secondaryBack,
            child: CourtWidgetMobile(
              viewModel: viewModel,
            ),
            childWeb: CourtWidgetWeb(),
          );
        },
      ),
    );
  }
}
