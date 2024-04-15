import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Managers/LinkOpener/LinkOpenerManager.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/Teacher.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Features/Teacher/ViewModel/TeacherViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/TeamItem.dart';
import 'package:sandfriends/SandfriendsAulas/SharedComponents/AulasSectionTitleText.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../Common/Components/SFAvatarUser.dart';
import '../../../../Common/Components/SFReturnButton.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';

class TeacherScreen extends StatefulWidget {
  Teacher teacher;
  TeacherScreen({
    required this.teacher,
    super.key,
  });

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final viewModel = TeacherViewModel();
  @override
  void initState() {
    viewModel.initTeacherViewModel(
      context,
      widget.teacher,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TeacherViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<TeacherViewModel>(
        builder: (context, viewModel, _) {
          return StandardScreen(
            enableToolbar: false,
            background: secondaryBack,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: SFReturnButton(
                          color: primaryLightBlue,
                          isPrimary: true,
                        ),
                      ),
                      SFAvatarUser(
                        height: 150,
                        user: viewModel.teacher.user,
                        showRank: false,
                        customBorderColor: primaryLightBlue,
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        viewModel.teacher.user.fullName,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "desde ${viewModel.teacher.user.registrationDate!.formatWrittenMonthYear()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: textDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      if (viewModel.teacher.user.phoneNumber != null)
                        GestureDetector(
                          onTap: () => LinkOpenerManager().openWhatsApp(
                              context, viewModel.teacher.user.phoneNumber!),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              color: primaryLightBlue,
                            ),
                            padding: EdgeInsets.all(
                              defaultPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  r"assets/icon/whatsapp.svg",
                                  height: 25,
                                  color: textWhite,
                                ),
                                SizedBox(
                                  width: defaultPadding / 2,
                                ),
                                Expanded(
                                  child: AutoSizeText(
                                    "Chamar ${viewModel.teacher.user.firstName} no WhatsApp",
                                    style: TextStyle(
                                      color: textWhite,
                                    ),
                                    minFontSize: 10,
                                    maxFontSize: 14,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SectionTitleText(
                          title: "Turmas (${viewModel.teacher.teams.length})",
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      ListView.builder(
                        itemCount: viewModel.teacher.teams.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: defaultPadding),
                            child: TeamItem(
                              team: viewModel.teacher.teams[index],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
