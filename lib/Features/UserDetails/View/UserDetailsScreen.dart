import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/Model/Sport.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/UserDetailsViewModel.dart';
import 'UserDetailsWidget.dart';

class UserDetailsScreen extends StatefulWidget {
  final Sport? initSport;
  final UserDetailsModals initModalEnum;
  const UserDetailsScreen(
      {Key? key, required this.initSport, required this.initModalEnum})
      : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final viewModel = UserDetailsViewModel();

  @override
  void initState() {
    viewModel.initUserDetailsViewModel(
        context, widget.initSport, widget.initModalEnum);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<UserDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<UserDetailsViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            titleText: viewModel.titleText,
            onTapReturn: () => viewModel.goToHome(context),
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.modalForm,
            pageStatus: viewModel.pageStatus,
            appBarType: AppBarType.Secondary,
            rightWidget: SizedBox(
              width: width * 0.2,
              height: toolbarHeight * 0.9,
              child: SFButton(
                buttonLabel: "Salvar",
                color: viewModel.isEdited ? primaryBlue : textDisabled,
                onTap: () {
                  if (viewModel.isEdited) {
                    viewModel.updateUserInfo(context);
                  }
                },
              ),
            ),
            child: UserDetailsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
