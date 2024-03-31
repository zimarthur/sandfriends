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
import '../ViewModel/StudentsScreenViewModel.dart';

class StudentsScreenAulas extends StatefulWidget {
  const StudentsScreenAulas({super.key});

  @override
  State<StudentsScreenAulas> createState() => _StudentsScreenAulasState();
}

class _StudentsScreenAulasState extends State<StudentsScreenAulas> {
  final viewModel = StudentsScreenAulasViewModel();

  @override
  void initState() {
    viewModel.initStudentsViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentsScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<StudentsScreenAulasViewModel>(
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
