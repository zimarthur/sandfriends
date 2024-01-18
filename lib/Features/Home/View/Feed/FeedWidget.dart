import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/local_notifications.dart';
import 'package:tuple/tuple.dart';

import '../../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'FeedHeader.dart';
import 'FeedNextMatches.dart';
import 'FeedOpenMatches.dart';
import 'FeedRecurrentMatches.dart';
import 'FeedRewards.dart';

class FeedWidget extends StatefulWidget {
  final HomeViewModel viewModel;
  const FeedWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FeedHeader(
              viewModel: widget.viewModel,
              height: MediaQuery.of(context).padding.top + height * 0.07,
              width: width,
            ),
            RefreshIndicator(
              onRefresh: () async {
                widget.viewModel.getUserInfo(context, Tuple2(null, null));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: height -
                      (MediaQuery.of(context).padding.top + height * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: ()=> throw Exception("Teste erro"),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                          width: width * 0.5,
                          height: height * 0.07,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              "Olá, ${Provider.of<UserProvider>(context).user!.firstName}!",
                              style: const TextStyle(
                                color: primaryBlue,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FeedNextMatches(
                        viewModel: widget.viewModel,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        height: height * 0.2,
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
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        height: height * 0.2,
                        child: const FeedRewards(),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      )
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
