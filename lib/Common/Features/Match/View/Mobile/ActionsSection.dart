import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Providers/Environment/EnvironmentProvider.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../../../Components/SFButton.dart';

import '../../ViewModel/MatchViewModel.dart';

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
    return widget.viewModel.isUserMatchCreator
        ? Column(
            children: [
              widget.viewModel.matchExpired == false
                  ? !kIsWeb
                      ? SFButton(
                          buttonLabel:
                              "Convidar ${widget.viewModel.isClass ? 'Alunos' : 'Jogadores'}",
                          iconPath: r"assets/icon/share.svg",
                          onTap: () => widget.viewModel.shareMatch(context),
                        )
                      : SFButton(
                          buttonLabel:
                              "Copiar link da ${widget.viewModel.isClass ? 'aula' : 'partida'}",
                          iconPath: r"assets/icon/copy_to_clipboard.svg",
                          onTap: () =>
                              widget.viewModel.copyMatchUrlClipboard(context),
                        )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: defaultPadding,
                ),
              ),
              widget.viewModel.matchExpired == false
                  ? SFButton(
                      buttonLabel:
                          "Cancelar ${widget.viewModel.isClass ? 'aula' : 'partida'}",
                      isPrimary: false,
                      color: red,
                      iconPath: r"assets/icon/delete.svg",
                      onTap: () => widget.viewModel.confirmCancelMatch(
                        context,
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: defaultPadding,
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
                      ? SFButton(
                          buttonLabel:
                              "Sair da ${widget.viewModel.isClass ? 'aula' : 'partida'}",
                          isPrimary: false,
                          onTap: () => widget.viewModel.leaveMatch(
                            context,
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: defaultPadding,
                    ),
                  ),
                ],
              )
            : widget.viewModel.matchExpired == false
                ? Column(
                    children: [
                      widget.viewModel.isClass
                          ? SFButton(
                              buttonLabel: "Confirmar presença",
                              onTap: () => widget.viewModel.joinClass(
                                context,
                              ),
                              iconPath: r"assets/icon/check_circle_outline.svg",
                            )
                          : SFButton(
                              buttonLabel: "Entrar na Partida",
                              onTap: () => widget.viewModel.joinMatch(
                                context,
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: defaultPadding,
                        ),
                      ),
                    ],
                  )
                : Container();
  }
}
