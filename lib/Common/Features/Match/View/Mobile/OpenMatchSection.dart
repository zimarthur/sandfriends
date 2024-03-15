import 'package:flutter/material.dart';

import '../../../../Components/SFButton.dart';

import '../../../../Utils/Constants.dart';
import '../../ViewModel/MatchViewModel.dart';

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
  double buttonsSize = 80.0;
  @override
  Widget build(BuildContext context) {
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
                          Text(
                            "Partida Aberta",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: widget.viewModel.match.isOpenMatch == false
                                  ? textDarkGrey
                                  : textBlue,
                              fontSize: 16,
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
                          textPadding: EdgeInsets.all(defaultPadding / 2),
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
                        vertical: defaultPadding,
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
                              vertical: defaultPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.viewModel.match.reduceMaxUser();
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(defaultPadding * 1.5),
                                    decoration: BoxDecoration(
                                        color: primaryBlue,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: textWhite,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "${widget.viewModel.match.maxUsers}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      widget.viewModel.match.increaseMaxUser();
                                    });
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.all(defaultPadding * 1.5),
                                    decoration: BoxDecoration(
                                        color: primaryBlue,
                                        shape: BoxShape.circle),
                                    child: const Center(
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: textWhite,
                                          fontSize: 16,
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
                padding: EdgeInsets.symmetric(vertical: defaultPadding * 2),
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
