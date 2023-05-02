import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/oldApp/models/enums.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;

import '../providers/match_provider.dart';
import '../theme/app_theme.dart';
import '../../SharedComponents/View/SFLoading.dart';
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
                  child: const Center(
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

        for (int i = 0; i < responseOpenMatches.length; i++) {
          Provider.of<MatchProvider>(context, listen: false)
              .addOpenMatch(matchFromJson(responseOpenMatches[i]));
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
