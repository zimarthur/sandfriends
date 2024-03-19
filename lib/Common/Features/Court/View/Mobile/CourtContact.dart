import 'package:flutter/material.dart';
import 'package:sandfriends/Common/Model/Store/StoreUser.dart';
import 'package:sandfriends/Common/Features/Court/View/Mobile/CourtContactItem.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Model/Store/StoreComplete.dart';
import '../../../../Utils/UrlLauncher.dart';

class CourtContact extends StatefulWidget {
  final StoreUser store;
  final Color themeColor;
  const CourtContact({
    Key? key,
    required this.store,
    required this.themeColor,
  }) : super(key: key);

  @override
  State<CourtContact> createState() => _CourtContactState();
}

class _CourtContactState extends State<CourtContact> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Contato",
          style:
              TextStyle(color: widget.themeColor, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        CourtContactItem(
          title: widget.store.phoneNumber,
          iconPath: r'assets/icon/whatsapp.svg',
          onTap: () {
            final url =
                Uri.parse("whatsapp://send?phone=${widget.store.phoneNumber}");
            launchUrl(url);
          },
          themeColor: widget.themeColor,
        ),
        if (widget.store.instagram.isNotEmpty)
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: height * 0.02,
                ),
              ),
              CourtContactItem(
                title: widget.store.instagram,
                iconPath: r'assets/icon/instagram.svg',
                onTap: () {
                  final url = Uri.parse(
                      'https://www.instagram.com/${widget.store.instagram}');
                  UrlLauncher(url);
                },
                themeColor: widget.themeColor,
              ),
            ],
          ),
      ],
    );
  }
}
