import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sandfriends/Common/Components/SFAvatarUser.dart';
import 'package:sandfriends/Common/Utils/TypeExtensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../ViewModel/MatchViewModel.dart';
import '../../../../Utils/Constants.dart';

class ClassSection extends StatelessWidget {
  final MatchViewModel viewModel;
  const ClassSection({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Aula",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: defaultPadding / 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Turma:",
                  style: TextStyle(
                    fontSize: 12,
                    color: textDarkGrey,
                  ),
                ),
                Text(
                  viewModel.match.team!.name,
                  style: TextStyle(color: textBlue),
                ),
                SizedBox(
                  height: defaultPadding / 2,
                ),
                Text(
                  "Prof:",
                  style: TextStyle(
                    color: textDarkGrey,
                    fontSize: 12,
                  ),
                ),
                GestureDetector(
                  onTap: () => viewModel.openMemberCardModal(
                    context,
                    viewModel.match.tacher,
                  ),
                  child: Row(
                    children: [
                      SFAvatarUser(
                        height: 60,
                        user: viewModel.match.team!.teacher!,
                        showRank: false,
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        viewModel.match.team!.teacher!.fullName,
                        style: TextStyle(color: textBlue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
