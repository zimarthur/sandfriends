import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFLoading.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';

import '../ViewModel/ClassesViewModel.dart';
import 'SchoolItem.dart';
import 'TeacherItem.dart';

class ClassesWidget extends StatefulWidget {
  const ClassesWidget({super.key});

  @override
  State<ClassesWidget> createState() => _ClassesWidgetState();
}

class _ClassesWidgetState extends State<ClassesWidget> {
  final viewModel = ClassesViewModel();

  @override
  void initState() {
    viewModel.initClassesViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ClassesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ClassesViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 150,
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryBlue,
                      secondaryLightBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      defaultBorderRadius,
                    ),
                    bottomRight: Radius.circular(
                      defaultBorderRadius,
                    ),
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Minhas aulas",
                        style: TextStyle(
                          color: textWhite,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "Eleve o nível do seu jogo com Sandfriends",
                        style: TextStyle(
                          color: textWhite,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => viewModel.getClassesInfo(
                    context,
                  ),
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: SectionTitleText(
                              title: "Professores disponíveis"),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        SizedBox(
                          height: 110,
                          child: Provider.of<UserProvider>(context)
                                      .availableTeachers ==
                                  null
                              ? Center(
                                  child: SFLoading(),
                                )
                              : Provider.of<UserProvider>(context)
                                      .availableTeachers!
                                      .isEmpty
                                  ? Center(
                                      child: Text(
                                        "Nenhum professor na sua cidade",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          Provider.of<UserProvider>(context)
                                              .availableTeachers!
                                              .length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: index == 0
                                                  ? defaultPadding
                                                  : 0),
                                          child: TeacherItem(
                                            teacher: Provider.of<UserProvider>(
                                                    context)
                                                .availableTeachers![index],
                                          ),
                                        );
                                      },
                                    ),
                        ),
                        SizedBox(
                          height: 2 * defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding),
                          child: SectionTitleText(title: "Escolas"),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Provider.of<UserProvider>(context).availableSchools ==
                                null
                            ? SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Center(
                                  child: SFLoading(),
                                ),
                              )
                            : Provider.of<UserProvider>(context)
                                    .availableTeachers!
                                    .isEmpty
                                ? SizedBox(
                                    width: double.infinity,
                                    height: 200,
                                    child: Center(
                                      child: Text(
                                        "Nenhuma escola na sua cidade",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                        ),
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      for (int index = 0;
                                          index <
                                              Provider.of<UserProvider>(context)
                                                  .availableSchools!
                                                  .length;
                                          index++)
                                        SchoolItem(
                                          school:
                                              Provider.of<UserProvider>(context)
                                                  .availableSchools![index],
                                        ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
