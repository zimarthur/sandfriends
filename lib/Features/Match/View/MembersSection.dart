import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/SFAvatar.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/MatchViewModel.dart';

class MembersSection extends StatefulWidget {
  MatchViewModel viewModel;
  MembersSection({
    required this.viewModel,
  });

  @override
  State<MembersSection> createState() => _MembersSectionState();
}

class _MembersSectionState extends State<MembersSection> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: height * 0.03,
          child: FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              widget.viewModel.referenceIsOpenMatch
                  ? "Jogadores (${widget.viewModel.match.activeMatchMembers}/${widget.viewModel.referenceMaxUsers})"
                  : "Jogadores (${widget.viewModel.match.activeMatchMembers})",
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.02),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.viewModel.match.members.length,
            itemBuilder: (context, index) {
              if (widget.viewModel
                  .hideMember(widget.viewModel.match.members[index], context)) {
                return Container();
              } else {
                return InkWell(
                  onTap: () => widget.viewModel.openMemberCardModal(
                      widget.viewModel.match.members[index]),
                  child: Container(
                    height: height * 0.08,
                    margin: EdgeInsets.symmetric(vertical: height * 0.005),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: height * 0.04,
                            bottom: height * 0.015,
                            top: height * 0.015,
                          ),
                          padding: EdgeInsets.only(left: height * 0.06),
                          alignment: Alignment.centerLeft,
                          height: height * 0.05,
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
                                  style: TextStyle(
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
                                          horizontal: width * 0.01),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.02,
                                        vertical: width * 0.01,
                                      ),
                                      decoration: BoxDecoration(
                                        color: secondaryPaper,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        "Solic. Enviada",
                                        style: TextStyle(
                                          color: secondaryYellow,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  : Container(),
                              widget.viewModel.match.members[index]
                                          .waitingApproval &&
                                      widget.viewModel.isUserMatchCreator &&
                                      widget.viewModel.matchExpired == false
                                  ? Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          child: InkWell(
                                            onTap: () => widget.viewModel
                                                .invitationResponse(
                                              context,
                                              widget.viewModel.match
                                                  .members[index].user.idUser!,
                                              true,
                                            ),
                                            child: SvgPicture.asset(
                                              r'assets\icon\confirm.svg',
                                              color: secondaryGreen,
                                              height: height * 0.03,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: width * 0.02),
                                          child: InkWell(
                                            onTap: () => widget.viewModel
                                                .invitationResponse(
                                              context,
                                              widget.viewModel.match
                                                  .members[index].user.idUser!,
                                              false,
                                            ),
                                            child: SvgPicture.asset(
                                              r'assets\icon\cancel.svg',
                                              color: Colors.red,
                                              height: height * 0.03,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: SFAvatar(
                            height: height * 0.064,
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
