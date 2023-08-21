import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../SharedComponents/Providers/UserProvider/UserProvider.dart';
import '../../../../SharedComponents/View/SFAvatar.dart';
import '../../../../Utils/Constants.dart';
import '../../ViewModel/HomeViewModel.dart';
import 'USerCardHomeItem.dart';

class UserCardHome extends StatefulWidget {
  HomeViewModel viewModel;
  UserCardHome({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

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
                        user: Provider.of<UserProvider>(context, listen: false)
                            .user!,
                        editFile: null,
                      ),
                      SizedBox(
                        height: height * 0.15,
                        child: FittedBox(
                          child: Text(
                            "${Provider.of<UserProvider>(context, listen: false).user!.firstName} ${Provider.of<UserProvider>(context, listen: false).user!.lastName}",
                            style: const TextStyle(
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
                  text: Provider.of<UserProvider>(context, listen: false)
                      .user!
                      .email,
                  iconPath: r'assets/icon/at_email.svg',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: UserCardHomeItem(
                    text: Provider.of<UserProvider>(context, listen: false)
                                .user!
                                .city ==
                            null
                        ? "-"
                        : "${Provider.of<UserProvider>(context, listen: false).user!.city!.city} / ${Provider.of<UserProvider>(context, listen: false).user!.city!.state!.uf}",
                    iconPath: r'assets/icon/location_ping.svg',
                  ),
                ),
                UserCardHomeItem(
                  text: Provider.of<UserProvider>(context, listen: false)
                              .user!
                              .getUserTotalMatches() ==
                          1
                      ? "1 jogo"
                      : "${Provider.of<UserProvider>(context, listen: false).user!.getUserTotalMatches()} jogos",
                  iconPath: r'assets/icon/star.svg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
