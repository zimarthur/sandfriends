import 'package:flutter/material.dart';
import 'package:sandfriends_web/Features/Finances/ViewModel/FinancesViewModel.dart';
import 'package:sandfriends_web/Features/Settings/BrandInfo/View/BrandInfo.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/View/EmployeeInfo.dart';
import 'package:sandfriends_web/Features/Settings/EmployeeInfo/ViewModel/EmployeeInfoViewModel.dart';
import 'package:sandfriends_web/Utils/Constants.dart';
import 'package:provider/provider.dart';
import '../../../../Common/Components/SFButton.dart';

import '../../../../SharedComponents/View/SFHeader.dart';
import '../../../../SharedComponents/View/SFTabs.dart';
import '../../../Menu/ViewModel/MenuProvider.dart';
import '../../ViewModel/SettingsViewModel.dart';
import '../../BasicInfo/View/BasicInfo.dart';
import '../../ViewModel/SettingsViewModel.dart';

class SettingsScreenWeb extends StatefulWidget {
  String? initForm;
  SettingsScreenWeb({
    super.key,
    this.initForm,
  });

  @override
  State<SettingsScreenWeb> createState() => _SettingsScreenWebState();
}

class _SettingsScreenWebState extends State<SettingsScreenWeb> {
  final viewModel = SettingsViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.initSettingsViewModel(context);
    if (widget.initForm != null) {
      setState(() {
        viewModel.setSelectedTabFromString(widget.initForm!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingsViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<SettingsViewModel>(
        builder: (context, viewModel, _) {
          return Container(
            color: secondaryBack,
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SFHeader(
                        header: "Meu perfil",
                        description:
                            "Gerencie as informações e a identidade visual do seu negócio, bem como seus dados financeiros",
                      ),
                    ),
                    viewModel.infoChanged
                        ? SFButton(
                            buttonLabel: "Salvar",
                            buttonType: ButtonType.Primary,
                            onTap: () => viewModel.updateUser(context),
                            textPadding: const EdgeInsets.symmetric(
                              vertical: defaultPadding,
                              horizontal: defaultPadding * 2,
                            ),
                          )
                        : Container()
                  ],
                ),
                SFTabs(
                  tabs: viewModel.tabItems,
                  selectedPosition: viewModel.selectedTab,
                ),
                const SizedBox(
                  height: defaultPadding,
                ),
                Expanded(
                  child: viewModel.selectedTab.displayWidget,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
