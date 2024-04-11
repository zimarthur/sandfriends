import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sandfriends/Common/Model/AppMatch/AppMatchUser.dart';
import 'package:sandfriends/Common/Model/MatchMember.dart';

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
    AppMatchUser match = widget.viewModel.match;
    List<MatchMember> matchMembers = widget.viewModel.isClass
        ? match.classMembers
        : widget.viewModel.isUserMatchCreator
            ? match.members
            : match.activeMatchMembers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "${widget.viewModel.isClass ? 'Alunos confirmados' : 'Jogadores'} (${matchMembers.length}${match.isOpenMatch ? '/${widget.viewModel.referenceMaxUsers}' : ''})",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            if (widget.viewModel.isUserTeacher)
              GestureDetector(
                onTap: () => widget.viewModel.openClassMembersEdit(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding / 2,
                  ),
                  child: SvgPicture.asset(
                    r"assets/icon/edit.svg",
                    color: primaryBlue,
                  ),
                ),
              )
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding / 2),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: matchMembers.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => widget.viewModel
                      .openMemberCardModal(context, matchMembers[index]),
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
                            color: matchMembers[index].waitingApproval
                                ? secondaryYellow
                                : primaryLightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  matchMembers[index].user.firstName!,
                                  style: const TextStyle(
                                    color: textWhite,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              matchMembers[index].waitingApproval == true &&
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
                              matchMembers[index].waitingApproval &&
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
                            user: matchMembers[index].user,
                            sport: widget.viewModel.match.sport,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
