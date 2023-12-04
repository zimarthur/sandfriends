import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../Model/HomeTabsEnum.dart';
import '../ViewModel/HomeViewModel.dart';
import 'NavigationMenu/NavigationMenu.dart';

class HomeScreen extends StatefulWidget {
  final HomeTabs initialTab;
  const HomeScreen({
    Key? key,
    required this.initialTab,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final viewModel = HomeViewModel();

  @override
  void initState() {
    viewModel.initHomeScreen(widget.initialTab, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HomeViewModel>(
        builder: (context, viewModel, _) {
          return SFStandardScreen(
            pageStatus: viewModel.pageStatus,
            enableToolbar: false,
            messageModalWidget: viewModel.modalMessage,
            modalFormWidget: viewModel.widgetForm,
            onTapBackground: () => viewModel.closeModal(),
            canTapBackground: viewModel.canTapBackground,
            onTapReturn: () => false,
            child: Column(
              children: [
                Expanded(child: viewModel.displayWidget),
                NavigationMenu(
                  onChangeTab: (newTab) => viewModel.changeTab(context, newTab),
                  selectedTab: viewModel.currentTab,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
