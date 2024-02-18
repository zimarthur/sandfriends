import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class SFHeader extends StatelessWidget {
  final String header;
  final String description;

  const SFHeader({super.key, required this.header, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: defaultPadding),
      width: double.infinity,
      //height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: const TextStyle(
              color: textBlack,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: defaultPadding / 2,
          ),
          Text(
            description,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textDarkGrey,
              fontWeight: FontWeight.w300,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
