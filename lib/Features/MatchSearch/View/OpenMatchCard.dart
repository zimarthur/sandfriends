import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/SharedComponents/Model/AppMatch.dart';

import '../../../SharedComponents/View/SFAvatar.dart';
import '../../../SharedComponents/View/SFButton.dart';
import '../../../Utils/Constants.dart';

class OpenMatchCard extends StatefulWidget {
  final bool isReduced;
  final AppMatch match;
  final Function(String) onTap;
  const OpenMatchCard({
    Key? key,
    required this.isReduced,
    required this.match,
    required this.onTap,
  }) : super(key: key);

  @override
  State<OpenMatchCard> createState() => _OpenMatchCardState();
}

class _OpenMatchCardState extends State<OpenMatchCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.02,
      ),
      padding: EdgeInsets.all(
        width * 0.03,
      ),
      width: widget.isReduced ? width * 0.6 : width * 0.9,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 60,
                          child: SFAvatar(
                            height: 60,
                            showRank: true,
                            user: widget.match.matchCreator,
                            editFile: null,
                            sport: widget.match.sport,
                          ),
                        ),
                        const SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.isReduced
                                      ? "Partida de\n${widget.match.matchCreator.firstName}"
                                      : "Partida de ${widget.match.matchCreator.firstName}",
                                  style: const TextStyle(
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: defaultPadding / 2,
                              ),
                              Container(
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      r'assets/icon/users.svg',
                                      color: textWhite,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.02),
                                    ),
                                    widget.isReduced
                                        ? Expanded(
                                            child: FittedBox(
                                              child: Text(
                                                widget.match.remainingSlots == 1
                                                    ? "resta 1 vaga"
                                                    : "restam ${widget.match.remainingSlots} vagas",
                                                style: const TextStyle(
                                                  color: textWhite,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                maxLines: 1,
                                              ),
                                              fit: BoxFit.fitWidth,
                                            ),
                                          )
                                        : Text(
                                            widget.match.remainingSlots == 1
                                                ? "resta 1 vaga"
                                                : "restam ${widget.match.remainingSlots} vagas",
                                            style: const TextStyle(
                                              color: textWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                            maxLines: 1,
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      r'assets/icon/star.svg',
                      color: primaryBlue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.01),
                    ),
                    Text(
                      "${widget.match.matchCreator.ranks.first.name} - ${widget.match.sport.description}",
                      style: TextStyle(
                        color: Color(int.parse(
                            "0xFF${widget.match.matchRank.color.replaceAll("#", "")}")),
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
                          r'assets/icon/calendar.svg',
                          color: primaryBlue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
                        ),
                        Text(
                          DateFormat("dd/MM/yyyy").format(widget.match.date),
                          style: const TextStyle(
                            color: primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          r'assets/icon/clock.svg',
                          color: primaryBlue,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: width * 0.01),
                        ),
                        Text(
                          widget.isReduced
                              ? widget.match.timeBegin.hourString
                              : "${widget.match.timeBegin.hourString} - ${widget.match.timeEnd.hourString}",
                          style: const TextStyle(
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
                      r'assets/icon/court.svg',
                      color: primaryBlue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: width * 0.01),
                    ),
                    Text(
                      widget.isReduced
                          ? widget.match.court.store!.name
                          : "${widget.match.court.store!.name} - ${widget.match.court.storeCourtName}",
                      style: const TextStyle(
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                SFButton(
                  buttonLabel: "Ver partida",
                  isPrimary: false,
                  textPadding:
                      const EdgeInsets.symmetric(vertical: defaultPadding / 4),
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
