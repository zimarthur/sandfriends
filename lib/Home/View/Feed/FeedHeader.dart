import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/SharedComponents/ViewModel/DataProvider.dart';
import 'package:sandfriends/Utils/Constants.dart';

class FeedHeader extends StatefulWidget {
  HomeViewModel viewModel;
  double height;
  double width;
  FeedHeader({
    required this.viewModel,
    required this.height,
    required this.width,
  });

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryBlue,
        border: Border(
          bottom: BorderSide(
            color: divider,
            width: 0.5,
          ),
        ),
      ),
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.symmetric(
        vertical: widget.height * 0.01,
        horizontal: widget.width * 0.01,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            r"assets\icon\sandfriends_negative.svg",
          ),
          InkWell(
            onTap: () {
              widget.viewModel.goToNotificationScreen();
            },
            child: Container(
              height: widget.height * 0.05,
              padding: EdgeInsets.symmetric(
                horizontal: widget.width * 0.05,
              ),
              child: SvgPicture.asset(
                Provider.of<DataProvider>(context, listen: false)
                        .notifications
                        .any((notification) => notification.seen == false)
                    ? r"assets\icon\notification_on.svg"
                    : r"assets\icon\notification_off.svg",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
