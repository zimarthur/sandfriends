import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Responsive.dart';
import '../ViewModel/MenuProvider.dart';
import 'Mobile/DrawerMobile/SFDrawerMobile.dart';
import 'Mobile/MenuWidgetMobile.dart';
import 'Web/MenuWidgetWeb.dart';

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
            child: StandardScreen(
              enableToolbar: false,
              drawer: Responsive.isMobile(context)
                  ? SFDrawerMobile(
                      viewModel: viewModel,
                    )
                  : null,
              scaffoldKey: viewModel.scaffoldKey,
              childWeb: MenuWidgetWeb(viewModel: viewModel),
              child: MenuWidgetMobile(viewModel: viewModel),
            ),
          );
        },
      ),
    );
  }
}
