import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/models/enums.dart';
import 'package:sandfriends/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;

import '../models/court.dart';
import '../models/store.dart';
import '../models/user.dart';
import '../providers/categories_provider.dart';
import '../providers/court_provider.dart';
import '../providers/match_provider.dart';
import '../providers/store_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/SFLoading.dart';
import '../models/match.dart';
import '../widgets/SF_OpenMatchVertical.dart';

class OpenMatchesScreen extends StatefulWidget {
  const OpenMatchesScreen({Key? key}) : super(key: key);

  @override
  State<OpenMatchesScreen> createState() => _OpenMatchesScreenState();
}

class _OpenMatchesScreenState extends State<OpenMatchesScreen> {
  bool isLoading = true;
  bool showModal = false;
  Widget? modalWidget;

  @override
  void initState() {
    GetOpenMatches(context).then((value) => super.initState());
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SFScaffold(
      titleText: "Partidas Abertas",
      onTapReturn: () =>
          context.goNamed('home', params: {'initialPage': 'feed_screen'}),
      appBarType: AppBarType.Primary,
      showModal: showModal,
      child: isLoading
          ? Stack(
              children: [
                Container(
                  color: AppTheme.colors.secondaryBack,
                ),
                Container(
                  color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                  child: Center(
                    child: SFLoading(),
                  ),
                )
              ],
            )
          : Container(
              color: AppTheme.colors.secondaryBack,
              child: ListView.builder(
                itemCount: Provider.of<MatchProvider>(context, listen: false)
                    .openMatchList
                    .length,
                itemBuilder: (context, index) {
                  return SFOpenMatchVertical(
                    buttonCallback: () {
                      context.go(
                          '/match_screen/${Provider.of<MatchProvider>(context, listen: false).openMatchList[index].matchUrl}/open_matches_screen/null/null');
                    },
                    match: Provider.of<MatchProvider>(context, listen: false)
                        .openMatchList[index],
                  );
                },
              ),
            ),
    );
  }

  Future<void> GetOpenMatches(BuildContext context) async {
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");

    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/GetOpenMatches'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, Object>{
            'accessToken': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        Provider.of<MatchProvider>(context, listen: false).clearOpenMatchList();

        final responseBody = json.decode(response.body);
        final responseOpenMatches = responseBody['OpenMatches'];
        final responseStores = responseBody['Stores'];
        final responseCourts = responseBody['Courts'];

        for (int i = 0; i < responseStores.length; i++) {
          Store newStore = Store();
          Map storeJson = responseStores[i];
          Map storeDetailsJson = storeJson['Store'];
          var storePhotosJson = storeJson['StorePhoto'];
          newStore.idStore = storeDetailsJson['IdStore'];
          newStore.name = storeDetailsJson['Name'];
          newStore.address = storeDetailsJson['Address'];
          newStore.latitude = storeDetailsJson['Latitude'];
          newStore.longitude = storeDetailsJson['Longitude'];
          newStore.imageUrl = storeDetailsJson['Logo'];
          newStore.descriptionText = storeDetailsJson['Description'];
          newStore.instagram = storeDetailsJson['Instagram'];
          newStore.phone = storeDetailsJson['PhoneNumber1'];
          for (int photoIndex = 0;
              photoIndex < storePhotosJson.length;
              photoIndex++) {
            Map photo = storePhotosJson[photoIndex];
            newStore.addPhoto(photo['Photo']);
          }
          Provider.of<StoreProvider>(context, listen: false).addStore(newStore);
        }

        for (int i = 0; i < responseCourts.length; i++) {
          Map courtJson = responseCourts[i];
          Provider.of<CourtProvider>(context, listen: false).addCourt(
            Court(
              courtJson['IdStoreCourt'],
              courtJson['Description'],
              courtJson['IsIndoor'],
            ),
          );
        }

        for (int i = 0; i < responseOpenMatches.length; i++) {
          Map openCourtJson = responseOpenMatches[i];
          Map openCourtDetailsJson = openCourtJson['MatchDetails'];
          Map openCourtMatchCreatorJson = openCourtJson['MatchCreator'];
          Map openCourtMatchCreatorRankJson = openCourtJson['MatchCreatorRank'];

          var newOpenMatch = Match();
          newOpenMatch.remainingSlots = openCourtJson['SlotsRemaining'];
          var matchCreator = User(
            idUser: openCourtMatchCreatorJson['IdUser'],
            firstName: openCourtMatchCreatorJson['FirstName'],
            lastName: openCourtMatchCreatorJson['LastName'],
            photo: openCourtMatchCreatorJson['Photo'],
          );

          newOpenMatch.matchCreator = matchCreator;

          Provider.of<StoreProvider>(context, listen: false)
              .stores
              .forEach((store) {
            if (store.idStore == openCourtDetailsJson['IdStore']) {
              newOpenMatch.store = store;
            }
          });
          Provider.of<CourtProvider>(context, listen: false)
              .courts
              .forEach((court) {
            if (court.idStoreCourt == openCourtDetailsJson['IdStoreCourt']) {
              newOpenMatch.court = court;
            }
          });
          Provider.of<CategoriesProvider>(context, listen: false)
              .sports
              .forEach((sport) {
            if (sport.idSport == openCourtDetailsJson['IdSport']) {
              newOpenMatch.sport = sport;
            }
          });
          Provider.of<CategoriesProvider>(context, listen: false)
              .ranks
              .forEach((rank) {
            if (rank.idRankCategory ==
                openCourtMatchCreatorRankJson['IdRankCategory']) {
              newOpenMatch.matchCreator!.rank.add(rank);
            }
          });
          newOpenMatch.idMatch = openCourtDetailsJson['IdMatch'];
          newOpenMatch.price = openCourtDetailsJson['Cost'];
          newOpenMatch.day = DateTime.parse(openCourtDetailsJson['Date']);
          newOpenMatch.matchUrl = openCourtDetailsJson['MatchUrl'];
          newOpenMatch.timeBegin = openCourtDetailsJson['TimeBegin'];
          newOpenMatch.timeFinish = openCourtDetailsJson['TimeEnd'];
          newOpenMatch.timeInt = openCourtDetailsJson['TimeInteger'];

          Provider.of<MatchProvider>(context, listen: false)
              .addOpenMatch(newOpenMatch);
        }
        setState(() {
          isLoading = false;
        });
      } else {
        print("deu erro");
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
