import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Checkout/View/CheckoutWidget.dart';
import 'package:sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Features/Court/Model/HourPrice.dart';
import 'package:sandfriends/SharedComponents/Model/AppBarType.dart';
import 'package:sandfriends/SharedComponents/Model/Court.dart';
import 'package:sandfriends/SharedComponents/Model/Sport.dart';

import '../../../SharedComponents/Model/Store.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';

class CheckoutScreen extends StatefulWidget {
  Court court;
  List<HourPrice> hourPrices;
  Sport sport;
  DateTime? date;
  int? weekday;
  bool isRecurrent;

  CheckoutScreen({
    required this.court,
    required this.hourPrices,
    required this.sport,
    required this.date,
    required this.weekday,
    required this.isRecurrent,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final viewModel = CheckoutViewModel();

  @override
  void initState() {
    viewModel.initCheckoutScreen(
      context,
      widget.court,
      widget.hourPrices,
      widget.sport,
      widget.date,
      widget.weekday,
      widget.isRecurrent,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CheckoutViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: "Resumo do agendamento",
            appBarType: AppBarType.Secondary,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: CheckoutWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
