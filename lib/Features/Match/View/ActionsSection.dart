import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class ActionSection extends StatefulWidget {
  MatchViewModel viewModel;
  ActionSection({
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
    double width = MediaQuery.of(context).size.width;
    return widget.viewModel.isUserMatchCreator
        ? Column(
            children: [
              widget.viewModel.matchExpired == false
                  ? SizedBox(
                      height: height * 0.05,
                      child: SFButton(
                        buttonLabel: "Convidar Jogadores",
                        iconPath: r"assets\icon\share.svg",
                        onTap: () async {
                          await Share.share(
                              'Entre na minha partida!\n https://sandfriends.com.br/redirect/?ct=mtch&bd=${widget.viewModel.match.matchUrl}');
                        },
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
                        onTap: () => widget.viewModel.cancelMatch(
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
        : widget.viewModel.isUserInMatch
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
