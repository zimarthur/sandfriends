import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFReturnButton.dart';
import 'package:sandfriends/Common/Components/SFTabs.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/NoTeamsRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/TeamItem.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/PlusButtoonOverlay.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/TeamDetailsViewModel.dart';

class TeamDetailsScreen extends StatefulWidget {
  const TeamDetailsScreen({super.key});

  @override
  State<TeamDetailsScreen> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<TeamDetailsScreen> {
  final viewModel = TeamDetailsViewModel();

  @override
  void initState() {
    viewModel.initTeamDetailsViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeamDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<TeamDetailsViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            enableToolbar: false,
            background: primaryLightBlue,
            customOnTapReturn: () => viewModel.onTapReturn(context),
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SFReturnButton(
                      color: primaryLightBlue,
                      isPrimary: false,
                    ),
                  ),
                  SizedBox(
                    height: 130,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: secondaryBack,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    defaultBorderRadius,
                                  ),
                                  topRight: Radius.circular(
                                    defaultBorderRadius,
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 130,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: defaultPadding,
                                  left: defaultPadding,
                                ),
                                child: SFAvatarUser(
                                  height: 120,
                                  user: Provider.of<UserProvider>(context,
                                          listen: false)
                                      .user!,
                                  showRank: false,
                                  customBorderColor: primaryLightBlue,
                                ),
                              ),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                      "Turma Beach Praianas Praianas Praianas",
                                      style: TextStyle(
                                        color: textWhite,
                                        // fontSize: 20,
                                      ),
                                      minFontSize: 14,
                                      maxFontSize: 20,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      "por Arthur Zim",
                                      style: TextStyle(
                                          color: textWhite,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    SizedBox(
                                      height: 60,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        r"assets/icon/court.svg",
                                        height: 15,
                                        color: textDarkGrey,
                                      ),
                                      Text(
                                        "2",
                                        style: TextStyle(
                                          color: primaryLightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "horários",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: textLightGrey,
                                  width: 2,
                                  height: 40,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        r"assets/icon/user_group.svg",
                                        height: 15,
                                        color: textDarkGrey,
                                      ),
                                      Text(
                                        "6",
                                        style: TextStyle(
                                          color: primaryLightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "alunos",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: defaultPadding,
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
                                  horizontal: defaultPadding / 2),
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
