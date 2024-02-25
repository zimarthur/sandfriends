import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../Providers/UserProvider/UserProvider.dart';
import '../../../../../Common/Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';

class FeedOpenMatches extends StatelessWidget {
  final HomeViewModel viewModel;
  const FeedOpenMatches({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () {
          if (Provider.of<UserProvider>(context, listen: false)
              .openMatches
              .isNotEmpty) {
            Navigator.pushNamed(context, '/open_matches');
          }
        },
        child: Container(
          alignment: Alignment.topCenter,
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.05, vertical: height * 0.1),
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: primaryDarkBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                r"assets/icon/trophy.svg",
                color: textWhite,
              ),
              Padding(
                padding: EdgeInsets.only(right: width * 0.05),
              ),
              Flexible(
                child: Text(
                  Provider.of<UserProvider>(context).openMatches.isEmpty
                      ? "Não há partidas abertas perto de você"
                      : Provider.of<UserProvider>(context).openMatches.length ==
                              1
                          ? "Existe 1 partida aberta perto de você"
                          : "Existem ${Provider.of<UserProvider>(context).openMatches.length} partidas abertas perto de você",
                  style: const TextStyle(
                    color: textWhite,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
