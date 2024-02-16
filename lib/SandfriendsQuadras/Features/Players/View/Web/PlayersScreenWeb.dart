import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Menu/ViewModel/DataProvider.dart';
import 'package:sandfriends_web/SharedComponents/View/SFBarChart.dart';
import 'package:sandfriends_web/SharedComponents/View/SFDropDown.dart';
import 'package:sandfriends_web/SharedComponents/View/SFPeriodToggle.dart';
import 'package:sandfriends_web/SharedComponents/View/SFPieChart.dart';
import 'package:sandfriends_web/SharedComponents/View/SFTextfield.dart';
import 'package:sandfriends_web/SharedComponents/View/Table/SFTable.dart';
import 'package:sandfriends_web/SharedComponents/View/Table/SFTableHeader.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../SharedComponents/View/SFCard.dart';
import '../../../../SharedComponents/View/SFHeader.dart';
import '../../../../SharedComponents/View/SFToggle.dart';
import '../../../../Utils/Constants.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../ViewModel/PlayersViewModel.dart';

class PlayersScreenWeb extends StatefulWidget {
  const PlayersScreenWeb({super.key});

  @override
  State<PlayersScreenWeb> createState() => _PlayersScreenWebState();
}

class _PlayersScreenWebState extends State<PlayersScreenWeb> {
  final PlayersViewModel viewModel = PlayersViewModel();

  @override
  void initState() {
    viewModel.initViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = Provider.of<MenuProvider>(context).getScreenWidth(context);
    double height = Provider.of<MenuProvider>(context).getScreenHeight(context);
    return ChangeNotifierProvider<PlayersViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<PlayersViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SFHeader(
                        header: "Jogadores",
                        description: "Veja quem frequentou suas quadras!"),
                  ),
                  SFButton(
                    buttonLabel: "Adicionar Jogador",
                    buttonType: ButtonType.Primary,
                    onTap: () => viewModel.openStorePlayerWidget(context, null),
                    iconFirst: true,
                    iconPath: r"assets/icon/user_plus.svg",
                    textPadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding * 2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Row(
                children: [
                  SFDropdown(
                    labelText: viewModel.filteredGender,
                    items: viewModel.genderFilters,
                    validator: (value) {},
                    onChanged: (genderName) {
                      if (genderName != null) {
                        viewModel.filterGender(context, genderName);
                      }
                    },
                  ),
                  SizedBox(
                    width: defaultPadding,
                  ),
                  SFDropdown(
                    labelText: viewModel.filteredSport,
                    items: viewModel.sportsFilters,
                    validator: (value) {},
                    onChanged: (sportName) {
                      if (sportName != null) {
                        viewModel.filterSport(context, sportName);
                      }
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    width: width * 0.3,
                    child: SFTextField(
                      labelText: "Nome",
                      pourpose: TextFieldPourpose.Standard,
                      controller: viewModel.nameFilterController,
                      onChanged: (p0) => viewModel.filterName(context),
                      validator: (value) {},
                    ),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (layoutContext, layoutConstraints) {
                    return SFTable(
                      height: layoutConstraints.maxHeight,
                      width: layoutConstraints.maxWidth,
                      headers: [
                        SFTableHeader("name", "Nome"),
                        SFTableHeader("phoneNumber", "Celular"),
                        SFTableHeader("gender", "Gênero"),
                        SFTableHeader("sport", "Esporte"),
                        SFTableHeader("rank", "Categoria"),
                        SFTableHeader("in_app", "No App"),
                        SFTableHeader("action", ""),
                      ],
                      source: viewModel.playersDataSource!,
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
