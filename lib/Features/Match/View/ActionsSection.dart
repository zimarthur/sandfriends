import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../ViewModel/MatchViewModel.dart';

class ActionSection extends StatefulWidget {
  MatchViewModel viewModel;
  ActionSection({
    required this.viewModel,
  });

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
                        buttonType: ButtonType.Primary,
                        iconPath: r"assets\icon\share.svg",
                        onTap: () async {
                          await Share.share(
                              'Entre na minha partida!\n https://www.sandfriends.com.br/redirect/?ct=mtch&bd=${widget.viewModel.match.matchUrl}');
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
                        buttonType: ButtonType.Secondary,
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
              widget.viewModel.matchExpired == false
                  ? Container(
                      margin: EdgeInsets.symmetric(vertical: height * 0.01),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "*Cancelamento Gratuito até o dia ${widget.viewModel.match.canCancelUpTo}",
                        textScaleFactor: 0.9,
                        style: TextStyle(
                          color: textDarkGrey,
                        ),
                      ),
                    )
                  : Container(),
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
                            buttonType: ButtonType.Secondary,
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
                          buttonType: ButtonType.Primary,
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
