import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/View/Feed/FeedNextMatches.dart';
import 'package:sandfriends/Features/Home/View/Feed/FeedRecurrentMatches.dart';
import 'package:sandfriends/Features/Home/View/Feed/FeedRewards.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'FeedHeader.dart';
import 'FeedOpenMatches.dart';

class FeedWidget extends StatefulWidget {
  HomeViewModel viewModel;
  FeedWidget({
    required this.viewModel,
  });

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return Container(
        color: secondaryBack,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeedHeader(
              viewModel: widget.viewModel,
              height: MediaQuery.of(context).padding.top + height * 0.07,
              width: width,
            ),
            RefreshIndicator(
              onRefresh: () => widget.viewModel.getUserInfo(context),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: height -
                      (MediaQuery.of(context).padding.top + height * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        width: width * 0.5,
                        height: height * 0.07,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Olá, ${Provider.of<DataProvider>(context).user!.firstName}!",
                            style: TextStyle(
                              color: primaryBlue,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: height * 0.02,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.35,
                        width: width,
                        child: FeedNextMatches(
                          viewModel: widget.viewModel,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            height: height * 0.16,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: FeedRecurrentMatches(
                                    viewModel: widget.viewModel,
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.03,
                                ),
                                Expanded(
                                  child: FeedOpenMatches(
                                    viewModel: widget.viewModel,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: width * 0.03,
                          ),
                          Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width * 0.02),
                            height: height * 0.2,
                            child: FeedRewards(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
