import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../SharedComponents/Model/AppMatch.dart';
import '../../../SharedComponents/View/SFLoading.dart';
import '../../../Utils/Constants.dart';
import '../../../Utils/SFDateTime.dart';

class MatchCard extends StatelessWidget {
  AppMatch match;
  MatchCard({Key? key, 
    required this.match,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (layoutContext, layoutConstraints) {
      double height = layoutConstraints.maxHeight;
      double width = layoutConstraints.maxWidth;
      return InkWell(
        onTap: () =>
            Navigator.pushNamed(context, '/match_screen/${match.matchUrl}'),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: textLightGrey,
                blurRadius: 2.0,
                spreadRadius: 0.0,
                offset: Offset(1.0, 1.0),
              )
            ],
            color: secondaryPaper,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              Container(
                height: height * 0.6,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: match.sport.photoUrl,
                    fit: BoxFit.fill,
                    width: double.infinity,
                    placeholder: (context, url) => const Center(
                      child: SFLoading(),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.dangerous),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.02,
                top: height * 0.3,
                child: Container(
                  decoration: BoxDecoration(
                    color: secondaryPaper.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: height * 0.25,
                  width: height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: height * 0.1,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "${match.date.day}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.08,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "${monthsPortuguese[match.date.month - 1]}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: height * 0.6,
                child: Container(
                  padding: EdgeInsets.only(left: width * 0.03),
                  width: width,
                  height: height * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: height * 0.12,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Partida de ${match.matchCreator.firstName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: textBlue,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.01),
                        height: height * 0.09,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                r"assets\icon\clock.svg",
                                color: textDarkGrey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: width * 0.03),
                              ),
                              Text(
                                "${match.timeBegin.hourString} - ${match.timeEnd.hourString}",
                                style: const TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: width * 0.01),
                        height: height * 0.09,
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                r"assets\icon\location_ping.svg",
                                color: textDarkGrey,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: width * 0.03),
                              ),
                              Text(
                                match.court.store!.name,
                                style: const TextStyle(
                                  color: textDarkGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: match.date.isBefore(DateTime.now())
                        ? textLightGrey.withOpacity(0.6)
                        : Colors.transparent),
              ),
              match.canceled == true
                  ? Positioned(
                      right: width * 0.02,
                      top: width * 0.02,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02, vertical: width * 0.01),
                        decoration: BoxDecoration(
                          color: match.date.isBefore(DateTime.now())
                              ? Colors.red.withOpacity(0.6)
                              : Colors.red,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          "Cancelada",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: textWhite,
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      );
    });
  }
}
