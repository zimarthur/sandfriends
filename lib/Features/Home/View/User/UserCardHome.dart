import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Features/Home/View/User/USerCardHomeItem.dart';
import 'package:sandfriends/Features/Home/ViewModel/HomeViewModel.dart';
import 'package:sandfriends/Utils/Constants.dart';

import '../../../../SharedComponents/ViewModel/DataProvider.dart';
import '../../../../oldApp/widgets/SFAvatar.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => widget.viewModel.goToUSerDetail(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (layoutContext, layoutConstraints) {
                  double width = layoutConstraints.maxWidth;
                  double height = layoutConstraints.maxHeight;
                  return Column(
                    children: [
                      SFAvatar(
                        height: height * 0.65,
                        showRank: false,
                        user: Provider.of<DataProvider>(context, listen: false)
                            .user!,
                        editFile: null,
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: FittedBox(
                          child: Text(
                            "${Provider.of<DataProvider>(context, listen: false).user!.firstName} ${Provider.of<DataProvider>(context, listen: false).user!.lastName}",
                            style: TextStyle(
                              color: textWhite,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Column(
              children: [
                UserCardHomeItem(
                  text:
                      "${Provider.of<DataProvider>(context, listen: false).user!.email}",
                  iconPath: r'assets\icon\at_email.svg',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: UserCardHomeItem(
                    text: Provider.of<DataProvider>(context, listen: false)
                                .user!
                                .city ==
                            null
                        ? "-"
                        : "${Provider.of<DataProvider>(context, listen: false).user!.city!.city} / ${Provider.of<DataProvider>(context, listen: false).user!.city!.state!.uf}",
                    iconPath: r'assets\icon\location_ping.svg',
                  ),
                ),
                UserCardHomeItem(
                  text: Provider.of<DataProvider>(context, listen: false)
                              .user!
                              .getUserTotalMatches() ==
                          1
                      ? "1 jogo"
                      : "${Provider.of<DataProvider>(context, listen: false).user!.getUserTotalMatches()} jogos",
                  iconPath: r'assets\icon\star.svg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}