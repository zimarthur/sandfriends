import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlanItem.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/ViewModel/HomeScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/Components/HomeHeader.dart';
import '../../../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../SandfriendsQuadras/Features/Home/View/Mobile/KPI.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/ClassPlansScreenViewModel.dart';

class ClassPlansScreenAulas extends StatefulWidget {
  const ClassPlansScreenAulas({super.key});

  @override
  State<ClassPlansScreenAulas> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<ClassPlansScreenAulas> {
  final viewModel = ClassPlansScreenAulasViewModel();

  @override
  void initState() {
    viewModel.initClassPlansViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassPlansScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ClassPlansScreenAulasViewModel>(
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
                  SFStandardHeader(
                    title: "Planos e preços",
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      child: Provider.of<TeacherProvider>(context)
                                  .classPlans
                                  .isEmpty &&
                              viewModel.currentPlan == null
                          ? NoPlansRegistered(
                              onRegisterPlans: () => viewModel.setCurrentPlan(),
                            )
                          : ClassPlansWidget(
                              viewModel: viewModel,
                            ),
                    ),
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
