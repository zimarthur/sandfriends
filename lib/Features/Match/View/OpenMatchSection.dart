import 'package:flutter/material.dart';

import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class OpenMatchSection extends StatefulWidget {
  final MatchViewModel viewModel;
  const OpenMatchSection({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<OpenMatchSection> createState() => _OpenMatchSectionState();
}

class _OpenMatchSectionState extends State<OpenMatchSection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return widget.viewModel.isUserMatchCreator &&
            widget.viewModel.matchExpired == false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          widget.viewModel.match.isOpenMatch =
                              !widget.viewModel.match.isOpenMatch;
                          if (widget.viewModel.match.isOpenMatch ==
                              widget.viewModel.referenceIsOpenMatch) {
                            widget.viewModel.match.maxUsers =
                                widget.viewModel.referenceMaxUsers;
                          }
                        });
                      },
                      child: Row(
                        children: [
                          Checkbox(
                              activeColor: textBlue,
                              value: widget.viewModel.match.isOpenMatch,
                              onChanged: (value) {
                                setState(() {
                                  widget.viewModel.match.isOpenMatch = value!;
                                  if (widget.viewModel.match.isOpenMatch ==
                                      widget.viewModel.referenceIsOpenMatch) {
                                    widget.viewModel.match.maxUsers =
                                        widget.viewModel.referenceMaxUsers;
                                  }
                                });
                              }),
                          SizedBox(
                            height: height * 0.03,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                "Partida Aberta",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: widget.viewModel.match.isOpenMatch ==
                                          false
                                      ? textDarkGrey
                                      : textBlue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.viewModel.referenceIsOpenMatch !=
                              widget.viewModel.match.isOpenMatch ||
                          widget.viewModel.referenceMaxUsers !=
                              widget.viewModel.match.maxUsers
                      ? SFButton(
                          textPadding: EdgeInsets.all(width * 0.02),
                          buttonLabel: "Salvar",
                          onTap: () =>
                              widget.viewModel.saveOpenMatchChanges(context),
                        )
                      : Container(),
                ],
              ),
              widget.viewModel.match.isOpenMatch == false
                  ? const Text(
                      "Torne a partida aberta para permitir que novos jogadores solicitem para jogar com você!",
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                      textScaleFactor: 0.85,
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        vertical: height * 0.01,
                      ),
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Quantos jogadores sua partida deve ter?",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.2,
                              vertical: height * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.viewModel.match.reduceMaxUser();
                                    });
                                  },
                                  child: Container(
                                    height: height * 0.06,
                                    width: height * 0.06,
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      borderRadius:
                                          BorderRadius.circular(height * 0.03),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: textWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "${widget.viewModel.match.maxUsers}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.viewModel.match.increaseMaxUser();
                                    });
                                  },
                                  child: Container(
                                    height: height * 0.06,
                                    width: height * 0.06,
                                    decoration: BoxDecoration(
                                      color: primaryBlue,
                                      borderRadius:
                                          BorderRadius.circular(height * 0.03),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: textWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: height * 0.03),
                child: Container(
                  height: 1,
                  color: textLightGrey,
                ),
              ),
            ],
          )
        : Container();
  }
}
