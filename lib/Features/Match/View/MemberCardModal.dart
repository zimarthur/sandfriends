import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/MatchMember.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SFAvatar.dart';
import '../../../oldApp/widgets/SF_Button.dart';
import '../ViewModel/MatchViewModel.dart';

class MemberCardModal extends StatefulWidget {
  MatchViewModel viewModel;
  MatchMember member;

  MemberCardModal({
    required this.viewModel,
    required this.member,
  });

  @override
  State<MemberCardModal> createState() => _MemberCardModalState();
}

class _MemberCardModalState extends State<MemberCardModal> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryDarkBlue, width: 1),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: primaryDarkBlue,
          )
        ],
      ),
      width: width * 0.9,
      height: height * 0.6,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: height * 0.28,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SFAvatar(
                  height: height * 0.15,
                  user: widget.member.user,
                  showRank: true,
                  editFile: null,
                  sport: widget.viewModel.match.sport,
                ),
                SizedBox(
                  height: height * 0.12,
                  child: Column(
                    children: [
                      SizedBox(
                        height: height * 0.04,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "${widget.member.user.firstName} ${widget.member.user.lastName}",
                            style: TextStyle(
                              color: textBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            widget.member.user.matchCounter[0].total == 1
                                ? "${widget.member.user.matchCounter[0].total} jogo"
                                : "${widget.member.user.matchCounter[0].total} jogos",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.025,
                        width: width,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            widget.member.user.age == null
                                ? ""
                                : widget.member.user.age! < 18
                                    ? "Sub-18"
                                    : widget.member.user.age! < 40
                                        ? "Sub-40"
                                        : "40+",
                            style: TextStyle(
                              color: textDarkGrey,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            r'assets\icon\location_ping.svg',
                            color: textDarkGrey,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              right: width * 0.01,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.025,
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                widget.member.user.city == null
                                    ? "-"
                                    : "${widget.member.user.city!.city} / ${widget.member.user.city!.state!.uf}",
                                style: TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.2,
            width: width * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Gênero:"),
                    Text(
                      widget.member.user.gender == null
                          ? "-"
                          : widget.member.user.gender!.name,
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Rank:"),
                    Text(
                      widget.member.user.ranks[0].name,
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Mão:"),
                    Text(
                      widget.member.user.sidePreference == null
                          ? "-"
                          : widget.member.user.sidePreference!.name,
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Altura:"),
                    Text(
                      widget.member.user.height == null
                          ? "-"
                          : "${widget.member.user.height!}m",
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          widget.viewModel.isUserMatchCreator &&
                  widget.member.user.idUser !=
                      Provider.of<UserProvider>(context, listen: false)
                          .user!
                          .idUser &&
                  widget.viewModel.matchExpired == false
              ? SizedBox(
                  width: width * 0.5,
                  child: SFButton(
                    buttonLabel: "Excluir Jogador",
                    textPadding: EdgeInsets.symmetric(vertical: height * 0.01),
                    onTap: () => widget.viewModel.removeMatchMember(
                      context,
                      widget.member.user.idUser!,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
