import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/Common/Utils/SFDateTime.dart';

import '../../../../Common/Components/SFButton.dart';

import '../../../../Common/StandardScreen/StandardScreenViewModel.dart';
import '../../../../Common/Utils/Constants.dart';
import '../ViewModel/RecurrentMatchesViewModel.dart';
import 'RecurrentMatchCard.dart';

class RecurrentMatchesWidget extends StatefulWidget {
  final RecurrentMatchesViewModel viewModel;
  const RecurrentMatchesWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
          decoration: const BoxDecoration(
            color: primaryLightBlue,
            borderRadius: BorderRadius.only(
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
                    Row(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            horizontal: width * 0.02,
                          ),
                          child: InkWell(
                            onTap: () => Provider.of<StandardScreenViewModel>(
                                    context,
                                    listen: false)
                                .onTapReturn(
                              context,
                            ),
                            child: Container(
                              height: width * 0.1,
                              width: width * 0.1,
                              padding: EdgeInsets.all(width * 0.02),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                r'assets/icon/arrow_left.svg',
                                color: secondaryBack,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            horizontal: width * 0.02,
                          ),
                          child: InkWell(
                            onTap: () =>
                                widget.viewModel.showScreenInformationModal(
                              context,
                            ),
                            child: Container(
                              height: width * 0.1,
                              width: width * 0.1,
                              padding: EdgeInsets.all(width * 0.02),
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: SvgPicture.asset(
                                r'assets/icon/help.svg',
                                color: secondaryBack,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: height * 0.10,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: height * 0.03,
                            child: const FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Área do",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                            child: const FittedBox(
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
                    const Text(
                      "Horários",
                      textScaleFactor: 0.9,
                      style: TextStyle(color: textDarkGrey),
                    ),
                    Text(
                      Provider.of<UserProvider>(context)
                              .recurrentMatches
                              .isEmpty
                          ? "-"
                          : "${Provider.of<UserProvider>(context).recurrentMatches.length}",
                      textScaleFactor: 1.5,
                      style: const TextStyle(
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
                    const Text(
                      "Vencimento (dias)",
                      textScaleFactor: 0.9,
                      style: TextStyle(color: textDarkGrey),
                    ),
                    Text(
                      Provider.of<UserProvider>(context)
                              .recurrentMatches
                              .isEmpty
                          ? "-"
                          : "${getDaysToEndOfMonth()}",
                      textScaleFactor: 1.5,
                      style: const TextStyle(
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
            child: Provider.of<UserProvider>(context).recurrentMatches.isEmpty
                ? const Center(
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
                        itemCount: Provider.of<UserProvider>(context)
                            .recurrentMatches
                            .length,
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
                                    Provider.of<UserProvider>(context)
                                        .recurrentMatches[index]),
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
                          recurrentMatch: Provider.of<UserProvider>(context)
                                  .recurrentMatches[
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
                widget.viewModel.goToSearchType(context);
              },
              textPadding: EdgeInsets.symmetric(vertical: height * 0.01),
            ),
          ),
      ],
    );
  }
}
