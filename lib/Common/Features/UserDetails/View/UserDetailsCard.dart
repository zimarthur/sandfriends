import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import '../../../../Sandfriends/Providers/UserProvider/UserProvider.dart';
import '../../../Components/SFAvatarUser.dart';
import '../../../Utils/Constants.dart';
import '../ViewModel/UserDetailsViewModel.dart';

class UserDetailsCard extends StatefulWidget {
  final UserDetailsViewModel viewModel;
  const UserDetailsCard({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
          boxShadow: const [
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
                          width: remainingHeight * 0.5 + (25 * 2),
                          child: Stack(
                            children: [
                              Center(
                                child: SFAvatarUser(
                                  showRank: true,
                                  height: remainingHeight * 0.5,
                                  sport: widget.viewModel.displayedSport,
                                  user: widget.viewModel.userEdited,
                                  editFile: widget.viewModel.noImage
                                      ? null
                                      : widget.viewModel.imagePicker,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: SvgPicture.asset(
                                  r'assets/icon/edit.svg',
                                  color: primaryBlue,
                                  width: 25,
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
                                  style: const TextStyle(
                                      color: textBlue,
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),
                            AutoSizeText(
                              Provider.of<UserProvider>(context, listen: false)
                                          .user!
                                          .getUserSportMatches(widget
                                              .viewModel.displayedSport) ==
                                      1
                                  ? "1 jogo"
                                  : "${Provider.of<UserProvider>(context, listen: false).user!.getUserSportMatches(widget.viewModel.displayedSport)} jogos",
                              minFontSize: 14,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: textDarkGrey,
                              ),
                            ),
                            InkWell(
                              onTap: () => widget.viewModel
                                  .openUserDetailsModal(
                                      UserDetailsModals.Age, context),
                              child: SizedBox(
                                height: remainingHeight * 0.07,
                                width: width,
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
                                    style: const TextStyle(
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
                                    r'assets/icon/location_ping.svg',
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
                                            : "${widget.viewModel.userEdited.city!.name} / ${widget.viewModel.userEdited.city!.state!.uf}",
                                        style: const TextStyle(
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
                          style: const TextStyle(
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
                          widget.viewModel.userRankForSport.name,
                          style: TextStyle(
                            color: widget.viewModel.userRankForSport.colorObj,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                widget.viewModel.userRankForSport.colorObj,
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
                          style: const TextStyle(
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
                          style: const TextStyle(
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
