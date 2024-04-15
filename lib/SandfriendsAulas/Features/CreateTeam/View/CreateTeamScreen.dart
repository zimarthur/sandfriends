import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Components/SFButton.dart';
import 'package:sandfriends/Common/Components/SFTextField.dart';
import 'package:sandfriends/Common/Features/Court/View/SportFilter.dart';
import 'package:sandfriends/Common/Model/AppBarType.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/TeacherProvider/TeacherProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/ClassPlansWidget.dart';
import 'package:sandfriends/SandfriendsAulas/Features/ClassPlans/View/NoPlansRegistered.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/GenderPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/RankPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/View/SportPopUp.dart';
import 'package:sandfriends/SandfriendsAulas/Features/CreateTeam/ViewModel/CreateTeamViewModel.dart';
import 'package:sandfriends/SandfriendsAulas/Features/Teams/View/NoTeamsRegistered.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Menu/View/Mobile/SFStandardHeader.dart';

import '../../../../Common/StandardScreen/StandardScreen.dart';
import '../../../../Common/Utils/Constants.dart';
import '../../Menu/SFDrawerAulas.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _ClassPlansScreenAulasState();
}

class _ClassPlansScreenAulasState extends State<CreateTeamScreen> {
  final viewModel = CreateTeamViewModel();

  @override
  void initState() {
    viewModel.initCreateTeamViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateTeamViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<CreateTeamViewModel>(
        builder: (context, viewModel, _) {
          return PopScope(
            canPop: false,
            onPopInvoked: (pop) {},
            child: StandardScreen(
              //background: primaryBlue,
              titleText: "Nova turma",
              appBarType: AppBarType.Primary,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          SFAvatarUser(
                            height: 120,
                            user: Provider.of<UserProvider>(context,
                                    listen: false)
                                .user!,
                            showRank: false,
                          ),
                          SizedBox(
                            width: defaultPadding / 2,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nome da aula",
                                ),
                                SFTextField(
                                  labelText: "",
                                  pourpose: TextFieldPourpose.Standard,
                                  controller: viewModel.nameController,
                                  hintText: "Ex: Grupo iniciante feminino",
                                  validator: (a) {},
                                ),
                                SizedBox(
                                  height: defaultPadding / 2,
                                ),
                                Text(
                                  "por ${Provider.of<UserProvider>(context, listen: false).user!.fullName}",
                                  style: TextStyle(
                                    color: textDarkGrey,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
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
                      Text(
                        "Descrição",
                      ),
                      SizedBox(
                        height: defaultPadding / 4,
                      ),
                      SFTextField(
                        labelText: "",
                        pourpose: TextFieldPourpose.Multiline,
                        controller: viewModel.descriptionController,
                        minLines: 5,
                        maxLines: 6,
                        onChanged: (newValue) =>
                            viewModel.onChangedDescription(newValue),
                        hintText: "Descreva como são as aulas dessa turma!",
                        validator: (a) {},
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          viewModel.maxSizeDescriptionText,
                          style: TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Esporte",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: SportPopUp(
                              selectedSport: viewModel.newTeam.sport,
                              onSelectedSport: (sport) =>
                                  viewModel.updateSport(sport),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Categoria",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: RankPopUp(
                              selectedRank: viewModel.newTeam.rank,
                              currentSport: viewModel.newTeam.sport,
                              onSelectedRank: (rank) =>
                                  viewModel.updateRank(rank),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Gênero",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: GenderPopUp(
                              selectedGender: viewModel.newTeam.gender,
                              onSelectedGender: (gender) =>
                                  viewModel.updateGender(gender),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 3 * defaultPadding,
                      ),
                      SFButton(
                          buttonLabel: "Criar turma",
                          onTap: () => viewModel.onCreateTeam(context)),
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
