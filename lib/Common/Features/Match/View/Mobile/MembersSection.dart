import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Components/SFAvatarUser.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/MatchViewModel.dart';

class MembersSection extends StatefulWidget {
  final MatchViewModel viewModel;
  double memberHeight;
  MembersSection({
    Key? key,
    required this.viewModel,
    this.memberHeight = 60,
  }) : super(key: key);

  @override
  State<MembersSection> createState() => _MembersSectionState();
}

class _MembersSectionState extends State<MembersSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.viewModel.referenceIsOpenMatch
              ? "Jogadores (${widget.viewModel.match.activeMatchMembers}/${widget.viewModel.referenceMaxUsers})"
              : "Jogadores (${widget.viewModel.match.activeMatchMembers})",
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.viewModel.match.members.length,
            itemBuilder: (context, index) {
              if (widget.viewModel
                  .hideMember(widget.viewModel.match.members[index], context)) {
                return Container();
              } else {
                return InkWell(
                  onTap: () => widget.viewModel.openMemberCardModal(
                      context, widget.viewModel.match.members[index]),
                  child: Container(
                    height: widget.memberHeight, // height * 0.08,
                    margin: EdgeInsets.symmetric(
                      vertical: defaultPadding / 4,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: widget.memberHeight / 2,
                            bottom: widget.memberHeight * 0.15,
                            top: widget.memberHeight * 0.15,
                          ),
                          padding: EdgeInsets.only(
                            left: widget.memberHeight * 0.75,
                          ),
                          alignment: Alignment.centerLeft,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.viewModel.match.members[index]
                                    .waitingApproval
                                ? secondaryYellow
                                : primaryLightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.viewModel.match.members[index].user
                                      .firstName!,
                                  style: const TextStyle(
                                    color: textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              widget.viewModel.match.members[index]
                                              .waitingApproval ==
                                          true &&
                                      widget.viewModel.isUserMatchCreator ==
                                          false
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 4,
                                      ),
                                      padding: EdgeInsets.all(
                                        defaultPadding / 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: secondaryPaper,
                                        borderRadius: BorderRadius.circular(
                                            defaultBorderRadius),
                                      ),
                                      child: const Text(
                                        "Solic. Enviada",
                                        style: TextStyle(
                                          color: secondaryYellow,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              widget.viewModel.match.members[index]
                                          .waitingApproval &&
                                      widget.viewModel.isUserMatchCreator &&
                                      widget.viewModel.matchExpired == false
                                  ? Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: defaultPadding / 4,
                                      ),
                                      padding: EdgeInsets.all(
                                        defaultPadding / 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: secondaryPaper,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Text(
                                        "ver solicitação",
                                        style: TextStyle(
                                          color: secondaryYellow,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: SFAvatarUser(
                            height: widget.memberHeight,
                            showRank: true,
                            editFile: null,
                            user: widget.viewModel.match.members[index].user,
                            sport: widget.viewModel.match.sport,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
