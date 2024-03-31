import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFReturnButton.dart';
import 'package:sandfriends/Common/Components/SFTabs.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsHeader.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeamDetails/View/TeamDetailsInfoRow.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/NoTeamsRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/TeamItem.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/PlusButtoonOverlay.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/Managers/LinkOpener/LinkOpenerManager.dart';
import '../../../../Common/Model/Team.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/TeamDetailsViewModel.dart';

class TeamDetailsScreen extends StatefulWidget {
  Team team;
  TeamDetailsScreen({
    required this.team,
    super.key,
  });

  @override
  State<TeamDetailsScreen> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<TeamDetailsScreen> {
  final viewModel = TeamDetailsViewModel();

  @override
  void initState() {
    viewModel.initTeamDetailsViewModel(
      context,
      widget.team,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<TeamDetailsViewModel>(
        builder: (context, viewModel, _) {
          bool isUserInTeam = viewModel.team.isUserInTeam(
            Provider.of<UserProvider>(context, listen: false).user!,
          );
          bool hasUserSentInvitation = viewModel.team.hasUserSentInvitation(
            Provider.of<UserProvider>(context, listen: false).user!,
          );
          return StandardScreen(
            enableToolbar: false,
            background: primaryLightBlue,
            customOnTapReturn: () => viewModel.onTapReturn(context),
            child: SafeArea(
              child: Column(
                children: [
                  TeamDetailsHeader(
                    viewModel: viewModel,
                  ),
                  Expanded(
                    child: Container(
                      color: secondaryBack,
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding / 2,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TeamDetailsInfoRow(
                              viewModel: viewModel,
                            ),
                            SizedBox(
                              height: defaultPadding,
                            ),
                            if (!viewModel.isTeacherCreator)
                              Row(
                                children: [
                                  Expanded(
                                    child: !isUserInTeam
                                        ? SFButton(
                                            buttonLabel: "Participar",
                                            onTap: () => viewModel.joinTeam(
                                              context,
                                            ),
                                            color: primaryLightBlue,
                                            iconPath: r"assets/icon/plus.svg",
                                            iconSize: 20,
                                          )
                                        : SFButton(
                                            buttonLabel: hasUserSentInvitation
                                                ? "Convite enviado"
                                                : "Você já está nesse grupo",
                                            onTap: () {},
                                            color: primaryLightBlue,
                                            isPrimary: false,
                                            iconPath: hasUserSentInvitation
                                                ? r"assets/icon/check_circle.svg"
                                                : "",
                                            iconSize: 20,
                                          ),
                                  ),
                                  if (viewModel.team.teacher.phoneNumber !=
                                      null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: defaultPadding),
                                      child: GestureDetector(
                                        onTap: () => LinkOpenerManager()
                                            .openWhatsApp(
                                                context,
                                                viewModel
                                                    .team.teacher.phoneNumber!),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: secondaryPaper,
                                            border: Border.all(
                                              color: primaryLightBlue,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              defaultBorderRadius,
                                            ),
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              r"assets/icon/whatsapp.svg",
                                              color: primaryLightBlue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            SizedBox(
                              height: defaultPadding / 2,
                            ),
                            SFTabs(
                              tabs: viewModel.tabItems,
                              selectedPosition: viewModel.selectedTab,
                              expanded: true,
                              color: primaryLightBlue,
                            ),
                            SizedBox(
                              height: defaultPadding / 2,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2,
                              ),
                              child: viewModel.selectedTab.displayWidget,
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
