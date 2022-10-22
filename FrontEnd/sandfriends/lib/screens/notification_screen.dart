import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/providers/user_provider.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:sandfriends/widgets/SFAvatar.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';

import '../models/enums.dart';
import '../models/user.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool showModal = false;
  var myUser =
      User(idUser: -1, firstName: "Arthur", lastName: "Zim", photo: "");
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SFScaffold(
        titleText: "Notificações",
        onTapReturn: () =>
            context.goNamed('home', params: {'initialPage': 'feed_screen'}),
        appBarType: AppBarType.Primary,
        showModal: showModal,
        child: Container(
          color: AppTheme.colors.secondaryBack,
          child: ListView.builder(
              itemCount: Provider.of<UserProvider>(context, listen: false)
                  .notificationList
                  .length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    context.goNamed('match_screen', params: {
                      'matchUrl':
                          "${Provider.of<UserProvider>(context, listen: false).notificationList[index].match.matchUrl}",
                      'returnTo': 'notification_screen',
                      'returnToParam': 'null',
                      'returnToParamValue': 'null',
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Provider.of<UserProvider>(context, listen: false)
                                .notificationList[index]
                                .seen
                            ? AppTheme.colors.primaryLightBlue.withOpacity(0.5)
                            : AppTheme.colors.primaryLightBlue,
                        width: 1,
                      ),
                      color: Provider.of<UserProvider>(context, listen: false)
                              .notificationList[index]
                              .seen
                          ? AppTheme.colors.primaryLightBlue.withOpacity(0.1)
                          : AppTheme.colors.primaryLightBlue.withOpacity(0.6),
                    ),
                    margin: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.02),
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.02, vertical: height * 0.02),
                    child: Row(
                      children: [
                        Container(
                          width: width * 0.2,
                          child: Stack(
                            children: [
                              SFAvatar(
                                  height: width * 0.2,
                                  user: myUser,
                                  showRank: false),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: width * 0.06,
                                  width: width * 0.06,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color(int.parse(
                                          "0xFF${Provider.of<UserProvider>(context, listen: false).notificationList[index].colorString.replaceAll("#", "")}"))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            right: width * 0.04,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: width * 0.2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    Provider.of<UserProvider>(context,
                                            listen: false)
                                        .notificationList[index]
                                        .message,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            r"assets\icon\calendar.svg"),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.02,
                                          ),
                                        ),
                                        Text(
                                          "${DateFormat("dd/MM/yyyy").format(Provider.of<UserProvider>(context, listen: false).notificationList[index].match.day!)} às ${Provider.of<UserProvider>(context, listen: false).notificationList[index].match.timeBegin}",
                                          style: TextStyle(
                                            color: AppTheme.colors.textBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            r"assets\icon\location_ping.svg"),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: width * 0.02,
                                          ),
                                        ),
                                        Text(
                                          "Beach Brasil",
                                          style: TextStyle(
                                            color: AppTheme.colors.textBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
