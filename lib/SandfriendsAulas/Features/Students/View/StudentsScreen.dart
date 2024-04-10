import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Home/ViewModel/HomeScreenViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/Model/UserClassPayment.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Students/View/StudentPaymentItem.dart';
import 'package:sandfriends/SandfriendsAulas/Providers/MenuProviderAulas.dart';

import '../../../../Common/Components/HomeHeader.dart';
import '../../../../Common/Providers/Drawer/EnumDrawerPage.dart';
import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../../SandfriendsQuadras/Features/Home/View/Mobile/KPI.dart';
import '../../../../SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';
import '../../../../SandfriendsQuadras/Features/Players/View/Mobile/PlayersResume.dart';
import '../../Menu/SFDrawerAulas.dart';
import '../ViewModel/StudentsScreenViewModel.dart';

class StudentsScreenAulas extends StatefulWidget {
  const StudentsScreenAulas({super.key});

  @override
  State<StudentsScreenAulas> createState() => _StudentsScreenAulasState();
}

class _StudentsScreenAulasState extends State<StudentsScreenAulas> {
  final viewModel = StudentsScreenAulasViewModel();
  bool isExpanded = false;
  @override
  void initState() {
    viewModel.initStudentsViewModel(context);
    super.initState();
  }

  void expand() {
    setState(() {
      isExpanded = true;
    });
  }

  void collapse() {
    setState(() {
      isExpanded = false;
    });
  }

  void toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StudentsScreenAulasViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<StudentsScreenAulasViewModel>(
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
                  SFStandardHeader(
                    title: "Alunos",
                    leftWidget: InkWell(
                      onTap: () => toggleExpand(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(defaultPadding),
                          margin:
                              const EdgeInsets.only(left: defaultPadding / 2),
                          child: SvgPicture.asset(
                            r"assets/icon/search.svg",
                            color: textWhite,
                            height: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlayersResume(
                          collapse: () => collapse(),
                          expand: () => expand(),
                          isExpanded: isExpanded,
                          playerController: viewModel.nameFilterController,
                          onUpdatePlayerFilter: (newPlayer) =>
                              viewModel.filterName(context),
                          playersQuantity: viewModel
                              .filteredClassPaymentUsers.length
                              .toString(),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: defaultPadding / 2),
                          child: Text(
                            "Alunos",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding / 2,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: defaultPadding / 2),
                            padding: EdgeInsets.all(
                              defaultPadding / 2,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                defaultBorderRadius,
                              ),
                              color: secondaryPaper,
                              border: Border.all(
                                color: divider,
                              ),
                            ),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    viewModel.filteredClassPaymentUsers.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (context, index) {
                                  UserClassPayment userClassPayment = viewModel
                                      .filteredClassPaymentUsers[index];
                                  return StudentPaymentItem(
                                    userClassPayment: userClassPayment,
                                  );
                                }),
                          ),
                        ),
                      ],
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
