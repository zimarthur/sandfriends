import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../../Utils/Constants.dart';

class FeedRewards extends StatelessWidget {
  const FeedRewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () => Navigator.pushNamed(context, '/rewards'),
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.1),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: secondaryYellow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    r"assets/icon/star.svg",
                    color: textWhite,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.05),
                  ),
                  const Text(
                    "Recompensas ",
                    style: TextStyle(
                      color: textWhite,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (Provider.of<UserProvider>(context, listen: false)
                          .userReward !=
                      null)
                    Text(
                      "(${Provider.of<UserProvider>(context).userReward!.userRewardQuantity!}/${Provider.of<UserProvider>(context).userReward!.rewardQuantity})",
                      style: const TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Center(
                  child: LayoutBuilder(
                      builder: (layoutContext, layoutConstraints) {
                    int itemsToShow = 4;
                    double itemMargin = layoutConstraints.maxWidth * 0.02;
                    double itemWidth = (layoutConstraints.maxWidth -
                            (itemsToShow * itemMargin)) /
                        itemsToShow;
                    int rewardsLength =
                        Provider.of<UserProvider>(context).userReward == null
                            ? 0
                            : Provider.of<UserProvider>(context)
                                .userReward!
                                .rewardQuantity;
                    return Container(
                      alignment: Alignment.center,
                      height: itemWidth,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: rewardsLength,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(
                              right:
                                  index == rewardsLength - 1 ? 0 : itemMargin,
                            ),
                            width: itemWidth,
                            decoration: BoxDecoration(
                              color: secondaryPaper,
                              borderRadius:
                                  BorderRadius.circular(itemWidth / 2),
                            ),
                            child: Provider.of<UserProvider>(context)
                                        .userReward!
                                        .userRewardQuantity! >
                                    index
                                ? Center(
                                    child: SvgPicture.asset(
                                      r"assets/icon/sandfriends_logo.svg",
                                      height: itemWidth * 0.7,
                                    ),
                                  )
                                : Container(),
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
