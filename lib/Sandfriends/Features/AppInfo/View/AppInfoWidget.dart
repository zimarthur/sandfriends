import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Sandfriends/Features/AppInfo/ViewModel/AppInfoViewModel.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

import '../../../../Common/Utils/Constants.dart';

class AppInfoWidget extends StatelessWidget {
  final AppInfoViewModel viewModel;
  const AppInfoWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding / 2),
      color: secondaryBack,
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Notificações",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Container(
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              decoration: BoxDecoration(
                color: secondaryPaper,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                border: Border.all(
                  color: divider,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 25,
                        child: SvgPicture.asset(
                          r"assets/icon/notification.svg",
                          color: textDarkGrey,
                          height: 20,
                        ),
                      ),
                      SizedBox(
                        width: defaultPadding / 2,
                      ),
                      Text(
                        "Habilitar notificações",
                        style: TextStyle(color: textDarkGrey, fontSize: 12),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Switch(
                              activeColor: primaryBlue,
                              value: Provider.of<UserProvider>(context)
                                  .user!
                                  .allowNotifications,
                              onChanged: (isEnable) {
                                Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).user!.allowNotifications = isEnable;
                                viewModel.onTapEnableNotifications(
                                  context,
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 0.5,
                    color: divider,
                    margin: EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (defaultPadding / 2) + 25,
                      ),
                      Text(
                        "Receber cupons de desconto",
                        style: TextStyle(color: textDarkGrey, fontSize: 10),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Switch(
                            activeColor: primaryBlue,
                            value: Provider.of<UserProvider>(context)
                                .user!
                                .allowNotificationsCoupons,
                            onChanged: (isEnable) {
                              Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user!.allowNotificationsCoupons = isEnable;
                              viewModel.onTapEnableNotifications(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: (defaultPadding / 2) + 25,
                      ),
                      Text(
                        "Receber novas partida abertas",
                        style: TextStyle(color: textDarkGrey, fontSize: 10),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      SizedBox(
                        height: 35,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Switch(
                            activeColor: primaryBlue,
                            value: Provider.of<UserProvider>(context)
                                .user!
                                .allowNotificationsOpenMatches,
                            onChanged: (isEnable) {
                              Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user!.allowNotificationsOpenMatches = isEnable;
                              viewModel.onTapEnableNotifications(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Sobre o app",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Container(
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              decoration: BoxDecoration(
                color: secondaryPaper,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                border: Border.all(
                  color: divider,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => viewModel.pressInfo(),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          child: SvgPicture.asset(
                            r"assets/icon/info_circle.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Versão",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Text(
                          viewModel.appVersion,
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: divider,
                    margin: EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  InkWell(
                    onTap: () => viewModel.onTapPrivacy(context),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          child: SvgPicture.asset(
                            r"assets/icon/file_page.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Política de privacidade",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        SvgPicture.asset(
                          r"assets/icon/chevron_right.svg",
                          color: textDarkGrey,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: divider,
                    margin: EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  InkWell(
                    onTap: () => viewModel.onTapTerms(context),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          child: SvgPicture.asset(
                            r"assets/icon/data_tree.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Termos de uso",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        SvgPicture.asset(
                          r"assets/icon/chevron_right.svg",
                          color: textDarkGrey,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              "Sessão",
              style: TextStyle(
                color: textDarkGrey,
                fontSize: 10,
              ),
            ),
            SizedBox(
              height: defaultPadding / 2,
            ),
            Container(
              padding: EdgeInsets.all(
                defaultPadding,
              ),
              decoration: BoxDecoration(
                color: secondaryPaper,
                borderRadius: BorderRadius.circular(
                  defaultBorderRadius,
                ),
                border: Border.all(
                  color: divider,
                  width: 0.5,
                ),
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => viewModel.onTapLogout(context),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          child: SvgPicture.asset(
                            r"assets/icon/logout.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Sair",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 0.5,
                    color: divider,
                    margin: EdgeInsets.symmetric(
                      vertical: defaultPadding / 2,
                    ),
                  ),
                  InkWell(
                    onTap: () => viewModel.onDeleteAccount(context),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 25,
                          child: SvgPicture.asset(
                            r"assets/icon/delete.svg",
                            color: textDarkGrey,
                            height: 20,
                          ),
                        ),
                        SizedBox(
                          width: defaultPadding / 2,
                        ),
                        Text(
                          "Deletar conta",
                          style: TextStyle(color: textDarkGrey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
