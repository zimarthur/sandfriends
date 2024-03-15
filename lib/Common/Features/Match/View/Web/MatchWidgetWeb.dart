import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/ActionsSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/CreatorNotesSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/InformationSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/MembersSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/OpenMatchSection.dart';
import 'package:sandfriends/Common/Features/Match/View/Mobile/PaymentSection.dart';
import 'package:sandfriends/SandfriendsWebPage/Features/LandingPage/View/WebHeader.dart';

import '../../../../Components/StoreSection.dart';
import '../../../../Utils/Constants.dart';

import '../../ViewModel/MatchViewModel.dart';

class MatchWidgetWeb extends StatefulWidget {
  final MatchViewModel viewModel;
  const MatchWidgetWeb({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  State<MatchWidgetWeb> createState() => _MatchWidgetState();
}

class _MatchWidgetState extends State<MatchWidgetWeb> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        WebHeader(
          showSport: false,
        ),
        Expanded(
          child: Container(
            color: secondaryBackWeb,
            width: width,
            height: height,
            padding: EdgeInsets.symmetric(
              horizontal: width * (1 - defaultWebScreenWidth),
              vertical: defaultPadding,
            ),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.viewModel.titleText,
                          style: TextStyle(
                            fontSize: 20,
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        SizedBox(
                          height: 150,
                          child: StoreSection(
                            court: widget.viewModel.match.court,
                            onTapStore: () =>
                                widget.viewModel.onTapStore(context),
                          ),
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        CreatorNotesSection(
                          viewModel: widget.viewModel,
                          showDivider: false,
                        ),
                        SizedBox(
                          height: defaultPadding,
                        ),
                        InformationSection(
                          viewModel: widget.viewModel,
                        ),
                        SizedBox(
                          height: defaultPadding,
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
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 2 * defaultPadding,
                ),
                SizedBox(
                  width: 400,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        MembersSection(
                          viewModel: widget.viewModel,
                        ),
                        if (!widget.viewModel.match.canceled &&
                            !widget.viewModel.match.isPaymentExpired) ...[
                          Padding(
                            padding:
                                EdgeInsets.symmetric(vertical: defaultPadding),
                            child: Container(
                              height: 1,
                              color: textLightGrey,
                            ),
                          ),
                          OpenMatchSection(viewModel: widget.viewModel),
                        ],
                        if (!widget.viewModel.match.canceled &&
                            !widget.viewModel.match.isPaymentExpired)
                          ActionSection(
                            viewModel: widget.viewModel,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
