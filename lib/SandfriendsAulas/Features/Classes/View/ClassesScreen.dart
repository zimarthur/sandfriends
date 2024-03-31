import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassItem.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/WeekdayRowSelector.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/ViewModel/HomeScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/PlusButtoonOverlay.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/Components/HomeHeader.dart';
import '../../../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../SandfriendsQuadras/Features/Home/View/Mobile/KPI.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/ClassesScreenViewModel.dart';

class ClassesScreenAulas extends StatefulWidget {
  const ClassesScreenAulas({super.key});

  @override
  State<ClassesScreenAulas> createState() => _ClassesScreenAulasState();
}

class _ClassesScreenAulasState extends State<ClassesScreenAulas> {
  final viewModel = ClassesScreenAulasViewModel();

  @override
  void initState() {
    viewModel.initClassesViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassesScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ClassesScreenAulasViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {
              viewModel.quickLinkHome(context);
            },
            child: StandardScreen(
              enableToolbar: false,
              customOnTapReturn: () => viewModel.onTapReturn(context),
              background: secondaryBack,
              drawer: SFDrawerAulas(
                viewModel: viewModel,
              ),
              child: PlusButtonOverlay(
                onTap: () =>
                    Navigator.pushNamed(context, "/recurrent_match_search"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SFStandardHeader(
                      title: "Minhas aulas",
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        "/partner_schools",
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: defaultPadding / 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          border: Border.all(
                            color: primaryBlue,
                            width: 2,
                          ),
                          color: secondaryPaper,
                        ),
                        padding: EdgeInsets.all(
                          defaultPadding,
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              r"assets/icon/court.svg",
                              height: 35,
                              color: primaryBlue,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Escolas parceiras",
                                    style: TextStyle(
                                      color: primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Veja as escolas que você pode dar aulas",
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding / 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: primaryBlue,
                                    ),
                                    padding: EdgeInsets.all(defaultPadding),
                                    child: Text(
                                      Provider.of<TeacherProvider>(context)
                                          .partnerSchools
                                          .toString(),
                                      style: TextStyle(
                                        color: textWhite,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                if (Provider.of<TeacherProvider>(context)
                                        .awaitingResponseSchools >
                                    0)
                                  Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: secondaryLightBlue,
                                      ),
                                      padding:
                                          EdgeInsets.all(defaultPadding / 3),
                                      child: Text(
                                        Provider.of<TeacherProvider>(context)
                                            .awaitingResponseSchools
                                            .toString(),
                                        style: TextStyle(
                                          color: textWhite,
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding),
                      child: SectionTitleText(title: "Aulas fixas"),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(defaultPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            defaultBorderRadius,
                          ),
                          color: secondaryPaper,
                          border: Border.all(
                            color: divider,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: defaultPadding,
                            ),
                            WeekdayRowSelector(
                              currentWeekday: viewModel.currentWeekday,
                              onSelectedWeekday: (newWeekday) =>
                                  viewModel.onUpdateWeekday(
                                newWeekday,
                              ),
                            ),
                            Expanded(
                              child: Builder(builder: (context) {
                                List<AppRecurrentMatchUser>
                                    recurrentMatchesForWeekday =
                                    Provider.of<TeacherProvider>(context)
                                        .recurrentMatches
                                        .where((recMatch) =>
                                            recMatch.weekday ==
                                            viewModel.currentWeekday)
                                        .toList();
                                return recurrentMatchesForWeekday.isEmpty
                                    ? Center(
                                        child: Text(
                                          "Nenhuma aula nessa dia",
                                          style: TextStyle(
                                            color: textDarkGrey,
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: defaultPadding / 2),
                                        itemCount:
                                            recurrentMatchesForWeekday.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: index ==
                                                      (recurrentMatchesForWeekday
                                                              .length -
                                                          1)
                                                  ? 60
                                                  : defaultPadding,
                                            ),
                                            child: ClassItem(
                                              recMatch:
                                                  recurrentMatchesForWeekday[
                                                      index],
                                            ),
                                          );
                                        },
                                      );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
