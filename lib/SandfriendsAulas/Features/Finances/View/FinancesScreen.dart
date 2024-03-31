import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/ViewModel/HomeScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/Components/HomeHeader.dart';
import '../../../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../SandfriendsQuadras/Features/Home/View/Mobile/KPI.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/FinancesScreenViewModel.dart';

class FinancesScreenAulas extends StatefulWidget {
  const FinancesScreenAulas({super.key});

  @override
  State<FinancesScreenAulas> createState() => _FinancesScreenAulasState();
}

class _FinancesScreenAulasState extends State<FinancesScreenAulas> {
  final viewModel = FinancesScreenAulasViewModel();

  @override
  void initState() {
    viewModel.initFinancesViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FinancesScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<FinancesScreenAulasViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {
              viewModel.quickLinkHome(context);
            },
            child: StandardScreen(
              enableToolbar: false,
              background: secondaryBack,
              customOnTapReturn: () => viewModel.onTapReturn(context),
              drawer: SFDrawerAulas(
                viewModel: viewModel,
              ),
              child: Column(
                children: [
                  HomeHeader(
                    primaryColor: primaryBlue,
                    secondaryColor: primaryLightBlue,
                    name: Provider.of<UserProvider>(context).user!.firstName!,
                    nameDescription: null,
                    notificationsOn: false,
                    photo: Provider.of<UserProvider>(context).user!.photo,
                    photoName:
                        Provider.of<UserProvider>(context).user!.fullName,
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
