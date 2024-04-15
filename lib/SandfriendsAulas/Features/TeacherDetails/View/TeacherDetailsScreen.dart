import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/SandfriendsAulas/Features/TeacherDetails/ViewModel/TeacherDetailsViewModel.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/Components/SFButton.dart';
import '../../../../Common/Features/UserDetails/View/Mobile/UserDetailsWidgetMobile.dart';
import '../../../../Common/Features/UserDetails/ViewModel/UserDetailsViewModel.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../Menu/SFDrawerAulas.dart';

class TeacherDetailsScreen extends StatefulWidget {
  const TeacherDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TeacherDetailsScreen> createState() => _TeacherDetailsScreenState();
}

class _TeacherDetailsScreenState extends State<TeacherDetailsScreen> {
  final viewModel = TeacherDetailsViewModel();
  final userViewModel = UserDetailsViewModel();

  @override
  void initState() {
    viewModel.initTeacherDetailsViewModel(
      context,
    );
    userViewModel.initUserDetailsViewModel(
        context, null, UserDetailsModals.None);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ChangeNotifierProvider<TeacherDetailsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<TeacherDetailsViewModel>(
        builder: (context, viewModel, _) {
          return ChangeNotifierProvider<UserDetailsViewModel>(
            create: (BuildContext context) => userViewModel,
            child: Consumer<UserDetailsViewModel>(
                builder: (context, userViewModel, _) {
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
                        isPrimaryBlue: false,
                        title: "Meu perfil",
                        leftWidget: Center(
                          child: LayoutBuilder(
                              builder: (layoutContext, layoutConstraints) {
                            return SizedBox(
                              width: layoutConstraints.maxWidth * 0.7,
                              height: layoutConstraints.maxHeight * 0.6,
                              child: SFButton(
                                buttonLabel: "Salvar",
                                color: userViewModel.isEdited
                                    ? primaryBlue
                                    : textDisabled,
                                onTap: () =>
                                    userViewModel.updateUserInfo(context),
                              ),
                            );
                          }),
                        ),
                      ),
                      Expanded(
                        child: UserDetailsWidgetMobile(
                          viewModel: userViewModel,
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
