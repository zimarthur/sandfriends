import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Menu/View/Mobile/MenuWidgetMobile.dart';
import 'package:sandfriends_web/Features/Home/View/Mobile/HomeHeader.dart';
import 'package:sandfriends_web/Features/Menu/View/Web/MenuWidgetWeb.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../SharedComponents/View/SFModalMessage.dart';
import '../../../SharedComponents/View/SFStandardScreen.dart';
import '../../../Utils/PageStatus.dart';
import '../ViewModel/MenuProvider.dart';
import '../../../Utils/Responsive.dart';
import 'Web/DrawerWeb/SFDrawerWeb.dart';
import 'Mobile/DrawerMobile/SFDrawerMobile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final viewModel = MenuProvider();

  @override
  void initState() {
    viewModel.initHomeScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MenuProvider>(
      create: (BuildContext context) => viewModel,
      child: Consumer<MenuProvider>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {
              viewModel.quickLinkHome(context);
            },
            child: SFStandardScreen(
              drawer: Responsive.isMobile(context)
                  ? SFDrawerMobile(
                      viewModel: viewModel,
                    )
                  : null,
              scaffoldKey: viewModel.scaffoldKey,
              pageStatus: viewModel.pageStatus,
              messageModalWidget: viewModel.modalMessage,
              modalFormWidget: viewModel.modalFormWidget,
              childWeb: MenuWidgetWeb(viewModel: viewModel),
              childMobile: MenuWidgetMobile(viewModel: viewModel),
            ),
          );
        },
      ),
    );
  }
}
