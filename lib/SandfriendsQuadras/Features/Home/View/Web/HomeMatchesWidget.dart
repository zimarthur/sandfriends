import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'ResumedMatch.dart';

class HomeMatchesWidget extends StatelessWidget {
  HomeViewModel viewModel;
  HomeMatchesWidget({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      return Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryPaper,
          borderRadius: BorderRadius.circular(defaultBorderRadius),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Partidas acontecendo hoje",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textDarkGrey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        if (!viewModel.isLowestHour) {
                          viewModel.decreaseHour();
                        }
                      },
                      child: SvgPicture.asset(
                        r'assets/icon/chevron_left.svg',
                        color: viewModel.isLowestHour
                            ? textLightGrey
                            : primaryBlue,
                      ),
                    ),
                    Text(
                      viewModel.displayedHour.hourString,
                      style: TextStyle(
                        color: textDarkGrey,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (!viewModel.isHighestHour) {
                          viewModel.increaseHour();
                        }
                      },
                      child: SvgPicture.asset(
                        r'assets/icon/chevron_right.svg',
                        color: viewModel.isHighestHour
                            ? textLightGrey
                            : primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: defaultPadding / 2,
            ),
            Expanded(
              child: viewModel.matchesOnDisplayesHour.isEmpty
                  ? Center(
                      child: Text(
                        "sem partidas nesse horário",
                        style: TextStyle(
                          color: textDarkGrey,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: viewModel.matchesOnDisplayesHour.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              const EdgeInsets.only(top: defaultPadding / 2),
                          child: ResumedMatch(
                              match: viewModel.matchesOnDisplayesHour[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}
