import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/NewCreditCard/View/NewCreditCardWidget.dart';
import 'package:sandfriends/Features/NewCreditCard/ViewModel/NewCreditCardViewModel.dart';
import 'package:sandfriends/SharedComponents/Model/AppBarType.dart';
import 'package:sandfriends/SharedComponents/View/SFStandardScreen.dart';

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
          return SFStandardScreen(
            titleText: "Novo Cartão de Crédito",
            appBarType: AppBarType.Secondary,
            pageStatus: viewModel.pageStatus,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            onTapReturn: () => Navigator.pop(context),
            child: NewCreditCardWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
