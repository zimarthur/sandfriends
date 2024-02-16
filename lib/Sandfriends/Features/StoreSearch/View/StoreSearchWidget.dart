import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/SFSearchFilter.dart';
import 'package:sandfriends/Sandfriends/Features/MatchSearch/View/SearchOnboarding.dart';
import 'package:sandfriends/Sandfriends/Features/StoreSearch/ViewModel/StoreSearchViewModel.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';

import '../../../../Common/Model/Store.dart';
import '../../../../Common/Components/SFButton.dart';

import 'StoreSearchItem.dart';

class StoreSearchWidget extends StatefulWidget {
  StoreSearchViewModel viewModel;
  StoreSearchWidget({required this.viewModel, super.key});

  @override
  State<StoreSearchWidget> createState() => _StoreSearchWidgetState();
}

class _StoreSearchWidgetState extends State<StoreSearchWidget> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor =
        widget.viewModel.isRecurrent ? primaryLightBlue : primaryBlue;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
          ),
          color: primaryColor,
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
                  color: primaryColor,
                  iconPath: r"assets/icon/search.svg",
                  onTap: () => widget.viewModel.searchStores(context),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            color: secondaryBack,
            child: !widget.viewModel.hasUserSearched
                ? SearchOnboarding(
                    isSearchingStores: true,
                    primaryColor: primaryColor,
                    isRecurrent: widget.viewModel.isRecurrent,
                  )
                : ListView.builder(
                    itemCount: widget.viewModel.stores.length,
                    itemBuilder: (context, index) {
                      Store store = widget.viewModel.stores[index];
                      return InkWell(
                        onTap: () =>
                            widget.viewModel.onTapStore(context, store),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? defaultPadding : 0,
                          ),
                          child: StoreSearchItem(store: store),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
