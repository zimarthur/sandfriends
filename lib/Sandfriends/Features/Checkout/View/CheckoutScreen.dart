import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/View/CheckoutWidget.dart';
import 'package:sandfriends/Sandfriends/Features/Checkout/ViewModel/CheckoutViewModel.dart';
import 'package:sandfriends/Common/Model/HourPrice/HourPriceUser.dart';
import 'package:sandfriends/Common/Model/AppBarType.dart';
import 'package:sandfriends/Common/Model/Court.dart';
import 'package:sandfriends/Common/Model/Sport.dart';

import '../../../../Common/Model/Team.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';

class CheckoutScreen extends StatefulWidget {
  final Court court;
  final List<HourPriceUser> hourPrices;
  final Sport sport;
  final DateTime? date;
  final int? weekday;
  final bool isRecurrent;
  final bool isRenovating;
  final Team? team;

  const CheckoutScreen({
    super.key,
    required this.court,
    required this.hourPrices,
    required this.sport,
    required this.date,
    required this.weekday,
    required this.isRecurrent,
    required this.isRenovating,
    required this.team,
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
      widget.isRenovating,
      widget.team,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CheckoutViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CheckoutViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            titleText: "Resumo do agendamento",
            appBarType: AppBarType.Secondary,
            child: CheckoutWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
