import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';

import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SFAvatar.dart';
import '../../../oldApp/widgets/SF_Button.dart';

class OpenMatchCard extends StatefulWidget {
  AppMatch match;
  Function(String) onTap;
  OpenMatchCard({
    required this.match,
    required this.onTap,
  });

  @override
  State<OpenMatchCard> createState() => _OpenMatchCardState();
}

class _OpenMatchCardState extends State<OpenMatchCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.02,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      width: width * 0.6,
      decoration: BoxDecoration(
        color: secondaryPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: divider,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            decoration: BoxDecoration(
              color: Color(int.parse(
                  "0xFF${widget.match.matchRank.color.replaceAll("#", "")}")),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(right: width * 0.02),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: width * 0.2,
                          child: SFAvatar(
                            height: 60,
                            showRank: true,
                            user: widget.match.matchCreator,
                            editFile: null,
                            sport: widget.match.sport,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                "Partida de\n${widget.match.matchCreator.firstName}",
                                style: TextStyle(
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: width * 0.2,
                        ),
                        Expanded(
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: Color(int.parse(
                                  "0xFF${widget.match.matchRank.color.replaceAll("#", "")}")),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  r'assets\icon\users.svg',
                                  color: textWhite,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: width * 0.02),
                                ),
                                Expanded(
                                  child: FittedBox(
                                    child: Text(
                                      widget.match.remainingSlots == 1
                                          ? "resta 1 vaga"
                                          : "restam ${widget.match.remainingSlots} vagas",
                                      style: TextStyle(
                                        color: textWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      r'assets\icon\star.svg',
                      color: primaryBlue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.01),
                    ),
                    Text(
                      widget.match.matchCreator.ranks.first.name,
                      style: TextStyle(
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\calendar.svg',
                          color: primaryBlue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy").format(widget.match.date),
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\clock.svg',
                          color: primaryBlue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
                        ),
                        Text(
                          widget.match.timeBegin,
                          style: TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      r'assets\icon\court.svg',
                      color: primaryBlue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.01),
                    ),
                    Text(
                      widget.match.court.store!.name,
                      style: TextStyle(
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                SFButton(
                  buttonLabel: "Quero jogar",
                  buttonType: ButtonType.Secondary,
                  iconPath: r'assets\icon\user_plus.svg',
                  onTap: () => widget.onTap(widget.match.matchUrl),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
