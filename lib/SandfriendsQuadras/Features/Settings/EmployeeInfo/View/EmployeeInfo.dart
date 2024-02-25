import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/Table/SFTable.dart';
import '../../../../../Common/Components/Table/SFTableHeader.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../../Menu/ViewModel/DataProvider.dart';
import '../../ViewModel/SettingsViewModel.dart';
import '../ViewModel/EmployeeInfoViewModel.dart';

class EmployeeInfo extends StatefulWidget {
  @override
  State<EmployeeInfo> createState() => _EmployeeInfoState();
}

class _EmployeeInfoState extends State<EmployeeInfo> {
  final viewModel = EmployeeInfoViewModel();

  @override
  void initState() {
    viewModel.initEmployeeScreen(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EmployeeInfoViewModel>(
      create: (BuildContext context) => viewModel,
      child: Consumer<EmployeeInfoViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              if (Provider.of<DataProvider>(context, listen: false)
                  .loggedEmployee
                  .isCourtOwner)
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Adicione membros à sua equipe e edite seus níveis de permissão.",
                          ),
                          Text(
                            "Obs: um funcionário com acesso de administrador pode ver e alterar os dados bancários da empresa e também visualizar o faturamento do estabelecimento.",
                            style: TextStyle(
                              color: textDarkGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: defaultPadding,
                    ),
                    SFButton(
                      buttonLabel: "Adic. funcionário",
                      onTap: () {
                        viewModel.goToAddEmployee(
                          context,
                          viewModel,
                        );
                      },
                      iconFirst: true,
                      iconPath: r"assets/icon/plus.svg",
                      iconSize: 14,
                      textPadding: const EdgeInsets.symmetric(
                        vertical: defaultPadding / 2,
                        horizontal: defaultPadding,
                      ),
                    )
                  ],
                ),
              const SizedBox(
                height: 2 * defaultPadding,
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (layoutContext, layoutConstraints) {
                    return SFTable(
                      height: layoutConstraints.maxHeight,
                      width: layoutConstraints.maxWidth,
                      headers: [
                        SFTableHeader("name", "Nome"),
                        SFTableHeader("email", "E-mail"),
                        SFTableHeader("date", "Membro desde"),
                        SFTableHeader("admin", "Acesso"),
                        SFTableHeader("action", ""),
                      ],
                      source: viewModel.employeesDataSource!,
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
