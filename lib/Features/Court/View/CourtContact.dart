import 'package:flutter/material.dart';
import 'package:sandfriends/Features/Court/View/CourtContactItem.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../SharedComponents/Model/Store.dart';
import '../../../Utils/UrlLauncher.dart';

class CourtContact extends StatefulWidget {
  final Store store;
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
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: height * 0.02, horizontal: width * 0.02),
          child: Text(
            "Contato",
            style: TextStyle(
                color: widget.themeColor, fontWeight: FontWeight.w700),
          ),
        ),
        CourtContactItem(
          title: widget.store.phone,
          iconPath: r'assets/icon/whatsapp.svg',
          onTap: () {
            final url =
                Uri.parse("whatsapp://send?phone=${widget.store.phone}");
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
