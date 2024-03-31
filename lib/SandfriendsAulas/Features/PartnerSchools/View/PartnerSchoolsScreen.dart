import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Features/Court/View/SportFilter.dart';
import 'package:sandfriends/Common/Model/AppBarType.dart';
import 'package:sandfriends/Common/Model/School/SchoolTeacher.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/GenderPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/RankPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/SportPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/ViewModel/CreateTeamViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/PartnerSchools/View/PartnerSchoolItem.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/NoTeamsRegistered.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/PartnerSchoolsViewModel.dart';

class PartnerSchoolsScreen extends StatefulWidget {
  const PartnerSchoolsScreen({super.key});

  @override
  State<PartnerSchoolsScreen> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<PartnerSchoolsScreen> {
  final viewModel = PartnerSchoolsViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PartnerSchoolsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<PartnerSchoolsViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {},
            child: StandardScreen(
              titleText: "Escolas parceiras",
              appBarType: AppBarType.Primary,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: defaultPadding,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: Provider.of<TeacherProvider>(context)
                            .schools
                            .length,
                        itemBuilder: (context, index) {
                          return PartnerSchoolItem(
                            school: Provider.of<TeacherProvider>(context)
                                .schools[index],
                            onInviteResponse: (school) =>
                                viewModel.onInviteResponse(context, school),
                          );
                        },
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
