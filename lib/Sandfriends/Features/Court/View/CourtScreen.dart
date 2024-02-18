import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';

import '../../../../Common/Model/Hour.dart';
import '../../../../Common/Model/Sport.dart';
import '../../../../Common/Model/Store/StoreComplete.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../Model/CourtAvailableHours.dart';
import '../ViewModel/CourtViewModel.dart';
import 'CourtWidget.dart';

class CourtScreen extends StatefulWidget {
  final StoreUser? store;
  final String? idStore;
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
    this.store,
    this.idStore,
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
      widget.idStore,
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
            child: CourtWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
