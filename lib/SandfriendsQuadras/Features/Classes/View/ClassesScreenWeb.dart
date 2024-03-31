import 'package:flutter/material.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFDropDown.dart';
import '../../../../../Common/Components/SFHeader.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Components/Table/SFTable.dart';
import '../../../../../Common/Components/Table/SFTableHeader.dart';
import '../../../../../Common/Utils/Constants.dart';
import 'package:provider/provider.dart';

import '../../../../Common/Components/SFTabs.dart';
import '../../Menu/ViewModel/MenuProviderQuadras.dart';
import '../ViewModel/ClassesViewModel.dart';

class ClassesScreenWeb extends StatefulWidget {
  const ClassesScreenWeb({super.key});

  @override
  State<ClassesScreenWeb> createState() => _ClassesScreenWebState();
}

class _ClassesScreenWebState extends State<ClassesScreenWeb> {
  final ClassesViewModel viewModel = ClassesViewModel();

  @override
  void initState() {
    viewModel.initViewModel(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width =
        Provider.of<MenuProviderQuadras>(context).getScreenWidth(context);
    double height =
        Provider.of<MenuProviderQuadras>(context).getScreenHeight(context);
    return ChangeNotifierProvider<ClassesViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<ClassesViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: SFHeader(
                        header: "Aulas",
                        description:
                            "Configure suas aulas, professoes e escolas"),
                  ),
                  SFButton(
                    buttonLabel: "Adicionar Escola",
                    onTap: () => viewModel.openAddOrEditSchooolModal(context),
                    iconFirst: true,
                    iconPath: r"assets/icon/plus.svg",
                    textPadding: const EdgeInsets.symmetric(
                      vertical: defaultPadding,
                      horizontal: defaultPadding * 2,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              SFTabs(
                tabs: viewModel.tabItems,
                selectedPosition: viewModel.selectedTab,
              ),
              const SizedBox(
                height: defaultPadding / 2,
              ),
              Expanded(
                child: viewModel.selectedTab.displayWidget,
              ),
            ],
          );
        },
      ),
    );
  }
}
