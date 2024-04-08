import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatch.dart';
import 'package:sandfriends/Common/Model/AppRecurrentMatch/AppRecurrentMatchUser.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';
import 'package:sandfriends/Sandfriends/Features/Home/View/Classes/View/ClassesWidget.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/Model/EnumClassView.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/ClassItem.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Classes/View/RecurrentClassesWidget.dart';
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
import 'ClassesWidget.dart';

class ClassesScreenAulas extends StatefulWidget {
  const ClassesScreenAulas({super.key});

  @override
  State<ClassesScreenAulas> createState() => _ClassesScreenAulasState();
}

class _ClassesScreenAulasState extends State<ClassesScreenAulas> {
  final viewModel = ClassesScreenAulasViewModel();
  List<ClassView> availableClassViews = [
    ClassView.Classes,
    ClassView.RecurrentClasses
  ];

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
                onTap: () => viewModel.onAddClass(context),
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
                            horizontal: defaultPadding / 4),
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
                            horizontal: defaultPadding / 2),
                        child: PopupMenuButton(
                          surfaceTintColor: secondaryPaper,
                          onSelected: (newClassView) =>
                              viewModel.onChangedClassView(newClassView),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry>[
                            for (var classView in availableClassViews)
                              PopupMenuItem(
                                value: classView,
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icon/${classView == ClassView.Classes ? 'calendar' : 'recurrent_clock'}.svg",
                                      color: textDarkGrey,
                                      width: 20,
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Text(
                                      classView.title,
                                      style: TextStyle(
                                        color: textDarkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                          child: Row(
                            children: [
                              SectionTitleText(
                                title: viewModel.classView.title,
                              ),
                              SizedBox(
                                width: defaultPadding / 2,
                              ),
                              SvgPicture.asset(
                                r"assets/icon/chevron_down.svg",
                                color: textDarkGrey,
                                height: 15,
                              ),
                            ],
                          ),
                        )),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(defaultPadding / 4),
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
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding / 2,
                                ),
                                child: viewModel.classView == ClassView.Classes
                                    ? ClassesWidgetTeacher(
                                        viewModel: viewModel,
                                      )
                                    : RecurrenClassesWidget(
                                        viewModel: viewModel,
                                      ),
                              ),
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
