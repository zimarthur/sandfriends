import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Match/View/ActionsSection.dart';
import 'package:sandfriends/Features/Match/View/CreatorNotesSection.dart';
import 'package:sandfriends/Features/Match/View/InformationSection.dart';
import 'package:sandfriends/Features/Match/View/MembersSection.dart';
import 'package:sandfriends/Features/Match/View/OpenMatchSection.dart';
import 'package:sandfriends/Features/Match/View/PaymentSection.dart';
import 'package:sandfriends/SharedComponents/View/StoreSection.dart';

import '../../../Utils/Constants.dart';

import '../ViewModel/MatchViewModel.dart';

class MatchWidget extends StatefulWidget {
  final MatchViewModel viewModel;
  const MatchWidget({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
                court: widget.viewModel.match.court,
                onTapStore: () => widget.viewModel.onTapStore(context),
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
            InformationSection(
              viewModel: widget.viewModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Container(
                height: 1,
                color: textLightGrey,
              ),
            ),
            if (widget.viewModel.isUserMatchCreator &&
                !widget.viewModel.match.canceled &&
                !widget.viewModel.match.isPaymentExpired)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PaymentSection(
                    viewModel: widget.viewModel,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height * 0.03),
                    child: Container(
                      height: 1,
                      color: textLightGrey,
                    ),
                  ),
                ],
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
            if (!widget.viewModel.match.canceled &&
                !widget.viewModel.match.isPaymentExpired)
              OpenMatchSection(viewModel: widget.viewModel),
            if (!widget.viewModel.match.canceled &&
                !widget.viewModel.match.isPaymentExpired)
              ActionSection(
                viewModel: widget.viewModel,
              ),
          ],
        ),
      ),
    );
  }
}
