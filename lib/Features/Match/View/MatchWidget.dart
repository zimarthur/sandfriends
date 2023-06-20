import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Match/View/ActionsSection.dart';
import 'package:sandfriends/Features/Match/View/CreatorNotesSection.dart';
import 'package:sandfriends/Features/Match/View/InformationSection.dart';
import 'package:sandfriends/Features/Match/View/MembersSection.dart';
import 'package:sandfriends/Features/Match/View/OpenMatchSection.dart';
import 'package:sandfriends/Features/Match/View/StoreSection.dart';
import 'package:share_plus/share_plus.dart';

import '../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/Validators.dart';

import '../ViewModel/MatchViewModel.dart';

class MatchWidget extends StatefulWidget {
  MatchViewModel viewModel;
  MatchWidget({
    required this.viewModel,
  });

  @override
  State<MatchWidget> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: () async => widget.viewModel.getMatchInfo(
        context,
        widget.viewModel.match.matchUrl,
      ),
      child: Container(
        color: secondaryBack,
        padding: EdgeInsets.symmetric(horizontal: width * 0.02),
        child: ListView(
          children: [
            SizedBox(
              height: height * 0.2,
              child: StoreSection(
                viewModel: widget.viewModel,
              ),
            ),
            CreatorNotesSection(
              viewModel: widget.viewModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Container(
                height: 1,
                color: textLightGrey,
              ),
            ),
            SizedBox(
              height: height * 0.3,
              child: InformationSection(
                viewModel: widget.viewModel,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Container(
                height: 1,
                color: textLightGrey,
              ),
            ),
            MembersSection(
              viewModel: widget.viewModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Container(
                height: 1,
                color: textLightGrey,
              ),
            ),
            OpenMatchSection(viewModel: widget.viewModel),
            ActionSection(
              viewModel: widget.viewModel,
            ),
          ],
        ),
      ),
    );
  }
}
