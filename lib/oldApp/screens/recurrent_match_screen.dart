import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sandfriends/SharedComponents/Model/AppRecurrentMatch.dart';
import 'package:sandfriends/oldApp/providers/recurrent_match_provider.dart';
import 'package:sandfriends/oldApp/widgets/SF_Button.dart';
import 'package:sandfriends/oldApp/widgets/SF_RecurrentMatchCard.dart';
import 'package:sandfriends/oldApp/widgets/SF_Scaffold.dart';
import 'package:http/http.dart' as http;

import '../models/enums.dart';
import '../providers/categories_provider.dart';
import '../theme/app_theme.dart';
import '../../SharedComponents/View/SFLoading.dart';
import '../widgets/SF_RecurrentMatchDateCard.dart';

class RecurrentMatchScreen extends StatefulWidget {
  const RecurrentMatchScreen({Key? key}) : super(key: key);

  @override
  State<RecurrentMatchScreen> createState() => _RecurrentMatchScreenState();
}

class _RecurrentMatchScreenState extends State<RecurrentMatchScreen> {
  bool showModal = false;
  bool isLoading = false;

  int selectedRecurrentMatch = -1;

  @override
  void initState() {
    GetRecurrentMatches();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        context.goNamed('home', params: {'initialPage': 'feed_screen'});
        return false;
      },
      child: Scaffold(
        body: Container(
          color: AppTheme.colors.secondaryBack,
          child: isLoading
              ? Stack(
                  children: [
                    Container(
                      color: AppTheme.colors.secondaryBack,
                    ),
                    Container(
                      //loading
                      color: AppTheme.colors.primaryBlue.withOpacity(0.3),
                      child: const Center(
                        child: SFLoading(),
                      ),
                    )
                  ],
                )
              : Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top + height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryLightBlue,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.symmetric(
                                    vertical: height * 0.01,
                                    horizontal: width * 0.02,
                                  ),
                                  child: InkWell(
                                    onTap: () => context.goNamed('home',
                                        params: {'initialPage': 'feed_screen'}),
                                    child: Container(
                                      height: width * 0.1,
                                      width: width * 0.1,
                                      padding: EdgeInsets.all(width * 0.02),
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: SvgPicture.asset(
                                        r'assets\icon\arrow_left.svg',
                                        color: AppTheme.colors.secondaryBack,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: height * 0.10,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.1),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: height * 0.03,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Área do",
                                            style: TextStyle(
                                              color:
                                                  AppTheme.colors.textDarkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: height * 0.05,
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "Mensalista",
                                            style: TextStyle(
                                                color:
                                                    AppTheme.colors.textWhite,
                                                fontWeight: FontWeight.w700),
                                          ),
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
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.colors.secondaryBack,
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.colors.divider.withOpacity(0.6),
                            width: 1,
                          ),
                        ),
                      ),
                      height: height * 0.1,
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Horários",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: AppTheme.colors.textDarkGrey),
                                ),
                                Text(
                                  Provider.of<RecurrentMatchProvider>(context)
                                          .recurrentMatchesList
                                          .isEmpty
                                      ? "-"
                                      : "${Provider.of<RecurrentMatchProvider>(context).recurrentMatchesList.length}",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                      color: AppTheme.colors.secondaryLightBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: AppTheme.colors.divider,
                            height: height * 0.06,
                            width: 1,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Vencimento",
                                  textScaleFactor: 0.9,
                                  style: TextStyle(
                                      color: AppTheme.colors.textDarkGrey),
                                ),
                                Text(
                                  Provider.of<RecurrentMatchProvider>(context)
                                          .recurrentMatchesList
                                          .isEmpty
                                      ? "-"
                                      : "Dia 31",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(
                                      color: AppTheme.colors.secondaryLightBlue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.05,
                          ),
                          color: AppTheme.colors.secondaryPaper,
                          child: Provider.of<RecurrentMatchProvider>(context)
                                  .recurrentMatchesList
                                  .isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Você não tem nenhum horário mensalista.",
                                        style: TextStyle(
                                            color:
                                                AppTheme.colors.textDarkGrey),
                                      )
                                    ],
                                  ),
                                )
                              : selectedRecurrentMatch == -1
                                  ? Column(
                                      children: [
                                        Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: Provider.of<
                                                        RecurrentMatchProvider>(
                                                    context)
                                                .recurrentMatchesList
                                                .length,
                                            itemBuilder: (context, index) {
                                              return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedRecurrentMatch =
                                                          index;
                                                    });
                                                  },
                                                  child: Container(
                                                    height: 160,
                                                    child: RecurrentMatchCard(
                                                      recurrentMatch: Provider
                                                              .of<RecurrentMatchProvider>(
                                                                  context)
                                                          .recurrentMatchesList[index],
                                                      expanded: false,
                                                    ),
                                                  ));
                                            },
                                          ),
                                        ),
                                        Container(
                                          color: AppTheme.colors.secondaryPaper,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width * 0.04,
                                              vertical: height * 0.02),
                                          child: SFButton(
                                            buttonLabel:
                                                "Buscar Quadras Mensalistas",
                                            onTap: () {
                                              context.goNamed(
                                                  'recurrent_match_sport_selection_screen');
                                            },
                                            textPadding: EdgeInsets.symmetric(
                                                vertical: height * 0.01),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                selectedRecurrentMatch = -1;
                                              });
                                            },
                                            child: RecurrentMatchCard(
                                              recurrentMatch:
                                                  Provider.of<RecurrentMatchProvider>(
                                                              context)
                                                          .recurrentMatchesList[
                                                      selectedRecurrentMatch],
                                              expanded: true,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> GetRecurrentMatches() async {
    setState(() {
      isLoading = true;
    });
    const storage = FlutterSecureStorage();
    String? accessToken = await storage.read(key: "AccessToken");
    bool isNewUser = false;

    if (accessToken != null) {
      var response = await http.post(
        Uri.parse('https://www.sandfriends.com.br/UserRecurrentMatches'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, Object>{
            'AccessToken': accessToken,
          },
        ),
      );

      if (response.statusCode == 200) {
        Provider.of<RecurrentMatchProvider>(context, listen: false)
            .recurrentMatchesList
            .clear();

        Map<String, dynamic> responseBody = json.decode(response.body);
        final responseRecurrentMatches = responseBody["RecurrentMatches"];

        for (int i = 0; i < responseRecurrentMatches.length; i++) {
          Provider.of<RecurrentMatchProvider>(context, listen: false)
              .recurrentMatchesList
              .add(AppRecurrentMatch.fromJson(responseRecurrentMatches[i]));
        }

        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
