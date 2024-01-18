import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Features/MatchSearch/View/SFSearchFilter.dart';
import 'package:sandfriends/Features/StoreSearch/ViewModel/StoreSearchViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/View/SFButton.dart';

class StoreSearchWidget extends StatefulWidget {
  StoreSearchViewModel viewModel;
  StoreSearchWidget({required this.viewModel, super.key});

  @override
  State<StoreSearchWidget> createState() => _StoreSearchWidgetState();
}

class _StoreSearchWidgetState extends State<StoreSearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          color: primaryBlue,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SFSearchFilter(
                      labelText: widget.viewModel.selectedCity == null
                          ? "Cidade"
                          : "${widget.viewModel.selectedCity!.city} - ${widget.viewModel.selectedCity!.state!.uf}",
                      iconPath: r"assets/icon/location_ping.svg",
                      onTap: () =>
                          widget.viewModel.openCitySelectorModal(context),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SFButton(
                  buttonLabel: "Buscar quadras",
                  textPadding: const EdgeInsets.symmetric(vertical: 5),
                  isPrimary: false,
                  color: primaryBlue,
                  iconPath: r"assets/icon/search.svg",
                  onTap: () => widget.viewModel.searchStores(context),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: secondaryBack,
          ),
        ),
      ],
    );
  }
}
