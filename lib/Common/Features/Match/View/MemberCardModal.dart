import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Model/MatchMember.dart';
import 'package:sandfriends/Common/StandardScreen/StandardScreenViewModel.dart';

import '../../../Components/SFAvatarUser.dart';
import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/SFButton.dart';

import '../../../Utils/Constants.dart';

import '../ViewModel/MatchViewModel.dart';

class MemberCardModal extends StatefulWidget {
  final MatchViewModel viewModel;
  final MatchMember member;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;
  final VoidCallback onRemove;

  const MemberCardModal({
    Key? key,
    required this.viewModel,
    required this.member,
    required this.onAccept,
    required this.onRefuse,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<MemberCardModal> createState() => _MemberCardModalState();
}

class _MemberCardModalState extends State<MemberCardModal> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double modalWidth = screenWidth * 0.9 > 400 ? 400 : screenWidth * 0.9;
    double modalHeight = screenHeight * 0.6 > 700 ? 700 : screenHeight * 0.6;
    return Container(
      padding: EdgeInsets.all(
        defaultPadding,
      ),
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: const [
          BoxShadow(
            blurRadius: 1,
            color: primaryDarkBlue,
          )
        ],
      ),
      width: modalWidth,
      height: modalHeight,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () =>
                  Provider.of<StandardScreenViewModel>(context, listen: false)
                      .removeLastOverlay(),
              child: SvgPicture.asset(
                r"assets/icon/x.svg",
                color: textDarkGrey,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SFAvatarUser(
                      height: 100,
                      user: widget.member.user,
                      showRank: true,
                      editFile: null,
                      sport: widget.viewModel.match.sport,
                    ),
                    Column(
                      children: [
                        Text(
                          "${widget.member.user.firstName} ${widget.member.user.lastName}",
                          style: const TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          widget.member.user.matchCounter[0].total == 1
                              ? "${widget.member.user.matchCounter[0].total} jogo"
                              : "${widget.member.user.matchCounter[0].total} jogos",
                          style: const TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.member.user.age == null
                              ? "-"
                              : widget.member.user.age! < 18
                                  ? "Sub-18"
                                  : widget.member.user.age! < 40
                                      ? "Sub-40"
                                      : "40+",
                          style: const TextStyle(
                            color: textDarkGrey,
                            fontSize: 12,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              r'assets/icon/location_ping.svg',
                              color: textDarkGrey,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                right: defaultPadding / 2,
                              ),
                            ),
                            Text(
                              widget.member.user.city == null
                                  ? "-"
                                  : "${widget.member.user.city!.name} / ${widget.member.user.city!.state!.uf}",
                              style: const TextStyle(
                                color: textDarkGrey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: modalWidth * 0.15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Gênero:"),
                          Text(
                            widget.member.user.gender == null
                                ? "-"
                                : widget.member.user.gender!.name,
                            style: const TextStyle(
                                color: textBlue, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Rank:"),
                          Text(
                            widget.member.user.ranks[0].name,
                            style: const TextStyle(
                                color: textBlue, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Mão:"),
                          Text(
                            widget.member.user.sidePreference == null
                                ? "-"
                                : widget.member.user.sidePreference!.name,
                            style: const TextStyle(
                                color: textBlue, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: defaultPadding / 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Altura:"),
                          Text(
                            widget.member.user.height == null
                                ? "-"
                                : "${widget.member.user.height!}m",
                            style: const TextStyle(
                                color: textBlue, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                widget.viewModel.isUserMatchCreator &&
                        widget.member.user.id !=
                            Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .id &&
                        widget.viewModel.matchExpired == false
                    ? widget.member.waitingApproval
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: defaultPadding),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SFButton(
                                    buttonLabel: "Recusar",
                                    color: red,
                                    textPadding: EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2,
                                    ),
                                    onTap: () => widget.onRefuse(),
                                  ),
                                ),
                                SizedBox(
                                  width: defaultPadding,
                                ),
                                Expanded(
                                  child: SFButton(
                                    buttonLabel: "Aceitar",
                                    color: green,
                                    textPadding: EdgeInsets.symmetric(
                                      vertical: defaultPadding / 2,
                                    ),
                                    onTap: () => widget.onAccept(),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SFButton(
                            buttonLabel: "Excluir Jogador",
                            textPadding: EdgeInsets.symmetric(
                              vertical: defaultPadding / 2,
                            ),
                            onTap: () => widget.onRemove())
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
