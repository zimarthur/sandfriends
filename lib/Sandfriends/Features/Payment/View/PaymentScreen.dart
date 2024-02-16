import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/Payment/View/PaymentWidget.dart';
import 'package:sandfriends/Sandfriends/Features/Payment/ViewModel/PaymentViewModel.dart';

import '../../../../Common/Model/AppBarType.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final viewModel = PaymentViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<PaymentViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            titleText: "Formas de Pagamento",
            appBarType: AppBarType.Secondary,
            child: PaymentWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
