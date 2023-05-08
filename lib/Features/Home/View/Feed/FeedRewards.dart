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
        onTap: () => Navigator.pushNamed(context, '/reward_screen'),
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
                    r"assets\icon\star.svg",
                    color: textWhite,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width * 0.05),
                  ),
                  Text(
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
                      "(${Provider.of<UserProvider>(context, listen: false).userReward!.userRewardQuantity!}/${Provider.of<UserProvider>(context, listen: false).userReward!.rewardQuantity})",
                      style: TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    height: height * 0.5,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: Provider.of<UserProvider>(context,
                                      listen: false)
                                  .userReward ==
                              null
                          ? 0
                          : Provider.of<UserProvider>(context, listen: false)
                              .userReward!
                              .rewardQuantity,
                      itemBuilder: (context, index) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: width * 0.015),
                          padding: EdgeInsets.all(height * 0.1),
                          width: height * 0.5,
                          decoration: BoxDecoration(
                            color: secondaryPaper,
                            borderRadius: BorderRadius.circular(height * 0.25),
                          ),
                          child:
                              Provider.of<UserProvider>(context, listen: false)
                                          .userReward!
                                          .userRewardQuantity! >
                                      index
                                  ? SvgPicture.asset(
                                      r"assets\icon\sandfriends_logo.svg",
                                    )
                                  : Container(),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
