import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import "../../../Utils/Constants.dart";

class MatchSearchOnboarding extends StatelessWidget {
  const MatchSearchOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: height * 0.2,
        padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SvgPicture.asset(
              r"assets\icon\happy_face.svg",
              height: height * 0.1,
            ),
            SizedBox(
              height: height * 0.05,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Text(
                  "Use os filtros para buscar por\n quadras e partidas disponíveis.",
                  style: TextStyle(
                    color: textBlue,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Container(
              height: height * 0.01 > 4 ? 4 : height * 0.01,
              width: width * 0.8,
              color: divider,
            ),
          ],
        ),
      ),
    );
  }
}
