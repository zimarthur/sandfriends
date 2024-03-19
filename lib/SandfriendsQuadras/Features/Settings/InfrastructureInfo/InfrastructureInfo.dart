import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Components/SFAvatarStore.dart';
import 'package:sandfriends/Common/Model/Infrastructure.dart';
import 'package:sandfriends/Common/Providers/Categories/CategoriesProvider.dart';
import 'package:sandfriends/SandfriendsQuadras/Features/Settings/InfrastructureInfo/InfrastructureItem.dart';
import '../../../../../Common/Components/SFButton.dart';
import '../../../../../Common/Components/SFDivider.dart';
import '../../../../../../Common/Components/SFTextField.dart';
import '../../../../../Common/Utils/Constants.dart';
import 'package:provider/provider.dart';

import '../ViewModel/SettingsViewModel.dart';

class InfrastructureInfo extends StatefulWidget {
  SettingsViewModel viewModel;

  InfrastructureInfo({super.key, required this.viewModel});

  @override
  State<InfrastructureInfo> createState() => _InfrastructureInfoState();
}

class _InfrastructureInfoState extends State<InfrastructureInfo> {
  final photosScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SettingsViewModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Selecione as facilidades e serviços que sua quadra oferece",
          style: TextStyle(),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Expanded(
          child: LayoutBuilder(builder: (layoutContext, layoutConstraints) {
            double minExpedtecWidth = 300;
            int columns =
                (layoutConstraints.maxWidth / minExpedtecWidth).floor();
            //double itemWidth = layoutConstraints.maxWidth < minExpedtecWidth ? layoutConstraints.maxWidth :
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    columns, // You can adjust the number of columns here
                crossAxisSpacing: defaultPadding,
                mainAxisSpacing: defaultPadding,
                mainAxisExtent: 70,
              ),
              itemCount: viewModel.storeEdit.infrastructures.length,
              itemBuilder: (BuildContext context, int index) {
                return InfrastructureItem(
                  infrastructure: viewModel.storeEdit.infrastructures[index],
                  onTap: (isSelected) {
                    viewModel.onTapInfrastructure(
                        viewModel.storeEdit.infrastructures[index].id,
                        isSelected);
                  },
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
