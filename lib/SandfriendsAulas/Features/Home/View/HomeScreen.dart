import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassItem.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/View/Onboarding/OnboardingTeacher.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/ViewModel/HomeScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/Components/HomeHeader.dart';
import '../../../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../SandfriendsQuadras/Features/Home/View/Mobile/KPI.dart';
import '../../Menu/SFDrawerAulas.dart';
import 'HomeLinkItem.dart';

class HomeScreenAulas extends StatefulWidget {
  const HomeScreenAulas({super.key});

  @override
  State<HomeScreenAulas> createState() => _HomeScreenAulasState();
}

class _HomeScreenAulasState extends State<HomeScreenAulas> {
  final viewModel = HomeScreenAulasViewModel();

  @override
  void initState() {
    Provider.of<StandardScreenViewModel>(context, listen: false)
        .setPageStatusOk();
    viewModel.initHomeScreenViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<HomeScreenAulasViewModel>(
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
                    notificationsOn: Provider.of<UserProvider>(context)
                        .notifications
                        .any((notification) => notification.seen == false),
                    photo: Provider.of<UserProvider>(context).user!.photo,
                    photoName:
                        Provider.of<UserProvider>(context).user!.fullName,
                  ),
                  Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async =>
                        Provider.of<TeacherProvider>(context, listen: false)
                            .getTeacherInfo(
                      context,
                      null,
                    ),
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: defaultPadding,
                          ),
                          OnboardingTeacher(),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Text(
                              "O que você deseja fazer?",
                              style: TextStyle(
                                color: textDarkGrey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                HomeLinkItem(
                                  iconPath: r"assets/icon/class.svg",
                                  title: "Aulas",
                                  onTap: () => Navigator.of(context)
                                      .pushNamed("/classes"),
                                ),
                                HomeLinkItem(
                                  iconPath: r"assets/icon/team.svg",
                                  title: "Turmas",
                                  onTap: () =>
                                      Navigator.of(context).pushNamed("/teams"),
                                ),
                                HomeLinkItem(
                                  iconPath: r"assets/icon/user_group.svg",
                                  title: "Alunos",
                                  onTap: () => Navigator.of(context)
                                      .pushNamed("/students"),
                                ),
                                HomeLinkItem(
                                  iconPath: r"assets/icon/class_plans.svg",
                                  title: "Planos",
                                  onTap: () => Navigator.of(context)
                                      .pushNamed("/class_plans"),
                                ),
                                HomeLinkItem(
                                  iconPath: r"assets/icon/user.svg",
                                  title: "Meu perfil",
                                  onTap: () => Navigator.of(context)
                                      .pushNamed("/teacher_details"),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 2 * defaultPadding,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding,
                            ),
                            child: Text(
                              "Aulas do dia",
                              style: TextStyle(
                                color: textDarkGrey,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: defaultPadding / 2,
                          ),
                          Provider.of<TeacherProvider>(context)
                                  .todayMatches
                                  .isEmpty
                              ? SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Center(
                                    child: Text(
                                      "Você não tem aulas hoje",
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Provider.of<TeacherProvider>(
                                    context,
                                  ).todayMatches.length,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding / 2),
                                  itemBuilder: (context, index) {
                                    AppMatchUser match =
                                        Provider.of<TeacherProvider>(
                                      context,
                                    ).todayMatches[index];
                                    return ClassItem(
                                      match: match,
                                      team: match.team!,
                                    );
                                  })
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
