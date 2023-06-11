import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Utils/Heros.dart';
import 'package:sandfriends/Utils/SFDateTime.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../ViewModel/RecurrentMatchesViewModel.dart';
import 'RecurrentMatchCard.dart';

class RecurrentMatchesWidget extends StatefulWidget {
  RecurrentMatchesViewModel viewModel;
  RecurrentMatchesWidget({
    required this.viewModel,
  });

  @override
  State<RecurrentMatchesWidget> createState() => _RecurrentMatchesWidgetState();
}

class _RecurrentMatchesWidgetState extends State<RecurrentMatchesWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).padding.top + height * 0.2,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryLightBlue,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(
                        vertical: height * 0.01,
                        horizontal: width * 0.02,
                      ),
                      child: InkWell(
                        onTap: () => widget.viewModel.onTapReturn(
                          context,
                        ),
                        child: Container(
                          height: width * 0.1,
                          width: width * 0.1,
                          padding: EdgeInsets.all(width * 0.02),
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: SvgPicture.asset(
                            r'assets\icon\arrow_left.svg',
                            color: secondaryBack,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.10,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.03,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Área do",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: height * 0.05,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Mensalista",
                                style: TextStyle(
                                    color: textWhite,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: secondaryBack,
            border: Border(
              bottom: BorderSide(
                color: divider.withOpacity(0.6),
                width: 1,
              ),
            ),
          ),
          height: height * 0.1,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Horários",
                      textScaleFactor: 0.9,
                      style: TextStyle(color: textDarkGrey),
                    ),
                    Text(
                      widget.viewModel.recurrentMatches.isEmpty
                          ? "-"
                          : "${widget.viewModel.recurrentMatches.length}",
                      textScaleFactor: 1.5,
                      style: TextStyle(
                          color: primaryLightBlue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Container(
                color: divider,
                height: height * 0.06,
                width: 1,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vencimento (dias)",
                      textScaleFactor: 0.9,
                      style: TextStyle(color: textDarkGrey),
                    ),
                    Text(
                      widget.viewModel.recurrentMatches.isEmpty
                          ? "-"
                          : "${getDaysToEndOfMonth()}",
                      textScaleFactor: 1.5,
                      style: TextStyle(
                          color: primaryLightBlue, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
            ),
            color: secondaryPaper,
            child: widget.viewModel.recurrentMatches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Você não tem horários mensalistas.",
                          style: TextStyle(color: textDarkGrey),
                        )
                      ],
                    ),
                  )
                : widget.viewModel.selectedRecurrentMatch == null
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.viewModel.recurrentMatches.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                widget.viewModel.selectedRecurrentMatch = index;
                              });
                            },
                            child: RecurrentMatchCard(
                                expanded: false,
                                recurrentMatch:
                                    widget.viewModel.recurrentMatches[index]),
                          );
                        },
                      )
                    : InkWell(
                        onTap: () {
                          setState(() {
                            widget.viewModel.selectedRecurrentMatch = null;
                          });
                        },
                        child: RecurrentMatchCard(
                          expanded: true,
                          recurrentMatch: widget.viewModel.recurrentMatches[
                              widget.viewModel.selectedRecurrentMatch!],
                        ),
                      ),
          ),
        ),
        if (widget.viewModel.selectedRecurrentMatch == null)
          Container(
            color: secondaryPaper,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.04, vertical: height * 0.02),
            child: SFButton(
              buttonLabel: "Buscar Quadras Mensalistas",
              color: primaryLightBlue,
              onTap: () {
                widget.viewModel.goToSportSelection(context);
              },
              textPadding: EdgeInsets.symmetric(vertical: height * 0.01),
            ),
          ),
      ],
    );
  }
}
