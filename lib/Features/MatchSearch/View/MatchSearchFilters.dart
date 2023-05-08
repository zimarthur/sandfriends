import 'package:flutter/material.dart';
import 'package:sandfriends/Features/MatchSearch/ViewModel/MatchSearchViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../oldApp/widgets/SF_Button.dart';
import 'SFSearchFilter.dart';

class MatchSearchFilters extends StatefulWidget {
  MatchSearchViewModel viewModel;
  MatchSearchFilters({
    required this.viewModel,
  });

  @override
  State<MatchSearchFilters> createState() => _MatchSearchFiltersState();
}

class _MatchSearchFiltersState extends State<MatchSearchFilters> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      color: primaryBlue,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        children: [
          SFSearchFilter(
            labelText: widget.viewModel.cityFilter == null
                ? "Cidade"
                : "${widget.viewModel.cityFilter!.city} - ${widget.viewModel.cityFilter!.state!.uf}",
            iconPath: r"assets\icon\location_ping.svg",
            onTap: () {
              setState(
                () => widget.viewModel.openCitySelectorModal(
                  context,
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: SFSearchFilter(
                  labelText: widget.viewModel.datesFilter.isEmpty
                      ? "Data"
                      : widget.viewModel.datesFilter.length == 1
                          ? "${widget.viewModel.datesFilter[0]!.day.toString().padLeft(2, '0')}/${widget.viewModel.datesFilter[0]!.month.toString().padLeft(2, '0')}"
                          : "${widget.viewModel.datesFilter[0]!.day.toString().padLeft(2, '0')}/${widget.viewModel.datesFilter[0]!.month.toString().padLeft(2, '0')} - ${widget.viewModel.datesFilter[1]!.day.toString().padLeft(2, '0')}/${widget.viewModel.datesFilter[1]!.month.toString().padLeft(2, '0')}",
                  iconPath: r"assets\icon\calendar.svg",
                  onTap: () => widget.viewModel.openDateSelectorModal(
                    context,
                  ),
                ),
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: SFSearchFilter(
                  labelText: widget.viewModel.timeFilter == null
                      ? "Horário"
                      : "${widget.viewModel.timeFilter!.start.hour.toString().padLeft(2, '0')}:${widget.viewModel.timeFilter!.start.minute.toString().padLeft(2, '0')} - ${widget.viewModel.timeFilter!.end.hour.toString().padLeft(2, '0')}:${widget.viewModel.timeFilter!.end.minute.toString().padLeft(2, '0')}",
                  iconPath: r"assets\icon\clock.svg",
                  onTap: () {},
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: SFButton(
                buttonLabel: "Buscar",
                textPadding: EdgeInsets.symmetric(vertical: 5),
                buttonType: ButtonType.Secondary,
                iconPath: r"assets\icon\search.svg",
                onTap: () {}),
          ),
        ],
      ),
    );
  }
}
