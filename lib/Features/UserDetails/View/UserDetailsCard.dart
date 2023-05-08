import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../Utils/Constants.dart';
import '../../../oldApp/widgets/SFAvatar.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsCard extends StatefulWidget {
  UserDetailsViewModel viewModel;
  UserDetailsCard({
    required this.viewModel,
  });

  @override
  State<UserDetailsCard> createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Container(
        height: height,
        padding: EdgeInsets.symmetric(
          vertical: height * 0.025,
        ),
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: primaryDarkBlue,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 1,
              color: primaryDarkBlue,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (layoutContext, layoutConstraints) {
                  double remainingHeight = layoutConstraints.maxHeight;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () => widget.viewModel.openUserDetailsModal(
                            UserDetailsModals.Photo, context),
                        child: SizedBox(
                          height: remainingHeight * 0.5,
                          width: remainingHeight * 0.5,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  r'assets\icon\edit.svg',
                                ),
                              ),
                              Center(
                                child: SFAvatar(
                                  showRank: true,
                                  height: remainingHeight * 0.5,
                                  sport: widget.viewModel.displayedSport,
                                  user: widget.viewModel.userEdited,
                                  //editFile: imagePath,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: remainingHeight * 0.45,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () => widget.viewModel
                                  .openUserDetailsModal(
                                      UserDetailsModals.Name, context),
                              child: SizedBox(
                                height: remainingHeight * 0.15,
                                width: width,
                                child: AutoSizeText(
                                  "${widget.viewModel.userEdited.firstName} ${widget.viewModel.userEdited.lastName}",
                                  minFontSize: 22,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: textBlue,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                            AutoSizeText(
                              "15 jogos",
                              minFontSize: 14,
                              textAlign: TextAlign.center,
                              // matchCounterValue!.total == 1
                              //     ? "${matchCounterValue!.total} jogo"
                              //     : "${matchCounterValue!.total} jogos",
                              style: TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                            InkWell(
                              onTap: () => widget.viewModel
                                  .openUserDetailsModal(
                                      UserDetailsModals.Age, context),
                              child: SizedBox(
                                height: remainingHeight * 0.07,
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    widget.viewModel.userEdited.age == null
                                        ? "-"
                                        : widget.viewModel.userEdited.age! < 18
                                            ? "Sub-18"
                                            : widget.viewModel.userEdited.age! <
                                                    40
                                                ? "Sub-40"
                                                : "40+",
                                    style: TextStyle(
                                      color: textDarkGrey,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => widget.viewModel
                                  .openUserDetailsModal(
                                      UserDetailsModals.Region, context),
                              child: Row(
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
                                    height: remainingHeight * 0.07,
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        widget.viewModel.userEdited.city == null
                                            ? "-"
                                            : "${widget.viewModel.userEdited.city!.city} / ${widget.viewModel.userEdited.city!.state!.uf}",
                                        style: TextStyle(
                                          color: textDarkGrey,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            SizedBox(
              height: height * 0.3,
              width: width * 0.6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () => widget.viewModel.openUserDetailsModal(
                        UserDetailsModals.Gender, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Gênero:"),
                        Text(
                          widget.viewModel.userEdited.gender == null
                              ? "-"
                              : widget.viewModel.userEdited.gender!.name,
                          style: TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.viewModel
                        .openUserDetailsModal(UserDetailsModals.Rank, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Rank:"),
                        Text(
                          widget.viewModel.userEdited.ranks
                              .where((ranks) =>
                                  ranks.sport.idSport ==
                                  widget.viewModel.displayedSport.idSport)
                              .first
                              .name,
                          style: TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.viewModel.openUserDetailsModal(
                        UserDetailsModals.SidePreference, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Mão/Pé:"),
                        Text(
                          widget.viewModel.userEdited.sidePreference == null
                              ? "-"
                              : widget
                                  .viewModel.userEdited.sidePreference!.name,
                          style: TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => widget.viewModel.openUserDetailsModal(
                        UserDetailsModals.Height, context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Altura:"),
                        Text(
                          widget.viewModel.userEdited.height == null
                              ? "-"
                              : "${widget.viewModel.userEdited.height!.toStringAsFixed(2)}m",
                          style: TextStyle(
                            color: textBlue,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
