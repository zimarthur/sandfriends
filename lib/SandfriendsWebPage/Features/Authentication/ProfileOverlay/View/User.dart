import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/Common/Utils/Constants.dart';
import 'package:sandfriends/Sandfriends/Providers/UserProvider/UserProvider.dart';

class User extends StatefulWidget {
  VoidCallback onTapProfile;
  VoidCallback onTapMatches;
  VoidCallback onTapCallSupport;
  VoidCallback onTapCallLogout;
  User({
    required this.onTapProfile,
    required this.onTapMatches,
    required this.onTapCallSupport,
    required this.onTapCallLogout,
    super.key,
  });

  @override
  State<User> createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Olá, ${Provider.of<UserProvider>(context, listen: false).user!.firstName}!",
          style: TextStyle(
            color: textBlue,
          ),
        ),
        Text(
          "Como podemos ajudar?",
          style: TextStyle(
            color: textDarkGrey,
            fontWeight: FontWeight.w300,
            fontSize: 12,
          ),
        ),
        SizedBox(
          height: defaultPadding,
        ),
        Container(
          height: 1,
          color: divider,
        ),
        SizedBox(
          height: defaultPadding / 2,
        ),
        UserMenuItem(
          onTap: () => widget.onTapProfile(),
          iconPath: r"assets/icon/user.svg",
          title: "Meu perfil",
        ),
        UserMenuItem(
          onTap: () => widget.onTapMatches(),
          iconPath: r"assets/icon/court.svg",
          title: "Minhas partidas",
        ),
        UserMenuItem(
          onTap: () => widget.onTapCallSupport(),
          iconPath: r"assets/icon/whatsapp.svg",
          title: "Falar com suporte",
        ),
        UserMenuItem(
          onTap: () => widget.onTapCallLogout(),
          iconPath: r"assets/icon/logout.svg",
          title: "Sair",
          color: red,
        ),
      ],
    );
  }
}

class UserMenuItem extends StatefulWidget {
  VoidCallback onTap;
  Color color;
  String iconPath;
  String title;
  UserMenuItem({
    required this.onTap,
    required this.iconPath,
    required this.title,
    this.color = textDarkGrey,
    super.key,
  });

  @override
  State<UserMenuItem> createState() => _UserMenuItemState();
}

class _UserMenuItemState extends State<UserMenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(),
      child: MouseRegion(
        onEnter: (pointer) {
          setState(() {
            isHovered = true;
          });
        },
        onExit: (pointer) {
          setState(() {
            isHovered = false;
          });
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: defaultPadding / 4),
          decoration: BoxDecoration(
            color: isHovered ? secondaryBackWeb : secondaryPaper,
            borderRadius: BorderRadius.circular(
              defaultBorderRadius,
            ),
          ),
          padding: EdgeInsets.all(
            defaultPadding / 2,
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.iconPath,
                color: widget.color,
                height: 20,
              ),
              SizedBox(
                width: defaultPadding / 2,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: widget.color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
