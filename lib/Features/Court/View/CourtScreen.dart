import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';

import '../../../SharedComponents/Model/AvailableDay.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../Model/CourtAvailableHours.dart';
import '../ViewModel/CourtViewModel.dart';
import 'CourtWidget.dart';

class CourtScreen extends StatefulWidget {
  Store store;
  List<CourtAvailableHours>? courtAvailableHours;
  HourPrice? selectedHourPrice;
  DateTime? selectedDate;
  int? selectedWeekday;
  Sport? selectedSport;
  bool? isRecurrent;

  CourtScreen({
    required this.store,
    this.courtAvailableHours,
    this.selectedHourPrice,
    this.selectedDate,
    this.selectedWeekday,
    this.selectedSport,
    this.isRecurrent,
  });

  @override
  State<CourtScreen> createState() => _CourtScreenState();
}

class _CourtScreenState extends State<CourtScreen> {
  final viewModel = CourtViewModel();

  @override
  void initState() {
    viewModel.initCourtViewModel(
      widget.store,
      widget.courtAvailableHours,
      widget.selectedHourPrice,
      widget.selectedDate,
      widget.selectedWeekday,
      widget.selectedSport,
      widget.isRecurrent,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CourtViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CourtViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            enableToolbar: false,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: CourtWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
