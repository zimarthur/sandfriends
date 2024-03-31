import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/NoTeamsRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/TeamItem.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/PlusButtoonOverlay.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/TeamsAulasScreenViewModel.dart';

class TeamsAulasScreen extends StatefulWidget {
  const TeamsAulasScreen({super.key});

  @override
  State<TeamsAulasScreen> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<TeamsAulasScreen> {
  final viewModel = TeamsAulasScreenViewModel();

  @override
  void initState() {
    viewModel.initTeamsAulasViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamsAulasScreenViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<TeamsAulasScreenViewModel>(
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
                    title: "Suas turmas",
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                      ),
                      child: Provider.of<TeacherProvider>(context).teams.isEmpty
                          ? NoTeamsRegistered()
                          : PlusButtonOverlay(
                              onTap: () =>
                                  Navigator.pushNamed(context, "/create_team"),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 2 * defaultPadding,
                                  ),
                                  SectionTitleText(title: "Minhas turmas"),
                                  SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          Provider.of<TeacherProvider>(context)
                                              .teams
                                              .length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: index ==
                                                    (Provider.of<TeacherProvider>(
                                                                context)
                                                            .teams
                                                            .length -
                                                        1)
                                                ? 60
                                                : defaultPadding,
                                          ),
                                          child: TeamItem(
                                              team:
                                                  Provider.of<TeacherProvider>(
                                                          context)
                                                      .teams[index]),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
