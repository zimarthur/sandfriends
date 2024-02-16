import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Model/Player.dart';
import '../Utils/Constants.dart';

class SelectPlayer extends StatelessWidget {
  Player? player;
  VoidCallback onTap;

  SelectPlayer({required this.player, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: primaryBlue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(
            defaultBorderRadius,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: defaultPadding / 2,
          horizontal: defaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              r"assets/icon/user.svg",
              color: textBlue,
            ),
            SizedBox(
              width: defaultPadding / 2,
            ),
            Text(
              player == null ? "Selecionar jogador" : player!.fullName,
              style: TextStyle(
                color: textBlue,
                fontSize: 12,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
