import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/StoreSection.dart';
import 'package:sandfriends/Common/Model/Classes/School/SchoolUser.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherStore.dart';
import 'package:sandfriends/Common/Model/Classes/Teacher/TeacherUser.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/Sandfriends/Features/SchoolDetails/ViewModel/SchoolDetailsViewModel.dart';

import '../../../../Common/Components/SFReturnButton.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';

class SchoolDetailsScreen extends StatefulWidget {
  SchoolUser school;
  SchoolDetailsScreen({
    required this.school,
    super.key,
  });

  @override
  State<SchoolDetailsScreen> createState() => _SchoolDetailsScreenState();
}

class _SchoolDetailsScreenState extends State<SchoolDetailsScreen> {
  final viewModel = SchoolDetailsViewModel();

  @override
  void initState() {
    viewModel.initSchoolDetailsViewModel(context, widget.school);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SchoolDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<SchoolDetailsViewModel>(
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
                          color: primaryBlue,
                          isPrimary: true,
                        ),
                      ),
                      SFAvatarStore(
                        height: 120,
                        storeName: viewModel.school.name,
                        storePhoto: viewModel.school.logo,
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Text(
                        viewModel.school.name,
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        "desde ${viewModel.school.creationDate.formatWrittenMonthYear()}",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: textDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Local",
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                          context,
                          '/quadra/${viewModel.school.store.url}',
                          arguments: {
                            'store': viewModel.school.store,
                            'canMakeReservation': false,
                          },
                        ),
                        child: Row(
                          children: [
                            SFAvatarStore(
                              height: 80,
                              storeName: viewModel.school.store.name,
                              storePhoto: viewModel.school.store.logo,
                              enableShadow: true,
                            ),
                            SizedBox(
                              width: defaultPadding / 2,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        r"assets/icon/court.svg",
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          viewModel.school.store.name,
                                          style: TextStyle(
                                            color: primaryBlue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: defaultPadding / 2,
                                  ),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        r"assets/icon/location_ping.svg",
                                        color: textDarkGrey,
                                        height: 20,
                                      ),
                                      SizedBox(
                                        width: defaultPadding / 2,
                                      ),
                                      Expanded(
                                        child: Text(
                                          viewModel
                                              .school.store.completeAddress,
                                          style: TextStyle(
                                            color: textDarkGrey,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2 * defaultPadding,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Professores",
                          style: TextStyle(
                            color: textDarkGrey,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      ListView.builder(
                          itemCount: viewModel.school.teachers.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            TeacherStore teacher =
                                viewModel.school.teachers[index];
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                "/prof",
                                arguments: {
                                  "Teacher": teacher,
                                },
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    defaultBorderRadius,
                                  ),
                                  color: secondaryPaper,
                                  border: Border.all(
                                    color: divider,
                                  ),
                                ),
                                padding: EdgeInsets.all(
                                  defaultPadding / 2,
                                ),
                                margin: EdgeInsets.only(
                                  bottom: defaultPadding / 2,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SFAvatarUser(
                                      height: 50,
                                      user: teacher.user,
                                      showRank: false,
                                    ),
                                    SizedBox(
                                      width: defaultPadding / 2,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            teacher.user.fullName,
                                            style: TextStyle(
                                              color: primaryBlue,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            "desde ${teacher.teacherSchool.entryDate!.formatWrittenMonthYear()}",
                                            style: TextStyle(
                                              color: textDarkGrey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "ver mais ",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: textDarkGrey,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          r"assets/icon/chevron_right.svg",
                                          color: textDarkGrey,
                                          height: 15,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          })
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
