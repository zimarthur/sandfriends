import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/match.dart';
import 'package:sandfriends/providers/sport_provider.dart';
import 'package:sandfriends/theme/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sandfriends/widgets/SFLoading.dart';

import '../models/sport.dart';
import '../models/store.dart';
import '../models/user.dart';
import '../providers/redirect_provider.dart';
import '../providers/store_provider.dart';
import '../providers/user_provider.dart';
import '../providers/sport_provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool isLoading = true;

  List monthsPortuguese = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez'
  ];

  void initState() {
    if (Provider.of<UserProvider>(context, listen: false).matchList.isEmpty ||
        Provider.of<UserProvider>(context, listen: false)
            .nextMatchNeedsRefresh) {
      GetUserInfo(context);
      Provider.of<UserProvider>(context, listen: false).nextMatchNeedsRefresh =
          false;
    } else {
      isLoading = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: AppTheme.colors.secondaryBack,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top + height * 0.07,
            width: width,
            decoration: BoxDecoration(
              color: AppTheme.colors.primaryBlue,
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.colors.divider,
                  width: 0.5,
                ),
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.symmetric(
                vertical: height * 0.01, horizontal: width * 0.01),
            child: SvgPicture.asset(
              r"assets\icon\sandfriends_negative.svg",
            ),
          ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: SFLoading(),
                  ),
                )
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        width: width * 0.5,
                        height: height * 0.07,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            "Olá, ${Provider.of<UserProvider>(context).user!.FirstName}!",
                            style: TextStyle(
                                color: AppTheme.colors.primaryBlue,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                left: width * 0.02,
                                right: width * 0.02,
                                top: height * 0.01),
                            height: height * 0.025,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      r"assets\icon\court.svg",
                                      color: AppTheme.colors.primaryBlue,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(right: width * 0.02),
                                    ),
                                    Text(
                                      "Próximas Partidas",
                                      style: TextStyle(
                                        color: AppTheme.colors.primaryBlue,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                InkWell(
                                  child: Text(
                                    "Ver mais",
                                    style: TextStyle(
                                      color: AppTheme.colors.primaryBlue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.25,
                            child: Provider.of<UserProvider>(context)
                                    .matchList
                                    .isEmpty
                                ? Container(
                                    alignment: Alignment.topCenter,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.02),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.02),
                                    height: height * 0.15,
                                    decoration: BoxDecoration(
                                      color: AppTheme.colors.divider,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Você não tem nenhuma partida agendada",
                                            style: TextStyle(
                                              color: AppTheme.colors.textWhite,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.01),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              Provider.of<Redirect>(context,
                                                      listen: false)
                                                  .selectedPageIndex = 2;
                                              Provider.of<Redirect>(context,
                                                      listen: false)
                                                  .goto(2);
                                            });
                                            Provider.of<Redirect>(context,
                                                    listen: false)
                                                .notifyListeners();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                r"assets\icon\navigation\schedule_screen_selected.svg",
                                                height: height * 0.025,
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: width * 0.02)),
                                              Flexible(
                                                child: Text(
                                                  "Agende já seu horário",
                                                  style: TextStyle(
                                                    color: AppTheme
                                                        .colors.textBlue,
                                                    fontWeight: FontWeight.w700,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount:
                                        Provider.of<UserProvider>(context)
                                            .matchList
                                            .length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: width * 0.02,
                                            vertical: height * 0.01),
                                        width: width * 0.55,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  AppTheme.colors.textLightGrey,
                                              blurRadius: 2.0,
                                              spreadRadius: 0.0,
                                              offset: Offset(1.0, 1.0),
                                            )
                                          ],
                                          color: AppTheme.colors.secondaryPaper,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: height * 0.15,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                ),
                                                child: Image.network(
                                                    '${Provider.of<UserProvider>(context).matchList[index].sport!.photoUrl}',
                                                    width: width * 0.55,
                                                    fit: BoxFit.fill),
                                              ),
                                            ),
                                            Positioned(
                                              left: width * 0.02,
                                              top: height * 0.07,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme
                                                      .colors.secondaryPaper
                                                      .withOpacity(0.9),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                height: height * 0.07,
                                                width: height * 0.07,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "${Provider.of<UserProvider>(context).matchList[index].day!.day}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(
                                                      "${monthsPortuguese[Provider.of<UserProvider>(context).matchList[index].day!.month - 1]}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: height * 0.15,
                                              child: Container(
                                                height: height * 0.08,
                                                width: width * 0.55,
                                                padding: EdgeInsets.only(
                                                    left: width * 0.02),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      child: Text(
                                                        "Partida de ${Provider.of<UserProvider>(context).matchList[index].userCreator}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppTheme
                                                              .colors.textBlue,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          r"assets\icon\clock.svg",
                                                          color: AppTheme.colors
                                                              .textDarkGrey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.01),
                                                        ),
                                                        Text(
                                                          "${Provider.of<UserProvider>(context).matchList[index].timeBegin} - ${Provider.of<UserProvider>(context).matchList[index].timeFinish}",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textDarkGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          r"assets\icon\location_ping.svg",
                                                          color: AppTheme.colors
                                                              .textDarkGrey,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: width *
                                                                      0.01),
                                                        ),
                                                        Text(
                                                          "${Provider.of<UserProvider>(context).matchList[index].store!.name}",
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .colors
                                                                .textDarkGrey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        height: height * 0.16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.02),
                              width: width * 0.47,
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.primaryLightBlue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets\icon\email.svg",
                                    color: AppTheme.colors.textWhite,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: width * 0.02),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Convites",
                                      style: TextStyle(
                                        color: AppTheme.colors.textWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.02),
                              width: width * 0.47,
                              height: height * 0.15,
                              decoration: BoxDecoration(
                                color: AppTheme.colors.primaryDarkBlue,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    r"assets\icon\trophy.svg",
                                    color: AppTheme.colors.textWhite,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(right: width * 0.02),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "Existem 5 partidas abertas",
                                      style: TextStyle(
                                        color: AppTheme.colors.textWhite,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.02),
                        margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                        height: height * 0.15,
                        decoration: BoxDecoration(
                          color: AppTheme.colors.secondaryYellow,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              r"assets\icon\star.svg",
                              color: AppTheme.colors.textWhite,
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: width * 0.02),
                            ),
                            Text(
                              "Recompensas",
                              style: TextStyle(
                                color: AppTheme.colors.textWhite,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> GetUserInfo(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");

    if (accessToken != null) {
      var response = await http.get(
        Uri.parse('https://www.sandfriends.com.br/GetUserInfo/${accessToken}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (mounted) {
        if (response.statusCode == 200) {
          Provider.of<UserProvider>(context, listen: false).clearMatchList();
          Map<String, dynamic> responseBody = json.decode(response.body);
          final responseMatches = responseBody['nextMatches'];
          final responseStores = responseBody['stores'];
          final responseSports = responseBody['sports'];

          for (int i = 0; i < responseSports.length; i++) {
            Map sportJson = responseSports[i];
            Sport newSport = Sport(
                idSport: sportJson['idSport'],
                description: sportJson['description'],
                photoUrl: sportJson['sportPhoto']);
            Provider.of<SportProvider>(context, listen: false)
                .addSport(newSport);
          }

          for (int i = 0; i < responseStores.length; i++) {
            Store newStore = Store();
            Map storeJson = responseStores[i];
            newStore.idStore = storeJson['IdStore'];
            newStore.name = storeJson['name'];
            newStore.address = storeJson['address'];
            newStore.latitude = storeJson['latitude'];
            newStore.longitude = storeJson['longitude'];
            newStore.imageUrl = storeJson['imageURL'];
            newStore.descriptionText = storeJson['description'];
            newStore.instagram = storeJson['instagram'];
            newStore.phone = storeJson['phone'];
            for (int photoIndex = 0;
                photoIndex < storeJson['storePhotos'].length;
                photoIndex++) {
              Map photo = storeJson['storePhotos'][photoIndex];
              newStore.addPhoto(photo['storePhoto']);
            }

            Provider.of<StoreProvider>(context, listen: false)
                .addStore(newStore);
          }

          for (int matchIndex = 0;
              matchIndex < responseMatches.length;
              matchIndex++) {
            var newMatch = Match();
            Provider.of<StoreProvider>(context, listen: false)
                .stores
                .forEach((store) {
              if (store.idStore == responseMatches[matchIndex]['idStore']) {
                newMatch.store = store;
              }
            });
            Provider.of<SportProvider>(context, listen: false)
                .sports
                .forEach((sport) {
              if (sport.idSport == responseMatches[matchIndex]['idSport']) {
                newMatch.sport = sport;
              }
            });
            newMatch.day = DateFormat("yyyy-MM-dd")
                .parse(responseMatches[matchIndex]['date']);
            newMatch.timeInt = responseMatches[matchIndex]['timeInt'];
            newMatch.timeBegin = responseMatches[matchIndex]['timeBegin'];
            newMatch.timeFinish = responseMatches[matchIndex]['timeEnd'];
            newMatch.userCreator = responseMatches[matchIndex]['userCreator'];
            Provider.of<UserProvider>(context, listen: false)
                .addMatch(newMatch);
          }
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }
}
