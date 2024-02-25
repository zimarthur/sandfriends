import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/View/NewCreditCardWidget.dart';
import 'package:sandfriends/Sandfriends/Features/NewCreditCard/ViewModel/NewCreditCardViewModel.dart';
import 'package:sandfriends/Common/Model/AppBarType.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';

class NewCreditCardScreen extends StatefulWidget {
  const NewCreditCardScreen({Key? key}) : super(key: key);

  @override
  State<NewCreditCardScreen> createState() => _NewCreditCardScreenState();
}

class _NewCreditCardScreenState extends State<NewCreditCardScreen> {
  final viewModel = NewCreditCardViewModel();

  @override
  void initState() {
    viewModel.initNewCreditCard(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NewCreditCardViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<NewCreditCardViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            viewModel: viewModel,
            titleText: "Novo Cartão de Crédito",
            appBarType: AppBarType.Secondary,
            child: NewCreditCardWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
