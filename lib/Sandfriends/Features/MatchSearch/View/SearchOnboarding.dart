import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";

import '../../../../Common/Utils/Constants.dart';

class SearchOnboarding extends StatelessWidget {
  final bool isSearchingStores;
  final bool isRecurrent;
  final Color primaryColor;
  const SearchOnboarding({
    Key? key,
    required this.isSearchingStores,
    this.isRecurrent = false,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: width * 0.2, right: width * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isRecurrent
                  ? r"assets/icon/happy_face_secondary.svg"
                  : r"assets/icon/happy_face.svg",
              height: height * 0.1,
            ),
            SizedBox(
              height: defaultPadding,
            ),
            Text(
              isSearchingStores
                  ? "Informe sua cidade e busque as quadras perto de você!"
                  : isRecurrent
                      ? "Use os filtros para buscar por horários mensalistas disponíveis"
                      : "Use os filtros para buscar por quadras e partidas disponíveis.",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: defaultPadding / 2,
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
