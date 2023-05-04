import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../oldApp/widgets/SFAvatar.dart';

class UserCardHome extends StatefulWidget {
  HomeViewModel viewModel;
  UserCardHome({
    required this.viewModel,
  });

  @override
  State<UserCardHome> createState() => _UserCardHomeState();
}

class _UserCardHomeState extends State<UserCardHome> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double width = layoutConstraints.maxWidth;
      double height = layoutConstraints.maxHeight;
      return InkWell(
        onTap: () => widget.viewModel.goToUSerDetail(context),
        child: SizedBox(
          height: height * 0.48,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: height * 0.28,
                child: Column(
                  children: [
                    SFAvatar(
                      height: height * 0.22,
                      showRank: false,
                      user: Provider.of<DataProvider>(context, listen: false)
                          .user!,
                      editFile: null,
                    ),
                    SizedBox(
                      height: height * 0.04,
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "${Provider.of<DataProvider>(context, listen: false).user!.firstName} ${Provider.of<DataProvider>(context, listen: false).user!.lastName}",
                          style: TextStyle(color: textWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: height * 0.04),
                height: height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\at_email.svg',
                          color: secondaryPaper,
                          width: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              "${Provider.of<DataProvider>(context, listen: false).user!.email}",
                              style: TextStyle(color: textWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\location_ping.svg',
                          color: secondaryPaper,
                          width: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              Provider.of<DataProvider>(context, listen: false)
                                          .user!
                                          .city ==
                                      null
                                  ? "-"
                                  : "${Provider.of<DataProvider>(context, listen: false).user!.city!.city} / ${Provider.of<DataProvider>(context, listen: false).user!.city!.state!.uf}",
                              style: TextStyle(color: textWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          r'assets\icon\star.svg',
                          color: secondaryPaper,
                          width: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: width * 0.02),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(
                              Provider.of<DataProvider>(context, listen: false)
                                          .user!
                                          .getUserTotalMatches() ==
                                      1
                                  ? "1 jogo"
                                  : "${Provider.of<DataProvider>(context, listen: false).user!.getUserTotalMatches()} jogos",
                              style: TextStyle(color: textWhite),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
