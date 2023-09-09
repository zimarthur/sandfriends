import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';
import 'package:uni_links/uni_links.dart';

import '../../../SharedComponents/View/SFButton.dart';
import '../ViewModel/MatchViewModel.dart';

class ActionSection extends StatefulWidget {
  final MatchViewModel viewModel;
  const ActionSection({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<ActionSection> createState() => _ActionSectionState();
}

class _ActionSectionState extends State<ActionSection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return widget.viewModel.isUserMatchCreator
        ? Column(
            children: [
              widget.viewModel.matchExpired == false
                  ? SizedBox(
                      height: height * 0.05,
                      child: SFButton(
                        buttonLabel: "Convidar Jogadores",
                        iconPath: r"assets/icon/share.svg",
                        onTap: () => widget.viewModel.shareMatch(context),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.01,
                ),
              ),
              widget.viewModel.matchExpired == false
                  ? SizedBox(
                      height: height * 0.05,
                      child: SFButton(
                        buttonLabel: "Cancelar Partida",
                        isPrimary: false,
                        color: red,
                        iconPath: r"assets/icon/delete.svg",
                        onTap: () => widget.viewModel.confirmCancelMatch(
                          context,
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: height * 0.01,
                ),
              ),
            ],
          )
        : widget.viewModel.isUserInMatch ||
                widget.viewModel.match.hasUserSentInvitation(
                    Provider.of<UserProvider>(context, listen: false).user!)
            ? Column(
                children: [
                  widget.viewModel.matchExpired == false
                      ? SizedBox(
                          height: height * 0.05,
                          child: SFButton(
                            buttonLabel: "Sair da Partida",
                            isPrimary: false,
                            onTap: () => widget.viewModel.leaveMatch(
                              context,
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: height * 0.01,
                    ),
                  ),
                ],
              )
            : widget.viewModel.matchExpired == false
                ? Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                        child: SFButton(
                          buttonLabel: "Entrar na Partida",
                          onTap: () => widget.viewModel.joinMatch(
                            context,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: height * 0.01,
                        ),
                      ),
                    ],
                  )
                : Container();
  }
}
