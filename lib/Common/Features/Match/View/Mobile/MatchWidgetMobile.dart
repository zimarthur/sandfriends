import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/ActionsSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/CreatorNotesSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/InformationSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/MembersSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/OpenMatchSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/PaymentSection.dart';

import '../../../../Components/StoreSection.dart';
import '../../../../Utils/Constants.dart';

import '../../ViewModel/MatchViewModel.dart';

class MatchWidgetMobile extends StatefulWidget {
  final MatchViewModel viewModel;
  const MatchWidgetMobile({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<MatchWidgetMobile> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidgetMobile> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return RefreshIndicator(
      onRefresh: () async => widget.viewModel.getMatchInfo(
        context,
        widget.viewModel.match.matchUrl,
      ),
      child: Container(
        color: secondaryBack,
        padding: EdgeInsets.symmetric(
          horizontal: defaultPadding / 2,
        ),
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
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
              child: Container(
                height: 1,
                color: textLightGrey,
              ),
            ),
            InformationSection(
              viewModel: widget.viewModel,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
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
                    onExpired: () => widget.viewModel.getMatchInfo(
                      context,
                      widget.viewModel.match.matchUrl,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultPadding),
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
              padding: EdgeInsets.symmetric(vertical: defaultPadding),
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
