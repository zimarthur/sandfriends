import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/Model/AppBarType.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../ViewModel/RewardsViewModel.dart';
import 'RewardsWidget.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final viewModel = RewardsViewModel();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RewardsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<RewardsViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            titleText: viewModel.titleText,
            appBarType: AppBarType.Secondary,
            rightWidget: InkWell(
              onTap: () => viewModel.showScreenInformationModal(context),
              child: SvgPicture.asset(
                r"assets/icon/help.svg",
                color: secondaryYellow,
                height: toolbarHeight * 0.7,
              ),
            ),
            modalFormWidget: viewModel.widgetForm,
            messageModalWidget: viewModel.modalMessage,
            onTapBackground: () => viewModel.closeModal(),
            onTapReturn: () => viewModel.onTapReturn(context),
            child: RewardsWidget(
              viewModel: viewModel,
            ),
          );
        },
      ),
    );
  }
}
